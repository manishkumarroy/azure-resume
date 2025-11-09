using System;
using System.Threading.Tasks;
using Azure;
using Azure.Data.Tables;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace Company.Function
{
    public class GetResumeCounter
    {
        private readonly ILogger<GetResumeCounter> _logger;
        private readonly string connectionString;
        private readonly string tableName = "tfex-cosmos-table-azure-resume-9at1vy6ups"; // <-- Must match your Cosmos DB Table name

        public GetResumeCounter(ILogger<GetResumeCounter> logger)
        {
            _logger = logger;
            connectionString = Environment.GetEnvironmentVariable("AzureResumeConnectionString"); // reads from local.settings.json
        }

        [Function("GetResumeCounter")]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post")] object req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            try
            {
                // Connect to the table
                var serviceClient = new TableServiceClient(connectionString);
                var tableClient = serviceClient.GetTableClient(tableName);

                // Make sure table exists
                await tableClient.CreateIfNotExistsAsync();

                string partitionKey = "1";
                string rowKey = "1";

                // Try to get existing counter
                var entityResponse = await tableClient.GetEntityIfExistsAsync<TableEntity>(partitionKey, rowKey);
                int currentCount = 0;

                if (entityResponse.HasValue)
                {
                    currentCount = Convert.ToInt32(entityResponse.Value["count"]);
                    entityResponse.Value["count"] = currentCount + 1;
                    await tableClient.UpdateEntityAsync(entityResponse.Value, ETag.All, TableUpdateMode.Replace);
                }
                else
                {
                    var newEntity = new TableEntity(partitionKey, rowKey)
                    {
                        { "count", 1 }
                    };
                    await tableClient.AddEntityAsync(newEntity);
                    currentCount = 1;
                }

                return new OkObjectResult(new { count = currentCount });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error: {ex.Message}");
                return new BadRequestObjectResult("Error connecting to Cosmos DB Table.");
            }
        }
    }
}


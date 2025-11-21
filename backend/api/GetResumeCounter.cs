using System;
using System.Net;
using System.Threading.Tasks;
using Azure;
using Azure.Data.Tables;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace Company.Function
{
    public class GetResumeCounter
    {
        private readonly ILogger<GetResumeCounter> _logger;
        private readonly string? connectionString;
        private readonly string tableName = "tfex-cosmos-table-azure-resume-9at1vy6ups";

        public GetResumeCounter(ILogger<GetResumeCounter> logger)
        {
            _logger = logger;
            connectionString = Environment.GetEnvironmentVariable("AzureResumeConnectionString");
        }

        [Function("GetResumeCounter")]
        public async Task<HttpResponseData> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req)
        {
            _logger.LogInformation("Azure Function Triggered.");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "application/json");

            try
            {
                var serviceClient = new TableServiceClient(connectionString);
                var tableClient = serviceClient.GetTableClient(tableName);

                await tableClient.CreateIfNotExistsAsync();

                string partitionKey = "1";
                string rowKey = "1";

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

                await response.WriteStringAsync(JsonSerializer.Serialize(new { count = currentCount }));
                return response;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing request");
                response.StatusCode = HttpStatusCode.BadRequest;
                await response.WriteStringAsync("{\"error\": \"Failed to process request\"}");
                return response;
            }
        }
    }
}

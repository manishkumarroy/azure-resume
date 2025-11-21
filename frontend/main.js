window.addEventListener('DOMContentLoaded', (event) => {
    getVisitorCount();
})
const functionApiUrl = 'https://cloud-resume-visitor-counter-api.azurewebsites.net/api/GetResumeCounter';
const localFunctionApi = 'http://localhost:7071/api/GetResumeCounter';

const getVisitorCount = () =>{
    let count = 30
    fetch(functionApiUrl).then(response => {
        return response.json()
    }).then(response => {
        console.log("website called function API: ")
        count = response.count;
        document.getElementById("counter").innerText = count;
    }).catch(function(error){
        console.log(error)
    });
    return count;

}
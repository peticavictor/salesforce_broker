/* @RestResource is used to tell the apex that this class is exposing/consuming the Salesforce API.
    urlMapping - URL of the API that will be used to hit the APEX REST
*/

@RestResource(urlMapping='/v1/News/*')
global class NewsController {

    // GET request
    @HttpGet
    global static List<News__c> getWidgets() {
        List<News__c> news = [SELECT Id, Name, Description__c, CreatedDate from News__c where Is_Active__c = true];
        return news;
    }
}
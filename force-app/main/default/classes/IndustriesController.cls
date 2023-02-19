@RestResource(urlMapping='/v1/Industries/*')
global class IndustriesController {
    @HttpGet
    global static List<String> getIndustries() {
        String objectName = 'Account';
        String fieldName ='Industry';

        List<String> industries = new List<String>();
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            industries.add(pickListVal.getValue());
        }   
        return industries;
   }
}
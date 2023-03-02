@RestResource(urlMapping='/v1/Opportunities/*')
global class OpportunityController {
    @HttpPost 
    global static String createOpportunity(String service, String email, String cmr, String invoice, String token) {

        Contact contact;
        try {
            contact = [SELECT Id, Name, AccountId, Account.Name, Token__c FROM Contact WHERE Email = :email LIMIT 1];
        } catch (Exception e) {
            System.debug(e);
        }
        if(contact == null) {
            return '402';
        }
        System.debug('token : ' + contact.Token__c);
        if(token != contact.Token__c) {
            return '403';
        }

        List<AggregateResult> opportunitiesCount = [SELECT count(Id) FROM Opportunity WHERE AccountId = :contact.AccountId];

        Opportunity opportunity = new Opportunity();
        
        try {
            opportunity.Name = String.valueOf(contact.Account.Name) + '_' + String.valueOf(opportunitiesCount[0].get('expr0'));
            opportunity.CloseDate = Date.today() + 5;
            opportunity.StageName = 'Prospecting';
            opportunity.LeadSource = 'Web';
            opportunity.Service__c = service;
            opportunity.AccountId = String.valueOf(contact.AccountId);
            insert opportunity;

            String cmrBody = cmr.substring(cmr.indexOf(',') + 1, cmr.length());
            String invoiceBody = invoice.substring(invoice.indexOf(',') + 1, invoice.length());

            Blob pdfBlobCmr = EncodingUtil.base64Decode(cmrBody);
            Blob pdfBlobInvoice = EncodingUtil.base64Decode(invoiceBody);

            Attachment cmrAttachment = new Attachment();
            cmrAttachment.parentId = opportunity.id;
            cmrAttachment.contentType = 'application/pdf';
            cmrAttachment.name = 'cmr_' + opportunity.name + '.pdf';
            cmrAttachment.body =  pdfBlobCmr;
            insert cmrAttachment;

            Attachment invoiceAttachment = new Attachment();
            invoiceAttachment.parentId = opportunity.id;
            invoiceAttachment.contentType = 'application/pdf';
            invoiceAttachment.name = 'invoice_' + opportunity.name + '.pdf';
            invoiceAttachment.body =  pdfBlobInvoice;
            insert invoiceAttachment;

        } catch (Exception e) {
            return '402 ' + String.valueOf(e);
        }

        Opportunity opp = [SELECT Id, Name, Service__c FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];
        return String.valueOf(opp.Id);
   }
}
@RestResource(urlMapping='/v1/Accounts/*')
global class AccountController {
    @HttpGet
    global static Account getAccount() {
        Account account = [
            SELECT 
                Id, 
                Name, 
                Description,
                WebSite,
                BillingAddress,
                (SELECT Id, Name, Email, Phone FROM Contacts)
            FROM Account 
            WHERE Name = 'Corapid S.R.L.'
            LIMIT 1
        ];
        return account;
   }
}
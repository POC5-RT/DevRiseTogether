public class accountUpdate {
   @AuraEnabled
    public static void accountAddFile(Id contentId, String nameAccount, String address, string emailAddress){
        Account acc = new Account();
        acc.Name = nameAccount;
        acc.BillingCity ='Hyderabad';
        acc.BillingCountry = 'India';
        insert acc;
        
        ContentDocumentLink conLink = new ContentDocumentLink(
        ContentDocumentId = contentId,
        LinkedEntityId = acc.Id
        );
        Update conLink;
        
    }
}
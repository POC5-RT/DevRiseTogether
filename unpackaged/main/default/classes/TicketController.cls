/* Developer - Jereen Fathima .K
Purpose - To book the tickets 
*/
global without sharing class TicketController {
    @AuraEnabled
    public static Boolean ticketExists(Id contactId, Id campaignId) {
        Integer count = [SELECT COUNT() FROM Ticket__c WHERE Contact__c = :contactId AND Campaign__c = :campaignId];
        return count > 0; // Returns true if a ticket exists
    }

    @AuraEnabled
    global static void bookTicket(Id contactId, Id campaignId) {
        Ticket__c newTicket = new Ticket__c();
        newTicket.Contact__c = contactId;
        newTicket.Campaign__c = campaignId;
        insert newTicket;
    }
}

/*public without sharing class TicketController {
    @AuraEnabled
    public static Id bookTicket(Id contactId, Id campaignId) {
        // Create a new Ticket object
        Ticket__c newTicket = new Ticket__c();
        newTicket.Contact__c = contactId; // Associate with the logged-in contact
        newTicket.Campaign__c = campaignId; // Associate with the selected campaign
        
        // Insert the Ticket record
        insert newTicket;
        
        return newTicket.Id; // Return the ID of the newly created Ticket
    }
}*/
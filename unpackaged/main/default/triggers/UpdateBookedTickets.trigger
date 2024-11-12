/* Developer - Jereen Fathima .K
Purpose - To update the ticket details
*/
trigger UpdateBookedTickets on Ticket__c (after insert, after delete) {
    Set<Id> campaignIds = new Set<Id>();
    
    // Gather the campaign IDs from the ticket records
    if (Trigger.isInsert) {
        for (Ticket__c ticket : Trigger.new) {
            campaignIds.add(ticket.Campaign__c);
        }
    } 
    if (Trigger.isDelete) {
        for (Ticket__c ticket : Trigger.old) {
            campaignIds.add(ticket.Campaign__c);
        }
    }

    // Query Campaigns and update the Booked Tickets field
    List<Campaign> campaignsToUpdate = [SELECT Id, Booked_Tickets__c, Total_Tickets__c 
                                        FROM Campaign 
                                        WHERE Id IN :campaignIds];

    for (Campaign campaign : campaignsToUpdate) {
        Integer bookedTickets = [SELECT COUNT() FROM Ticket__c WHERE Campaign__c = :campaign.Id];
        campaign.Booked_Tickets__c = bookedTickets;
    }

    update campaignsToUpdate;
}
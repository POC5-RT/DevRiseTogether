/* Developer - Jereen Fathima .K
Purpose - To get the Campaign Detail and display on the site
*/
public without sharing class CampaignController {
    @AuraEnabled(cacheable=true)
    public static List<Campaign> getCampaigns(Id contactId) {
        // Retrieve the RecordTypeId of the provided Contact
         RecordType communityMemberRecordType = [
            SELECT Id 
            FROM RecordType 
            WHERE SObjectType = 'Contact'
            LIMIT 1
        ];
        Contact contact = [SELECT RecordTypeId FROM Contact WHERE Id = :contactId LIMIT 1];
      if (contact.RecordTypeId == communityMemberRecordType.Id) {
          system.debug('communityRecord');
            
       return [SELECT Id, Name, Total_Tickets__c, Booked_Tickets__c, Remaining_Tickets__c,
                       Total_Volunteer_Jobs__c, Filled_Volunteer_jobs__c, Open_Volunteer_Jobs__c,
                       StartDate, EndDate,Description, Address__c,CampaignImageId
                FROM Campaign where Type_of_the_Event__c = 'Community'
                ];
        }
       return [SELECT Id, Name, Total_Tickets__c, Booked_Tickets__c, Remaining_Tickets__c,
                       Total_Volunteer_Jobs__c, Filled_Volunteer_jobs__c, Open_Volunteer_Jobs__c,
                       StartDate, EndDate, CampaignImageId,Description, Address__c
                FROM Campaign
                ];
    }
}
/*
    8@AuraEnabled(cacheable=true)
    public static List<Campaign> getCampaigns() {
        return [SELECT Id, Name, Total_Tickets__c, Booked_Tickets__c, Remaining_Tickets__c,
                       Total_Volunteer_Jobs__c, Filled_Volunteer_jobs__c, Open_Volunteer_Jobs__c,
                       StartDate, EndDate, CampaignImageId 
                FROM Campaign
                ]; // Fetch active campaigns
    }*/

/*public with sharing class CampaignController {
    @AuraEnabled(cacheable=true)
    public static List<Campaign> getCampaigns() {
        return [SELECT Id, Name, Total_Tickets__c, Booked_Tickets__c, Remaining_Tickets__c,
                       Total_Volunteer_Jobs__c, Filled_Volunteer_jobs__c, Open_Volunteer_Jobs__c,
                       StartDate, EndDate, CampaignImageId 
                FROM Campaign
                ]; // Fetch active campaigns
    }
}*/
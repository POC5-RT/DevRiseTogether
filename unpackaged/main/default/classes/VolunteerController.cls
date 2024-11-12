// --       Projct - NPSP - Sprint2   
//---       Purpose - Added for Volunteer Status Display
//--        Developer - Sophia A    
//-------------------------------------------------------------------------------------------
 
global without sharing class VolunteerController {
          
    @AuraEnabled
    global static Volunteer__c getVolunteerByEmail(String email) {
        List<Volunteer__c> volunteerList =  [SELECT First_Name__c, Last_Name__c, Volunteer_Status__c, Approval_Status__c, Volunteer_Approver_Comments__c 
                FROM Volunteer__c 
                WHERE Email__c = :email 
                LIMIT 1];
        
        // If no volunteer is found, return null
        if (!volunteerList.isEmpty()) {
            return volunteerList[0];
        } else {
            return null;
    }
    }
    
    @AuraEnabled
    global static void createVolunteer(Volunteer__c volunteerData) {
        if (volunteerData == null) {
            throw new AuraHandledException('Volunteer data is required.');
        }

        // Additional checks and logic for the volunteerData
        insert volunteerData;
    }
}
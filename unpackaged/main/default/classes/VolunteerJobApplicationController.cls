public with sharing class VolunteerJobApplicationController {
    @AuraEnabled(cacheable=true)
    public static List<Volunteer_Job__c> getAvailableJobs(Id volunteerId) {
        Volunteer__c volunteer = [SELECT Id, Volunteer_Status__c FROM Volunteer__c WHERE Id = :volunteerId LIMIT 1];

        if (volunteer.Volunteer_Status__c != 'Active') {
            throw new AuraHandledException('Only active volunteers can view available jobs.');
        }

       /* return [SELECT Id, Job_Name__c, Description__c 
                FROM Volunteer_Job__c 
                WHERE Volunteer_Status__c = 'Available'];*/
        return null;
    }

   /* @AuraEnabled
    public static void applyForJob(Id volunteerId, Id jobId) {
        VolunteerJobHours__c jobApplication = new VolunteerJobHours__c(
            Volunteer__c = volunteerId,
            Volunteer_Job__c = jobId,
            Present__c = false,
            Hours_Worked__c = 0
        );
        insert jobApplication;
    }*/
}
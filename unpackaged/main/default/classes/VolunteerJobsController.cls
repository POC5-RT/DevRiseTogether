/* 
Developer: Jereen Fathima .K
Purpose: To get the jobs to display in the job page 
*/

global without sharing class VolunteerJobsController {
 @AuraEnabled(cacheable=true)
    global static List<Volunteer_Job__c> getVolunteerJobs() {
        return [SELECT Campaign__c,Name,Open_Jobs__c, Number_of_Postion__c FROM Volunteer_Job__c];
    }
}
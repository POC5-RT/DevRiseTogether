/**
 * Trigger Name: ContactJobRoleTrigger
 * Description: This trigger handles after insert, after update, and after delete events on the ContactJobRole__c object.
 *              It ensures that the Filled_Position__c field on the related Volunteer_Job__c records is updated to reflect
 *              the number of related ContactJobRole__c records. Additionally, it updates the Campaign's Filled_Volunteer_jobs__c
 *              field to sum the Filled_Position__c fields of all Volunteer_Job__c records linked to the Campaign.
 * 
 * Author: Jereen Fathima
 */
trigger ContactJobRoleTrigger on ContactJobRole__c (after insert, after update, after delete) {

    Set<Id> volunteerJobIds = new Set<Id>();
    Set<Id> campaignIds = new Set<Id>();

    // Handle after insert or update
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (ContactJobRole__c conJobRole : Trigger.new) {
            if (conJobRole.Volunteer_Job__c != null) {
                volunteerJobIds.add(conJobRole.Volunteer_Job__c);
            }
        }
    }

    // Handle after delete
    if (Trigger.isDelete) {
        for (ContactJobRole__c conJobRole : Trigger.old) {
            if (conJobRole.Volunteer_Job__c != null) {
                volunteerJobIds.add(conJobRole.Volunteer_Job__c);
            }
        }
    }

    // Query Volunteer_Job__c to update Filled_Position__c
    if (!volunteerJobIds.isEmpty()) {
        List<Volunteer_Job__c> volunteerJobs = [
            SELECT Id, Campaign__c, (SELECT Id FROM ContactJobRoles__r) 
            FROM Volunteer_Job__c 
            WHERE Id IN :volunteerJobIds
        ];

        List<Volunteer_Job__c> jobsToUpdate = new List<Volunteer_Job__c>();

        for (Volunteer_Job__c job : volunteerJobs) {
            // Update the filled position based on related junction records
            job.Filled_Position__c = job.ContactJobRoles__r.size();
            jobsToUpdate.add(job);
            campaignIds.add(job.Campaign__c);  // Collect Campaign IDs
        }

        // Update the jobs in a single DML operation
        if (!jobsToUpdate.isEmpty()) {
            update jobsToUpdate;
        }
    }

    // Update Campaign's Total Filled Positions
    if (!campaignIds.isEmpty()) {
        List<Campaign> campaignsToUpdate = [
            SELECT Id, (SELECT Filled_Position__c FROM Volunteer_Jobs__r)
            FROM Campaign
            WHERE Id IN :campaignIds
        ];

        List<Campaign> campaignsToUpdateList = new List<Campaign>();

        for (Campaign campaign : campaignsToUpdate) {
            Decimal totalFilledPositions = 0;
            for (Volunteer_Job__c job : campaign.Volunteer_Jobs__r) {
                if (job.Filled_Position__c != null) {  // Null check to avoid NullPointerException
                    totalFilledPositions += job.Filled_Position__c;  // Summing all positions as Decimal
                }
            }
            campaign.Filled_Volunteer_jobs__c = totalFilledPositions;
            campaignsToUpdateList.add(campaign);
        }

        // Perform DML update on Campaign
        if (!campaignsToUpdateList.isEmpty()) {
            update campaignsToUpdateList;
        }
    } 
}
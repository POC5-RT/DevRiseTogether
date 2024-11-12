trigger ContactVolunteerJobTrigger on Contact (after insert, after update, after delete) {
 /*   
    Set<Id> volunteerJobIds = new Set<Id>();
    Set<Id> campaignIds = new Set<Id>();  // To store Campaign IDs for later update

    // Handle after insert or update
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Contact con : Trigger.new) {
            if (con.Volunteer_Job__c != null) {
                volunteerJobIds.add(con.Volunteer_Job__c);
            }
        }
    }

    // Handle after delete
    if (Trigger.isDelete) {
        for (Contact con : Trigger.old) {
            if (con.Volunteer_Job__c != null) {
                volunteerJobIds.add(con.Volunteer_Job__c);
            }
        }
    }

    // Query Volunteer_Job__c to update Filled_Position__c
    if (!volunteerJobIds.isEmpty()) {
        List<Volunteer_Job__c> volunteerJobs = [
            SELECT Id, Campaign__c, (SELECT Id FROM Contacts__r) 
            FROM Volunteer_Job__c 
            WHERE Id IN :volunteerJobIds
        ];

        List<Volunteer_Job__c> jobsToUpdate = new List<Volunteer_Job__c>();

        for (Volunteer_Job__c job : volunteerJobs) {
            // Update the filled position based on related contacts
            job.Filled_Position__c = job.Contacts__r.size();
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
    }*/
}

/*trigger ContactVolunteerJobTrigger on Contact (after insert, after update, after delete) {
    
    Set<Id> volunteerJobIds = new Set<Id>();

    // Handle after insert or update
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Contact con : Trigger.new) {
            if (con.Volunteer_Job__c != null) {
                volunteerJobIds.add(con.Volunteer_Job__c);
            }
        }
    }

    // Handle after delete
    if (Trigger.isDelete) {
        for (Contact con : Trigger.old) {
            if (con.Volunteer_Job__c != null) {
                volunteerJobIds.add(con.Volunteer_Job__c);
            }
        }
    }

    // Query Volunteer_Job__c to update Filled_Position__c
    if (!volunteerJobIds.isEmpty()) {
        List<Volunteer_Job__c> volunteerJobs = [
            SELECT Id,Campaign__c, (SELECT Id FROM Contacts__r) 
            FROM Volunteer_Job__c 
            WHERE Id IN :volunteerJobIds
        ];

        List<Volunteer_Job__c> jobsToUpdate = new List<Volunteer_Job__c>();

        for (Volunteer_Job__c job : volunteerJobs) {
            // Update the filled position based on related contacts
            job.Filled_Position__c = job.Contacts__r.size();
            jobsToUpdate.add(job);
        }

        // Update the jobs in a single DML operation
        if (!jobsToUpdate.isEmpty()) {
            update jobsToUpdate;
        }
    }
}*/
trigger VolunteerCountTrigger on Volunteer_Job__c (after insert, after update, after delete) {
    Set<Id> campaignIds = new Set<Id>();
    
    // Collect Campaign__c IDs for insert and update operations
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Volunteer_Job__c vol : Trigger.new) {
            if (vol.Campaign__c != NULL) {
                campaignIds.add(vol.Campaign__c);
            }
        }
    }
    
    // Collect Campaign__c IDs for delete operations
    if (Trigger.isDelete) {
        for (Volunteer_Job__c vol : Trigger.old) {
            if (vol.Campaign__c != NULL) {
                campaignIds.add(vol.Campaign__c);
            }
        }
    }
    
    // Fetch aggregate data of Volunteer Jobs grouped by Campaign__c
    List<AggregateResult> campaignAggregate = [
        SELECT SUM(Number_of_Postion__c) sumjobs, Campaign__c 
        FROM Volunteer_Job__c 
        WHERE Campaign__c IN :campaignIds
        GROUP BY Campaign__c
    ];
    
    // Fetch the campaign records to be updated
    Map<Id, Campaign> campaignMap = new Map<Id, Campaign>([
        SELECT Id, Total_Volunteer_Jobs__c FROM Campaign WHERE Id IN :campaignIds
    ]);
    
    // Update the campaignMap with the sum of Volunteer Jobs
    for (AggregateResult ar : campaignAggregate) {
        Id campaignId = (Id) ar.get('Campaign__c');
        if (campaignMap.containsKey(campaignId)) {
            campaignMap.get(campaignId).Total_Volunteer_Jobs__c = (Decimal) ar.get('sumjobs');
        }
    }
    
    // Update the campaigns
    if (!campaignMap.isEmpty()) {
        update campaignMap.values();
    }
}

/*trigger VolunteerCountTrigger on Volunteer_Job__c (after insert,after Update,after delete) {
    set<Id> campaignIds = new set<Id>();
    if (Trigger.isInsert || Trigger.isUpdate)
    {
        for(Volunteer_Job__c vol:Trigger.new){
            if(vol.Campaign__c!=NULL){
                campaignIds.add(vol.Campaign__c);
            }
        }
    }
     if (Trigger.isDelete) {
        for(Volunteer_Job__c vol:Trigger.old){
            if(vol.Campaign__c!=NULL){
                campaignIds.add(vol.Campaign__c);
            }
        } 
     }
   List<AggregateResult> campaignAggregate = [select sum(Number_of_Postion__c)sumjobs,Campaign__c from Volunteer_Job__c 
                                              where Campaign__c in :campaignIds
                                              Group by Campaign__c];
    List<campaign> campaignJobList = [select Total_Volunteer_Jobs__c from campaign where id in :campaignIds];
    for(AggregateResult ar:campaignAggregate){
        campaign newcamp = new campaign();
        newcamp.Id = (Id)ar.get('Campaign__c');
        newcamp.Total_Volunteer_Jobs__c =(Decimal)ar.get('sumjobs');
        campaignJobList.add(newcamp);
    }
    update campaignJobList;
    
}*/
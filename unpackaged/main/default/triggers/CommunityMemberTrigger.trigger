// *** @Author : Bhargavi
// *** @Project : RiseTogether
// *** Purpose : To send Welcome email to Community Members

trigger CommunityMemberTrigger on Community_Member__c (after insert) {
    Switch on Trigger.operationType {
        When After_Insert{
            CommunityMemberTriggerHandler.handleafterInsert(Trigger.new);
            
        }
    }
    

}
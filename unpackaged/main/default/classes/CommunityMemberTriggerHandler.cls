// *** @Author : Bhargavi
// *** @Project : RiseTogether
// *** @Date : 08/oct/2024
// *** Purpose : To send Welcome email to Community Members

public class CommunityMemberTriggerHandler {
    public static void handleafterInsert(List<Community_Member__c> newCommunityMembers){
        CommunityMemberWelcomeEmailUtility.sendWelcomeEmail(newCommunityMembers);
    }

}
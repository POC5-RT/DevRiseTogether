//--------------Community Member Registration Form--------
//Developer ---Sophia A.
//Project - NPSP- Sprint1 & 2
//Purpose -  To check the uniqueness of Email and to Fetch Member Details using Email
// --------------------------------------------------

global without sharing class CommunityMemberController
{
//----NPSP --- Added For Sprint1
    @AuraEnabled
    global static Boolean isEmailUnique(String email) {
        List<Community_Member__c> existingMembers = [SELECT Id FROM Community_Member__c WHERE Email__c = :email LIMIT 1];
        return existingMembers.isEmpty();  
    }
//---NPSP ---- Added For Sprint2
    @AuraEnabled
    global static Community_Member__c getMemberByEmail(String email) {
        List<Community_Member__c> memberList = [
            SELECT First_Name__c, Last_Name__c, Member_Status__c, Approval_Status__c, CommMember_Approver_Comments__c 
            FROM Community_Member__c 
            WHERE Email__c = :email 
            LIMIT 1
        ];
        
        // If no member is found, return null
        if (!memberList.isEmpty()) {
            return memberList[0];
        } else {
            return null;
        }
    }

}
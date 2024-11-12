// *** @Author : Bhargavi
// *** @Project : RiseTogether
// *** @Date : 08/oct/2024
// *** Purpose : Test class for sending Welcome email to Community Members

@IsTest
public class CommunityMemberTriggerTestClass {
    @IsTest
    static void testSendWelcomeEmail() {
        // Create a test Community Member record with a valid email
        Community_Member__c communitymember = new Community_Member__c(
            Last_Name__c = 'Doe',
            Email__c = 'bhrgavi90900@gmail.com',
            Username__c = 'TestUsername@gmail.com',
            Aadhar_Number__c = '000989097564',
            Phone__c = '8975557878',
            BirthDate__c = Date.parse('21/08/1999') // Use the correct date format
        );
        insert communityMember;
        
        Community_Member__c insertedmember = [Select Id,Email__c, Name,Last_Name__c, Username__c,Approval_Status__c,Member_Status__c FROM Community_Member__c Where id=:communityMember.Id LIMIT 1];
        
        // Track email invocations before the test
        Integer emailInvocationsBefore = Limits.getEmailInvocations();
        
        // Run the email sending method
        CommunityMemberWelcomeEmailUtility.sendWelcomeEmail(new List<Community_Member__c>{ insertedmember });
        
        // Verify that one email was sent
        Integer emailInvocationsAfter = Limits.getEmailInvocations();
        System.assertEquals(1, emailInvocationsAfter - emailInvocationsBefore, 'One email should have been sent.');
    }
}
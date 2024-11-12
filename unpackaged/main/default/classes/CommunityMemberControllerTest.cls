//Project - NPSP
//Developer - Sophia A
//Purpose : Test class for CommunityMemberController
//
@isTest
private class CommunityMemberControllerTest {

    @testSetup
    static void setupData() {
        // Insert a test community member record
        Community_Member__c member = new Community_Member__c(
            First_Name__c = 'Alice',
            Last_Name__c = 'Smith',
            Member_Status__c = 'Active',
            Approval_Status__c = 'Approved',
            CommMember_Approver_Comments__c = 'Good member',
            Email__c = 'alice@example.com',
            Phone__c = '1234567890',
            Gender__c = 'Female',
            BirthDate__c = Date.newInstance(1990, 1, 1) // Required field
        );
        insert member;
    }

    @isTest
    static void testIsEmailUnique() {
        // Create a test community member with required fields
        Community_Member__c existingMember = new Community_Member__c(
            First_Name__c = 'Alice',
            Last_Name__c = 'Doe',                // Required field
            Phone__c = '1234567890',           // Required field
            BirthDate__c = Date.newInstance(1990, 1, 1),
            Gender__c = 'Female',     // Required field
            Email__c = 'test@example.com'        // Email field for uniqueness check
        );
        insert existingMember;

        // Call the isEmailUnique method with the same email
        Boolean isUnique = CommunityMemberController.isEmailUnique('test@example.com');

        // Verify that the method returns false, indicating the email is not unique
        System.assertEquals(false, isUnique, 'Expected email to be not unique, but it was unique.');

        // Call the isEmailUnique method with a different email
        Boolean isUniqueNewEmail = CommunityMemberController.isEmailUnique('newemail@example.com');

        // Verify that the method returns true, indicating the email is unique
        System.assertEquals(true, isUniqueNewEmail, 'Expected email to be unique, but it was not unique.');
    }

    @isTest
    static void testGetMemberByEmail_Found() {
        // Call the method with the email that matches the test community member
        Community_Member__c result = CommunityMemberController.getMemberByEmail('alice@example.com');
        
        // Assert that a record is returned
        System.assertNotEquals(null, result, 'Community Member record should not be null');
        
        // Assert the returned record's fields
        System.assertEquals('Alice', result.First_Name__c, 'First name should match');
        System.assertEquals('Smith', result.Last_Name__c, 'Last name should match');
        System.assertEquals('Active', result.Member_Status__c, 'Member status should match');
        System.assertEquals('Approved', result.Approval_Status__c, 'Approval status should match');
        System.assertEquals('Good member', result.CommMember_Approver_Comments__c, 'Approver comments should match');
    }

    @isTest
    static void testGetMemberByEmail_NotFound() {
        // Call the method with an email that does not match any community member record
        Community_Member__c result = CommunityMemberController.getMemberByEmail('notfound@example.com');
        
        // Assert that no record is returned
        System.assertEquals(null, result, 'Community Member record should be null');
    }
}


/*@isTest
private class CommunityMemberControllerTest
{

    @isTest
    
        
        static void testIsEmailUnique() {
        // Create a test community member with required fields
        Community_Member__c existingMember = new Community_Member__c(
            Last_Name__c = 'Doe',                // Required field
            Phone__c = '123-456-7890',           // Required field
            BirthDate__c = Date.newInstance(1990, 1, 1), // Required field
            Email__c = 'test@example.com'        // Email field for uniqueness check
        );
        insert existingMember;

        // Call the isEmailUnique method with the same email
        Boolean isUnique = CommunityMemberController.isEmailUnique('test@example.com');

        // Verify that the method returns false, indicating the email is not unique
        System.assertEquals(false, isUnique, 'Expected email to be not unique, but it was unique.');

        // Call the isEmailUnique method with a different email
        Boolean isUniqueNewEmail = CommunityMemberController.isEmailUnique('newemail@example.com');

        // Verify that the method returns true, indicating the email is unique
        System.assertEquals(true, isUniqueNewEmail, 'Expected email to be unique, but it was not unique.');
    }
    
    @isTest
    static void testGetMemberByEmail_Found() {
        // Call the method with the email that matches the test community member
        Community_Member__c result = CommunityMemberController.getMemberByEmail('alice@example.com');
        
        // Assert that a record is returned
        System.assertNotEquals(null, result, 'Community Member record should not be null');
        
        // Assert the returned record's fields
        System.assertEquals('Alice', result.First_Name__c, 'First name should match');
        System.assertEquals('Smith', result.Last_Name__c, 'Last name should match');
        System.assertEquals('Active', result.Member_Status__c, 'Member status should match');
        System.assertEquals('Approved', result.Approval_Status__c, 'Approval status should match');
        System.assertEquals('Good member', result.CommMember_Approver_Comments__c, 'Approver comments should match');
    }

    @isTest
    static void testGetMemberByEmail_NotFound() {
        // Call the method with an email that does not match any community member record
        Community_Member__c result = CommunityMemberController.getMemberByEmail('notfound@example.com');
        
        // Assert that no record is returned
        System.assertEquals(null, result, 'Community Member record should be null');
    }
}*/
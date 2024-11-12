// --       Projct - NPSP - Sprint2   
//---       Purpose - Tets class for the Apex class ,Added for Volunteer Status Display
//--        Developer - Sophia A    
//-------------------------------------------------------------------------------------------
@isTest
private class VolunteerControllerTest {
    
    @testSetup
    static void setupData() {
        // Insert a test volunteer record with specific availability days
        Volunteer__c volunteer = new Volunteer__c(
            First_Name__c = 'John',
            Last_Name__c = 'Doe',
            Volunteer_Status__c = 'Active',
            Approval_Status__c = 'Approved',
            Volunteer_Approver_Comments__c = 'Good standing',
            Email__c = 'johndoe@example.com',
            Birth_Date__c = Date.newInstance(1990, 1, 1),
            Availability_Days__c = 'Monday'
        );
        insert volunteer;
    }

    @isTest
    static void testGetVolunteerByEmail_Found() {
        // Call the method with the email that matches the test volunteer
        Volunteer__c result = VolunteerController.getVolunteerByEmail('johndoe@example.com');
        
        // Assert that a record is returned
        System.assertNotEquals(null, result, 'Volunteer record should not be null');
        
        // Assert the returned record's fields
        System.assertEquals('John', result.First_Name__c, 'First name should match');
        System.assertEquals('Doe', result.Last_Name__c, 'Last name should match');
        System.assertEquals('Active', result.Volunteer_Status__c, 'Volunteer status should match');
        System.assertEquals('Approved', result.Approval_Status__c, 'Approval status should match');
        System.assertEquals('Good standing', result.Volunteer_Approver_Comments__c, 'Approver comments should match');
        
    }

    @isTest
    static void testGetVolunteerByEmail_NotFound() {
        // Call the method with an email that does not match any volunteer record
        Volunteer__c result = VolunteerController.getVolunteerByEmail('notfound@example.com');
        
        // Assert that no record is returned
        System.assertEquals(null, result, 'Volunteer record should be null');
    }
    
    @isTest
    static void testCreateVolunteer_Success() {
        // Create a new Volunteer__c record
        Volunteer__c newVolunteer = new Volunteer__c(
            First_Name__c = 'Jane',
            Last_Name__c = 'Smith',
            Volunteer_Status__c = 'Active',
            Approval_Status__c = 'Pending',
            Email__c = 'janesmith@example.com',
            Birth_Date__c = Date.newInstance(1995, 5, 15),
            Availability_Days__c = 'Tuesday'
        );

        // Call the createVolunteer method
        Test.startTest();
        VolunteerController.createVolunteer(newVolunteer);
        Test.stopTest();

        // Verify that the record was inserted
        Volunteer__c insertedVolunteer = [SELECT Id, First_Name__c, Last_Name__c, Volunteer_Status__c 
                                          FROM Volunteer__c 
                                          WHERE Email__c = 'janesmith@example.com' 
                                          LIMIT 1];
        System.assertNotEquals(null, insertedVolunteer, 'New volunteer should be inserted');
        System.assertEquals('Jane', insertedVolunteer.First_Name__c, 'First name should match');
    }
}
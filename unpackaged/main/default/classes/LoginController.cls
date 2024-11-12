/* Developer - Jereen Fathima .K
Purpose - To check the credentials with the data base
*/

global without sharing class LoginController {

   
@AuraEnabled
global static Contact loginUser(String username, String password) {
    // Query to find the Contact based on the provided username
    Contact con = [SELECT Id, Name, Password__c, RecordTypeId, Is_Volunteer__c FROM Contact WHERE Username__c = :username LIMIT 1];
    
    // Check if contact exists and password matches
    if (con != null && con.Password__c == password) {
        return con; // Return the Contact object
    }
    
    return null; // Return null if login fails
}

    @AuraEnabled
    global static void sendForgotPasswordEmail(String username) {
        Contact con = [SELECT Id, Email FROM Contact WHERE Email = :username LIMIT 1];
        if (con != null) {
            // Logic to send the email with a reset link or temporary password
            // EmailManager.sendResetEmail(con.Email);
        } else {
            throw new AuraHandledException('Contact not found with the provided username.');
        }
    }

    @AuraEnabled
    global static void resetPassword(String username, String oldPassword, String newPassword) {
        Contact con = [SELECT Id, Password__c FROM Contact WHERE Email = :username LIMIT 1];
        if (con != null && con.Password__c == oldPassword) {
            con.Password__c = newPassword;
            update con;
        } else {
            throw new AuraHandledException('Old password is incorrect.');
        }
    }
}
public with sharing class CustomContactLoginController {
    public String email { get; set; }
    public String password { get; set; }

    public PageReference login() {
        // Query the Contact using the provided email
        Contact contact = [SELECT Id, Email, Password__c FROM Contact WHERE Email = :email LIMIT 1];

        // Check if the password matches
        if (contact != null && contact.Password__c == password) {
            // Create a User record if needed or handle the login
            // For now, you can simply redirect to a home page or another page
            return new PageReference('/yourExperienceSiteHomePage'); // Update with your actual Experience site home page URL
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Login failed: Invalid email or password.'));
            return null;
        }
    }
}
// ***@Author : Bhargavi
// *** Date : 24-Oct-2024
// ***Purpose : To generate unique random password for approved Community Member

public class CommunityMemberPasswordGenerator {
    
    public class GeneratedPassword {
        @InvocableVariable
        public string password; // variable to hold the generated Password
    }
    
    @InvocableMethod (label='Unique Password Generator for Community Member')
    public static List<GeneratedPassword> generatePasswordsforMember(List<Contact> lstContacts){
        List<GeneratedPassword> result = new List<GeneratedPassword>();
        
        // Generate credentials for each contact
        for (Contact contact : lstContacts){
            GeneratedPassword memberPassword = new GeneratedPassword();
            memberPassword.password = generateUniquePassword(); // Generates a unique password
            result.add(memberPassword);
        }
        return result;          
    }
    
    //Method to generate Unique Password for Community member
    
    private static string generateUniquePassword()
    {
        string password;
        Integer maxAttempts=10; // Limit on attempts to generate a unique password
        
        //Query Existing password on Contact
        Set<String> existingPasswords = new Set<String>();
        for (Contact cont : [Select Id, Password__c From Contact Where Password__c != Null]){
            existingPasswords.add(cont.Password__c);
        }
        
        //Keep generating passwords until a unique one is found or max attempts are reached
        
        for (Integer i = 1 ; i<=maxAttempts; i++){
            password= generateRandomPassword();
            
            if(!existingPasswords.contains(password)){
                return password;
            }
        }
        // If unique password not found, throw an exception
        throw new UniquePasswordGenerationException('Unable to generate a unique password after ' + maxAttempts + ' attempts.');
    }
    
    // Method to generate a random password
    private static String generateRandomPassword() {
        Integer passwordLength = 8; // Length of the password
        String validChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$&.?%';
        String password = '';
        
        for (Integer i = 0; i < passwordLength; i++) {
            Integer randomIndex = Math.mod(Math.abs(Crypto.getRandomInteger()), validChars.length());
            password += validChars.substring(randomIndex, randomIndex + 1);
        }
        
        return password;       
    }
    
    // Custom Exception to handle unique password generation errors
    public class UniquePasswordGenerationException extends Exception {}
}
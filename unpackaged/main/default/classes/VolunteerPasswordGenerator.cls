// ***@Author :Prathyusha
    // *** Date : 24-Oct-2024
    // ***Purpose : To generate unique random password for approved Volunteer 
    public class VolunteerPasswordGenerator {
        
        public class VolGeneratedPassword {
            @InvocableVariable
            public string password; // variable to hold the generated Password
        }
        
        @InvocableMethod (label='Unique Password Generator for Volunteer')
        public static List<VolGeneratedPassword> generatePasswordsforVolunteer(List<Contact> lstContacts){
            List<VolGeneratedPassword> result = new List<VolGeneratedPassword>();
            
            // Generate credentials for each contact
            for (Contact contact : lstContacts){
                VolGeneratedPassword VolunteerPassword = new VolGeneratedPassword();
                VolunteerPassword.password = VolgenerateUniquePassword(); // Generates a unique password
                result.add(VolunteerPassword);
            }
            return result;          
        }
        
        //Method to generate Unique Password for Volunteer
        
        private static string VolgenerateUniquePassword()
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
                password= VolgenerateRandomPassword();
                
                if(!existingPasswords.contains(password)){
                    return password;
                }
            }
            // If unique password not found, throw an exception
            throw new VolUniquePasswordGenerationException('Unable to generate a unique password after ' + maxAttempts + ' attempts.');
        }
        
        // Method to generate a random password
        private static String VolgenerateRandomPassword() {
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
        public class VolUniquePasswordGenerationException extends Exception {}
    }
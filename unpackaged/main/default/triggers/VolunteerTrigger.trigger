trigger VolunteerTrigger on Volunteer__c (before insert, before update) {
    // Set to hold guardian email IDs for validation
    Set<String> guardianEmails = new Set<String>();

    // Populate the set with guardian emails from the incoming volunteer records, only for age <= 13
    for (Volunteer__c volunteer : Trigger.new) {
        if (volunteer.Guardian_Email__c != null && volunteer.Birth_Date__c != null) {
            Integer age = Date.today().year() - volunteer.Birth_Date__c.year();
            // Adjust if the birth date hasn't occurred yet this year
            if (Date.today() < volunteer.Birth_Date__c.addYears(age)) {
                age--;
            }
            if (age <= 13) {
                guardianEmails.add(volunteer.Guardian_Email__c);
            } else {
                // Skip further processing for ages over 13
                continue;
            }
        }
    }

    // Query existing volunteers to check for matching guardian emails
    Map<String, Volunteer__c> guardianEmailMap = new Map<String, Volunteer__c>();
    if (!guardianEmails.isEmpty()) {
        for (Volunteer__c guardian : [SELECT Id, Email__c FROM Volunteer__c WHERE Email__c IN :guardianEmails AND Age__c > 13]) {
            guardianEmailMap.put(guardian.Email__c, guardian);
        }
    }

    // Iterate over the new volunteers to set the lookup relationship and validate emails
    for (Volunteer__c volunteer : Trigger.new) {
        Integer age = Date.today().year() - volunteer.Birth_Date__c.year();
        if (Date.today() < volunteer.Birth_Date__c.addYears(age)) {
            age--;
        }

        // Only proceed if age is <= 13
        if (age <= 13) {
            // Check if the guardian email is valid
            if (volunteer.Guardian_Email__c != null) {
                if (guardianEmailMap.containsKey(volunteer.Guardian_Email__c)) {
                    // Populate the Parent_Guardian__c lookup field if email is valid
                    volunteer.Parent_Guardian__c = guardianEmailMap.get(volunteer.Guardian_Email__c).Id;
                } else {
                    // Throw an error if the guardian email is invalid
                    volunteer.addError('The guardian email "' + volunteer.Guardian_Email__c + '" does not match any existing guardian.');
                }
            } else {
                // Throw an error if guardian email is not provided
                volunteer.addError('Guardian email must be provided.');
            }
        }
    }
}

/*trigger VolunteerTrigger on Volunteer__c (before insert, before update) {
    // Set to hold guardian email IDs for validation
    Set<String> guardianEmails = new Set<String>();

    // Populate the set with guardian emails from the incoming volunteer records
  for (Volunteer__c volunteer : Trigger.new) {
    if (volunteer.Guardian_Email__c != null && volunteer.Birth_Date__c != null) {
        Integer age = Date.today().year() - volunteer.Birth_Date__c.year();
        // Adjust if the birth date hasn't occurred yet this year
        if (Date.today() < volunteer.Birth_Date__c.addYears(age)) {
            age--;
        }
        if (age <= 13) {
            guardianEmails.add(volunteer.Guardian_Email__c);
        }
    }
}

    // Query existing volunteers to check for matching guardian emails
    Map<String, Volunteer__c> guardianEmailMap = new Map<String, Volunteer__c>();
    if (!guardianEmails.isEmpty()) {
        for (Volunteer__c guardian : [SELECT Id, Email__c FROM Volunteer__c WHERE Email__c IN :guardianEmails AND Age__c>13]) {
            guardianEmailMap.put(guardian.Email__c, guardian);
        }
    }

    // Iterate over the new volunteers to set the lookup relationship and validate emails
    for (Volunteer__c volunteer : Trigger.new) {
        // Check if the guardian email is valid
        if (volunteer.Guardian_Email__c != null) {
            if (guardianEmailMap.containsKey(volunteer.Guardian_Email__c)) {
                // Populate the Parent_Guardian__c lookup field if email is valid
                volunteer.Parent_Guardian__c = guardianEmailMap.get(volunteer.Guardian_Email__c).Id;
            } else {
                // Throw an error if the guardian email is invalid
                volunteer.addError('The guardian email "' + volunteer.Guardian_Email__c + '" does not match any existing guardian.');
            }
        } else {
            // Throw an error if guardian email is not provided
            volunteer.addError('Guardian email must be provided.');
        }
    }
}*/
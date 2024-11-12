// *********************Community Member Registration Form****************
//Developed by : Sophia 
//Date 08/10/2024
//Project - NPSP
//Purpose - To create a new member registration form
// *********************************************************************
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import isEmailUnique from '@salesforce/apex/CommunityMemberController.isEmailUnique';

export default class RegistrationFormForCommunity extends LightningElement
 {
    @track salutation = '';
    @track firstName = ''; // To hold the First Name
    @track lastName = ''; // To hold the Last Name
    @track gender = '';
    @track email = ''; // To hold the Email
    @track dob = ''; // To hold the Date of Birth
    //Referred_By__c
   @track  referredBy = '';
   @track address = {}; // New property for address
   strStreet;
   strCity;
   strState;
   strCountry;
   strPostalCode;
  
        @track phoneNumber = ''; // To hold the Phone number
        @track recordId; // To hold the created record ID
        
        @track showFileUpload = false; // To control file upload visibility
        @track isSubmitDisabled = false; // Track submit button disabled state

        get options() {
            return [
                { label: 'Mr.', value: 'Mr.' },
                { label: 'Mrs.', value: 'Mrs.' },
                { label: 'Ms.', value: 'Ms.' },
            ];
        }

        get genderoptions() {
            return [
                { label: 'Female', value: 'Female' },
                { label: 'Male', value: 'Male' },
                { label: 'Others', value: 'Others' },
                { label: 'Prefer not to say', value: 'Prefer not to say' },
            ];
        }
    
        get acceptedFormats() {
            return ['.jpeg', '.png'];
        }

        // For Address Options begin

        // code added for address
    countryOptions = [
    { label: 'India', value: 'IN' },
            { label: 'United States', value: 'US' },
];

// Track the selected country and provide corresponding province options
@track _country = 'US';

provinceOptions = {
    'IN': [
        { label: 'Andhra Pradesh', value: 'AP' },
        { label: 'Arunachal Pradesh', value: 'AR' },
        { label: 'Assam', value: 'AS' },
        { label: 'Bihar', value: 'BR' },
        { label: 'Chandigarh', value: 'CH' },
        { label: 'Delhi', value: 'DL' },
        { label: 'Goa', value: 'GA' },
        { label: 'Telangana', value: 'TG' },
        { label: 'Tamil Nadu', value: 'TN' },
        { label: 'West Bengal', value: 'WB' },

        
    ],
    'US': [
        { label: 'Alaska', value: 'AK' },
        { label: 'Alabama', value: 'AL' },
        { label: 'California', value: 'CA' },
        { label: 'Connecticut', value: 'CT' },
        { label: 'California', value: 'CA' },
        { label: 'Florida', value: 'FL' },
        { label: 'Georgia', value: 'GA' },
        { label: 'Iowa', value: 'IA' },
        { label: 'Massachusetts', value: 'MA' },
        { label: 'Washington', value: 'WA' },
    ]
};

get getcountryOptions() {
    return this.countryOptions;
}

get getProvinceOptions() {
    return this.provinceOptions[this._country] || [];
}

        
        handleSalutationChange(event) {
            this.salutation = event.target.value; // Capture Salutation input value
        }
    
        handleFirstNameChange(event) {
            this.firstName = event.target.value; // Capture First Name input value
        }

        handleLastNameChange(event) {
            this.lastName = event.target.value; // Capture First Name input value
        }

        handleGenderChange(event) {
            this.gender = event.target.value; // Capture Gender input value
        }

        handleEmailChange(event) {
            this.email = event.target.value; // Capture Email input value
        }

        handleDobChange(event) {
            this.dob = event.target.value; // Capture DOB input value
            // Check if the birth date is in the future
        const today = new Date();
        const dobDate = new Date(this.dob);

        this.dobError = dobDate > today; // Set the error flag based on the check
        }

         
        handlePhoneNumberChange(event) {
            this.phoneNumber = event.target.value; // Capture Phone input value
        }

     

        handleReferredByChange(event) {
            this.referredBy = event.target.value; // Capture Referred By input value
        }
//Form Submission
            
    handleSubmit(event)
{
            // Prevent default submit
            event.preventDefault();
            // Get all the input fields
    const allFieldsValid = [...this.template.querySelectorAll('lightning-input, lightning-combobox')]
    .reduce((validSoFar, inputCmp) => {
        inputCmp.reportValidity();  // Show validation messages
        return validSoFar && inputCmp.checkValidity();  // Check validity
    }, true);
    //console.error('before date check');

// Check if all fields are valid
if (allFieldsValid) {
    // Perform additional custom validation like checking if DOB is in the future
    const today = new Date();
    const dobDate = new Date(this.dob);

    if (dobDate > today) {
        this.dobError = true;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Date of Birth cannot be in the future.',
                variant: 'error',
            })
        );
        return;
    } else {
        this.dobError = false;
    }

    //console.error('before email check');
    isEmailUnique({ email: this.email })
            .then(isUnique => {
                console.error('inside email check');
                if (!isUnique) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Email already exists. Please provide a unique email address.',
                            variant: 'error',
                        })
                    );
                } else {
                    //console.error('else email check');
                    //submit
                    //console.error('before submission');
                    const fieldValues = event.detail.fields;
                        fieldValues.Salutation__c = this.salutation;
                        fieldValues.First_Name__c = this.firstName; // Set First Name
                        fieldValues.Last_Name__c = this.lastName; // Set Last Name
                        fieldValues.Gender__c = this.gender; // Set First Name
                        fieldValues.BirthDate__c = this.dob; // Set Date of Birth
                        fieldValues.Email__c = this.email; // Set Email
                        fieldValues.Approval_Status__c = 'Pending'; // Set Approval Status to Pending
                        fieldValues.Member_Status__c = 'Inactive'; // Set Member Status to Pending
                        fieldValues.Phone__c = this.phoneNumber; // Set Phone number
                        // for address fields
                        fieldValues.Address__Street__s = this.strStreet;
                            fieldValues.Address__City__s = this.strCity;
                            fieldValues.Address__StateCode__s = this.strState;
                            fieldValues.Address__CountryCode__s = this.strCountry;
                            fieldValues.Address__PostalCode__s = this.strPostalCode;
                            //console.error('after address');
                            //console.error('street is'+fieldValues.Address__Street__s);
                           //console.error('city is'+fieldValues.Address__City__s);
                           //console.error('province is'+fieldValues.Address__StateCode__s);
                           //console.error('country is'+fieldValues.Address__CountryCode__s);
                           //console.error('postal is'+fieldValues.Address__PostalCode__s); 

                       
                        fieldValues.Referred_By__c = this.referredBy; // Set Referred By

                        
                        this.template.querySelector('lightning-record-edit-form').submit(fieldValues);

                }
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'An error occurred while checking email uniqueness: ' + error.body.message,
                        variant: 'error',
                    })
                );
            });
    } else {
        // Show error message if not all fields are valid
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Please complete all required fields and correct any validation errors.',
                variant: 'error',
            })
        );
    }
}

addressInputChange( event ) {
    
    this._country = event.target.country;
this.strStreet = event.target.street;
this.strCity = event.target.city;
this.strState = event.target.province;
this.strCountry = event.target.country;
this.strPostalCode = event.target.postalCode;


}
                     
    
        handleSuccess(event) {
            // Capture the created Record Id
            this.recordId = event.detail.id;
    
            // Show success toast message
            const toastEvent = new ShowToastEvent({
                title: 'Success',
                message: 'Community Member details added successfully!',
                variant: 'success',
            });
            this.dispatchEvent(toastEvent);
    
            // Disable the submit button
            this.isSubmitDisabled = true;
    
            // Display the file upload section
            this.showFileUpload = true;
        }
    
        handleError(event) {
            // Show error toast message
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'Error occurred while creating the record: ' + event.detail.message,
                variant: 'error',
            });
            this.dispatchEvent(toastEvent);
    
            
            console.error('Error occurred while creating record:', event.detail);
        }
    
        handleUploadFinished(event) {
            // Handle file upload completion
            const uploadedFiles = event.detail.files;
    
            const toastEvent = new ShowToastEvent({
                title: 'Success',
                message: uploadedFiles.length + ' File uploaded successfully.',
                variant: 'success',
            });
            this.dispatchEvent(toastEvent);
            

            // Call the method to "refresh" the form
        this.refreshForm();
            
            
        }

        refreshForm() {
            
            // Reset the input fields
            this.aadhar = ''; // Reset Aadhar
            this.phoneNumber = ''; // Reset Phone number
            this.firstName = ''; // Reset the First Name value
            this.lastName = '';
            this.salutation = '';
            this.username = '';
        this.dob = ''; // Reset the Date of Birth value
        this.email = ''; // Reset the Email value
        this.gender = '';
        this.street = ''; // To hold the street address
        this.city = ''; // To hold the city
        this.selectedCountry = '';
        this.selectedState = '';
        this.zipCode = ''; // To hold the zip code

        
        this.recordId = ''; // Reset the Record ID
            
            // Reset the form
            //const recordForm = this.template.querySelector('lightning-record-edit-form');
            /*if (recordForm) {
                recordForm.reset(); // Reset the record-edit-form
            }*/
            
            // Re-enable the submit button
            this.isSubmitDisabled = false;
    
            // Hide the file upload section
            this.showFileUpload = false;
            

        // Reset the record-edit-form fields
        const fields = this.template.querySelectorAll('lightning-input');
        fields.forEach(field => {
            field.value = ''; // Reset each input field
        });
    }
 }
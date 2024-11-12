import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VolunteerRegistrationCmp extends LightningElement {
    @api recordId;
    @track disableFileUpload = false;
    @track openModal = false;
    volunteerAge;
    @track isUnder18 = false;
    @track disableSubmit = true; // Disable submit button initially
    @track isChecked = false; // Track checkbox state

    // Handle birth date change to determine volunteer age
    handleBirthDateChange(event) {
        const birthDate = new Date(event.target.value);
        const today = new Date();
        const age = today.getFullYear() - birthDate.getFullYear();
        const monthDifference = today.getMonth() - birthDate.getMonth();

        if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < birthDate.getDate())) {
            this.volunteerAge = age - 1;
        } else {
            this.volunteerAge = age;
        }

        this.isUnder18 = this.volunteerAge < 18;
    }

    // Handle form submission and capture the recordId
    handleSuccess(event) {
        this.recordId = event.detail.id;
        this.disableFileUpload = false;

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Record Created',
                message: 'Volunteer record created successfully. You can now upload files.',
                variant: 'success',
            })
        );
    }

    // Handle checkbox change and enable/disable submit button
    handleCheckboxChange(event) {
        this.isChecked = event.target.checked;

        if (this.isChecked) {
            this.openModal = true;
            this.disableSubmit = false;
        } else {
            this.openModal = false;
            this.disableSubmit = true;
        }
    }

    // Handle form submission before file upload
    handleSubmit(event) {
        event.preventDefault();

        const fields = event.detail.fields;
        const checkbox = this.template.querySelector('input[type="checkbox"]');

        // Verify checkbox state before form submission
        if (checkbox && checkbox.checked) {
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        } else {
            // alert('Please approve the Terms and Conditions to continue');
            this.disableSubmit = true;
        }
    }

    // Handle file upload completion
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'File(s) Uploaded',
                message: `${uploadedFiles.length} file(s) uploaded successfully.`,
                variant: 'success',
            })
        );
    }

    openModal() {
        this.openModal = true;
    }

    closeModal() {
        this.openModal = false;
    }

    // Consent form upload for minors
    handleConsentUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Consent Form Uploaded',
                message: `${uploadedFiles.length} consent form(s) uploaded successfully.`,
                variant: 'success',
            })
        );
    }
}
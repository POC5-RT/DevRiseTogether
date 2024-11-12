// *********************Community Member Registration Form****************
//Developed by : Sophia A
//Date 17/10/2024
//Project - NPSP - Sprint2- Changes - Added Terms and Conditions Link and Modal
//Purpose - To create a new member registration form
// *********************************************************************

import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import isEmailUnique from '@salesforce/apex/CommunityMemberController.isEmailUnique';

export default class CommunityMemberRegistration extends LightningElement {
    @track email = '';
    @track dob = '';
    @track phoneNumber = '';
    @track recordId;
    @track showFileUpload = false;
    @track isSubmitDisabled = false;

    @track isModalOpen = false;
    @track isChecked = false;
    @track isAgreeDisabled = true;
    @track hasAgreedToTerms = false; // Track if the user has agreed to terms

    get acceptedFormats() {
        return ['.jpeg', '.png'];
    }

    // Open the modal
    openModal() {
        this.isModalOpen = true;
    }

    // Close the modal
    closeModal() {
        this.isModalOpen = false;
    }

    // Handle checkbox change
    handleCheckboxChange(event) {
        this.isChecked = event.target.checked;
        this.isAgreeDisabled = !this.isChecked;
    }

    // Handle the "Agree" action
    handleAgree() {
        if (this.isChecked) {
            this.isModalOpen = false; // Close the modal
            this.hasAgreedToTerms = true; // Track if the user has agreed to terms
            
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'You must agree to the terms and conditions before proceeding.',
                    variant: 'error',
                })
            );
        }
    }

    // Form Submission
    handleSubmit(event) {
        event.preventDefault();

        if (!this.hasAgreedToTerms) {
            // Prevent form submission if user hasn't agreed to terms
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please agree to the terms and conditions before submitting.',
                    variant: 'error',
                })
            );
            return;
        }

        const fields = event.detail.fields;
        const emailField = fields.Email__c;


        isEmailUnique({ email: emailField })
            .then(isUnique => {
                if (!isUnique) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Email already exists. Please provide a unique email address.',
                            variant: 'error',
                        })
                    );
                } else {
                    fields.Approval_Status__c = 'Pending';
                    fields.Member_Status__c = 'Inactive';
                    this.template.querySelector('lightning-record-edit-form').submit(fields);
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
    }

    handleSuccess(event) {
        this.recordId = event.detail.id;

        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Community Member details added successfully!',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
        
        this.isSubmitDisabled = true;
        this.showFileUpload = true;
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: uploadedFiles.length + ' File uploaded successfully.',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
        
        this.refreshForm();
    }

    refreshForm() {
        this.email = '';
        this.dob = '';
        this.phoneNumber = '';
        this.isSubmitDisabled = false;
        this.showFileUpload = false;
        this.recordId = ''; 

        this.isModalOpen = false;
    this.isChecked = false;
    this.isAgreeDisabled = true;
    this.hasAgreedToTerms = false;

        this.template.querySelectorAll('lightning-input-field').forEach(field => {
            field.value = null;
        });
    }
}
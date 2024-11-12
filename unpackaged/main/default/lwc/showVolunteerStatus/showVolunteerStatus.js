// *********************Volunteer Status Tracking****************
//Developed by : Sophia A
//Date 23/10/2024
//Project - NPSP - Sprint2
//Purpose - To display Volunteer Approval Status
// *********************************************************************
import { LightningElement, track } from 'lwc';
import getVolunteerByEmail from '@salesforce/apex/VolunteerController.getVolunteerByEmail';

export default class ShowVolunteerStatus extends LightningElement {
    @track email = ''; // To store the email entered by the user
    @track volunteerRecord; // To store the fetched volunteer record
    @track error; // To store the error message
    @track approverComments = ''; // To handle the approver comments
    @track approvalStatusClass = ''; // To dynamically assign CSS class based on approval status

    // Handle changes in the email input
    handleEmailChange(event) {
        this.email = event.target.value;
    }

    // Handle search when the button is clicked
    handleSearch() {
        this.error = null; // Clear any previous errors
        this.volunteerRecord = null; // Clear previous records
        this.approvalStatusClass = ''; // Reset approval status CSS
        this.approverComments = ''; // Reset approver comments

        if (this.email && this.isValidEmail(this.email)) {
            getVolunteerByEmail({ email: this.email })
                .then(result => {
                    if (result) {
                        this.volunteerRecord = result;
                        this.error = null;
                        this.setApprovalStatusClass();

                        // Set approver comments or 'Nil' if none exist
                        this.approverComments = result.Volunteer_Approver_Comments__c
                            ? result.Volunteer_Approver_Comments__c
                            : 'Nil';

                    } else {
                        this.volunteerRecord = null;
                        this.error = 'No volunteer found with this email.';
                    }
                })
                .catch(error => {
                    this.volunteerRecord = null;
                    this.error = 'An error occurred while fetching volunteer details.';
                    console.error(error);
                });
        } else {
            this.error = 'Please enter a valid email ID.';
            this.volunteerRecord = null; // Reset volunteer record if input is invalid
        }
    }

    // Dynamically set the CSS class based on the approval status
    setApprovalStatusClass() {
        if (this.volunteerRecord.Approval_Status__c === 'Approved') {
            this.approvalStatusClass = 'status-approved';
        } else if (this.volunteerRecord.Approval_Status__c === 'Rejected') {
            this.approvalStatusClass = 'status-rejected';
        } else if (this.volunteerRecord.Approval_Status__c === 'Pending') {
            this.approvalStatusClass = 'status-pending';
        } else {
            this.approvalStatusClass = ''; // Default, if no matching status
        }
    }

    // Validate email format
    isValidEmail(email) {
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailPattern.test(email);
    }
}
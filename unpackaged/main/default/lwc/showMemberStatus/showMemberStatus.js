import { LightningElement, track } from 'lwc';
import getMemberByEmail from '@salesforce/apex/CommunityMemberController.getMemberByEmail';

export default class ShowMemberStatus extends LightningElement {
    @track email = ''; // To store the email entered by the user
    @track memberRecord; // To store the fetched member record
    @track error; // To store the error message
    @track approverComments = ''; // To handle the approver comments
    @track approvalStatusClass = ''; // To dynamically assign CSS class based on approval status

    // to Handle changes in the email input
    handleEmailChange(event) {
        this.email = event.target.value;
    }

    // Handle search when the button is clicked
    handleSearch() {
        this.error = null; // Clear any previous errors
        this.memberRecord = null; // Clear previous records
        this.approvalStatusClass = ''; // Reset approval status CSS
        this.approverComments = ''; // Reset approver comments

        if (this.email && this.isValidEmail(this.email)) {
            getMemberByEmail({ email: this.email })
                .then(result => {
                    if (result) {
                        this.memberRecord = result;
                        this.error = null;
                        this.setApprovalStatusClass();

                        //console.log('comments'+memberRecord.CommMember_Approver_Comments__c);

                        // Set approver comments or 'Nil' if none exist
                        this.approverComments = result.CommMember_Approver_Comments__c
                            ? result.CommMember_Approver_Comments__c
                            : 'Nil';

                    } else {
                        this.memberRecord = null;
                        this.error = 'No member found with this email.';
                    }
                })
                .catch(error => {
                    this.memberRecord = null;
                    this.error = 'An error occurred while fetching member details.';
                    console.error(error);
                });
        } else {
            this.error = 'Please enter a valid email ID.';
            this.memberRecord = null; // Reset member record if input is invalid
        }
    }

    // Dynamically set the CSS class based on the approval status
    setApprovalStatusClass() {
        if (this.memberRecord.Approval_Status__c === 'Approved') {
            this.approvalStatusClass = 'status-approved';
        } else if (this.memberRecord.Approval_Status__c === 'Rejected') {
            this.approvalStatusClass = 'status-rejected';
        } else if (this.memberRecord.Approval_Status__c === 'Pending') {
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
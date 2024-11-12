import { LightningElement, track } from 'lwc';
import loginUser from '@salesforce/apex/LoginController.loginUser';
import getCampaigns from '@salesforce/apex/CampaignController.getCampaigns';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; // Import ShowToastEvent
import bookTicket from '@salesforce/apex/TicketController.bookTicket'; // Import the Apex method
import ticketExists from '@salesforce/apex/TicketController.ticketExists'; // Import the method to check ticket existence
import sendForgotPasswordEmail from '@salesforce/apex/LoginController.sendForgotPasswordEmail';
import resetPassword from '@salesforce/apex/LoginController.resetPassword';
import { NavigationMixin } from 'lightning/navigation';

export default class LoginComponent extends NavigationMixin(LightningElement) {
    @track username = '';
    @track password = '';
    @track email = ''; // Property for email
    @track errorMessage = '';
    @track isLoggedIn = false;
    @track isResetPassword = false; // Toggle reset password state
    @track contactId;
    @track campaigns;
    @track error;
    @track isLoading = false;
    @track campaigns = []; // Your campaigns array
    @track errorMessage; // For error messages
    @track isLoggedIn = false; // For tracking login status
    @track contactId; // To store the logged-in user's contact ID
    @track isVolunteer = false;



    // Handlers for input fields
    handleUsernameChange(event) {
        this.username = event.target.value;
    }

    handlePasswordChange(event) {
        this.password = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value; // Capture email input
    }
      handleBookTicket(event) {
                const campaignId = event.target.dataset.id;
        
                // First, check if the ticket already exists
                ticketExists({ contactId: this.contactId, campaignId: campaignId })
                    .then(ticketExists => {
                        if (ticketExists) {
                            // If the ticket exists, show a message
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error',
                                    message: 'You have already booked a ticket for this campaign.',
                                    variant: 'error',
                                })
                            );
                        } else {
                            // If no ticket exists, proceed to book the ticket
                            return bookTicket({ contactId: this.contactId, campaignId: campaignId })
                            .then(result => {
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Success',
                                        message: 'Ticket booked successfully!',
                                        variant: 'success', // Options: success | error | warning | info
                                    })
                                );
                                // Handle successful ticket creation
                                console.log('Ticket created successfully:', result);
                                this.errorMessage = 'Ticket booked successfully!';
                                // Optionally, you could refresh the campaigns or update the UI
                            })
                            .catch(error => {
                                // Handle any errors
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Error',
                                        message: 'Error booking ticket: ' + error.body.message,
                                        variant: 'error',
                                    })
                                );
                                this.errorMessage = 'Error booking ticket: ' + error.body.message;
                                console.error('Error:', error);
                            });
                        }
                    })
                    
            }

    // Handle Login
    handleLogin() {
        if (!this.username || !this.password) {
            this.errorMessage = 'Please enter both username and password.';
            return;
        }
    
        loginUser({ username: this.username, password: this.password })
            .then(result => {
                console.log('Login result:', result); // Log the result
                if (result) {
                    this.errorMessage = '';
                    this.isLoggedIn = true;
                    this.contactId = result.Id; // Set the contactId from the result
                    this.isVolunteer = result.Is_Volunteer__c;
                    
                    console.log('Login Successful! Contact ID:', this.contactId);
                    this.fetchCampaigns(); // Call a method to fetch campaigns after login
                } else {
                    this.errorMessage = 'Invalid username or password.';
                }
            })
            .catch(error => {
                this.errorMessage = 'Error logging in: ' + error.body.message;
            });
    }
    

    // Fetch campaigns after login
    fetchCampaigns() {
        this.isLoading = true; // Show loading spinner
        getCampaigns({ contactId: this.contactId })
            .then(data => {
                this.campaigns = data.map(campaign => ({
                    ...campaign,
                    StartDate: new Date(campaign.StartDate).toLocaleDateString(),
                    EndDate: new Date(campaign.EndDate).toLocaleDateString(),
                    CampaignImageId: '/sfc/servlet.shepherd/version/download/' + campaign.CampaignImageId
                }));
                this.isLoading = false; // Hide loading spinner
            })
            .catch(error => {
                this.error = error;
                this.isLoading = false; // Hide loading spinner
            });
    }

    // Handle Forgot Password
    handleForgotPassword() {
        this.isResetPassword = true; // Show the email input for resetting password
    }

    // Handle Email Submission for Password Reset
    handleEmailSubmit() {
        if (!this.email) {
            this.errorMessage = 'Please enter your email address.';
            return;
        }

        sendForgotPasswordEmail({ username: this.email })
            .then(() => {
                this.errorMessage = 'A password reset email has been sent to ' + this.email + '.';
                this.isResetPassword = false; // Hide email input after submission
                this.promptForNewPassword(); // Ask for old and new password
            })
            .catch(error => {
                this.errorMessage = 'Error sending reset email: ' + error.body.message;
            });
    }

    // Prompt for Old and New Passwords
    promptForNewPassword() {
        let oldPassword = prompt('Enter your old password:');
        let newPassword = prompt('Enter your new password:');

        if (!oldPassword || !newPassword) {
            this.errorMessage = 'Both old and new passwords are required.';
            return;
        }

        resetPassword({ username: this.email, oldPassword, newPassword })
            .then(() => {
                this.errorMessage = 'Password reset successfully.';
            })
            .catch(error => {
                this.errorMessage = 'Error resetting password: ' + error.body.message;
            });
    }

    // Handle Reset Password
    handleResetPassword() {
        this.isResetPassword = true; // Show the email input for resetting password
    }
}

   /* handleBookTicket(event) {
        const campaignId = event.target.dataset.id; // Get the campaign Id from the button's data attribute
        
        // Call the Apex method to create a ticket
        bookTicket({ contactId: this.contactId, campaignId: campaignId })
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Ticket booked successfully!',
                        variant: 'success', // Options: success | error | warning | info
                    })
                );
                // Handle successful ticket creation
                console.log('Ticket created successfully:', result);
                this.errorMessage = 'Ticket booked successfully!';
                // Optionally, you could refresh the campaigns or update the UI
            })
            .catch(error => {
                // Handle any errors
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error booking ticket: ' + error.body.message,
                        variant: 'error',
                    })
                );
                this.errorMessage = 'Error booking ticket: ' + error.body.message;
                console.error('Error:', error);
            });
    }*/
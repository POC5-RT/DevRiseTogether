import { LightningElement, wire } from 'lwc';
import getVolunteerJobs from '@salesforce/apex/VolunteerJobsController.getVolunteerJobs';

export default class VolunteerJobs extends LightningElement {
    volunteerJobs;

    @wire(getVolunteerJobs)
    wiredJobs({ error, data }) {
        if (data) {
            this.volunteerJobs = data;
        } else if (error) {
            console.error('Error retrieving Volunteer Jobs:', error);
        }
    }
}
import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Campaign.Name',
    'Campaign.Description',
    'Campaign.StartDateTime',
    'Campaign.EndDateTime',
    'Campaign.Status',
    'Campaign.Location',
    'Campaign.Budget',
    'Campaign.Content_of_the_Event__c'
];

export default class CampaignEventDisplay extends LightningElement {
    @api recordId; // This will hold the Campaign record Id
    @track campaign; // To store campaign details
    @track error;

    // Use wire to call getRecord to get campaign details
    @wire(getRecord, { recordId: '701WU00000RSuCbYAL', fields: FIELDS })
    wiredCampaign({ error, data }) {
        if (data) {
            this.campaign = data.fields; // Access fields of the campaign
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.campaign = undefined;
        }
    }

    get formattedStartDate() {
        return this.campaign ? new Intl.DateTimeFormat('en-US').format(new Date(this.campaign.StartDateTime.value)) : '';
    }

    get formattedEndDate() {
        return this.campaign ? new Intl.DateTimeFormat('en-US').format(new Date(this.campaign.EndDateTime.value)) : '';
    }
}
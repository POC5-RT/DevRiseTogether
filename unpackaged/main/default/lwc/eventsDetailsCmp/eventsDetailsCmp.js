import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { CurrentPageReference } from 'lightning/navigation';
// import food_goods_icon from '@salesforce/resourceUrl/food_goods_icon';
// import child_icon from '@salesforce/resourceUrl/child_icon';
// import environment_icon1 from '@salesforce/resourceUrl/environment_icon1';
// import volunteer_icon from '@salesforce/resourceUrl/volunteer_icon';
// import education_icon from '@salesforce/resourceUrl/education_icon';
// import health_icon from '@salesforce/resourceUrl/health_icon';
// import fundraiser_icon from '@salesforce/resourceUrl/fundraiser_icon';
import getEventAttachments from '@salesforce/apex/EventController.getEventAttachments';

// Define the fields to retrieve from the event record
const FIELDS = [
    'Community_Event__c.Name',
    'Community_Event__c.Event_Name__c', 
    'Community_Event__c.Event_Date__c', 
    'Community_Event__c.Event_Description__c',
    'Community_Event__c.Event_Category__c'
];

export default class EventsDetailsCmp extends LightningElement {
    @track recordId; // Store the recordId fetched from URL state
    @track event; // Store the event record
    @track base64Images; // Store the base64 image URLs
    @track error; // Store any error that occurs
    @track categoryImage; 

    // categoryImageMap = {
    //     'Food and Goods Distribution': food_goods_icon,
    //     'Children & Youth Programs': child_icon,
    //     'Environmental Events': environment_icon1,
    //     'Volunteer Programs': volunteer_icon,
    //     'Educational Events': education_icon,
    //     'Health Programs': health_icon,
    //     'Fundraising Events': fundraiser_icon,
    //     // Add other categories as needed
    // };

    // Fetch the current page reference and extract the recordId from the URL state
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.id; // Fetch the ID from the state
            console.log('recordId from state:', this.recordId); // Log the record ID for debugging
        }
    }

    // Wire the getRecord method to fetch event details
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredEvent({ error, data }) {
        console.log('recordId:', this.recordId); // Log the record ID for debugging

        if (data) {
            this.event = data;
            console.log('data',this.event);
            this.error = undefined; // Clear any previous errors
            const category = this.event.fields.Event_Category__c.value;
            this.categoryImage = this.categoryImageMap[category];
        } else if (error) {
            this.error = error; // Store error if it occurs
            this.event = undefined; // Clear event data if there's an error
        }
    }

    // Wire the getEventAttachments method to fetch base64-encoded image URLs
    @wire(getEventAttachments, { eventId: '$recordId' })
    wiredAttachments({ error, data }) {
        if (data) {
            this.base64Images = data; // Assign base64 URLs to track property
            this.error = undefined; // Clear any previous errors
        } else if (error) {
            this.error = error; // Store error if it occurs
            this.base64Images = undefined; // Clear attachments if there's an error
        }
    }
}
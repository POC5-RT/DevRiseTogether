import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
// import food_goods_icon from '@salesforce/resourceUrl/food_goods_icon';
// import child_icon from '@salesforce/resourceUrl/child_icon';
// import environment_icon1 from '@salesforce/resourceUrl/environment_icon1';
// import volunteer_icon from '@salesforce/resourceUrl/volunteer_icon';
// import education_icon from '@salesforce/resourceUrl/education_icon';
// import health_icon from '@salesforce/resourceUrl/health_icon';
// import fundraiser_icon from '@salesforce/resourceUrl/fundraiser_icon';
// import celebrationDay from '@salesforce/resourceUrl/celebrationDay';
// import awarenessAdvocacy from '@salesforce/resourceUrl/Awareness_Adovocacy_Events';
// import culturals from '@salesforce/resourceUrl/Cultural_Recreational_Events';
import getEvents from '@salesforce/apex/EventController.getEvents';

export default class EventsListCmp extends NavigationMixin(LightningElement) {
    @track events;
    @track error;
    @track searchTerm = ''; // Track search term for filtering

    // // Map each category to a specific icon
    // categoryImageMap = {
    //     'Food and Goods Distribution': food_goods_icon,
    //     'Children & Youth Programs': child_icon,
    //     'Environmental Events': environment_icon1,
    //     'Volunteer Programs': volunteer_icon,
    //     'Educational Events': education_icon,
    //     'Health Programs': health_icon,
    //     'Fundraising Events': fundraiser_icon,
    //     'Celebration Days': celebrationDay,
    //     'Awareness and Adovocacy Events': awarenessAdvocacy,
    //     'Cultural and Recreational Events': culturals,
    //     // Add other categories as needed
    // };

    @wire(getEvents)
    wiredEvents({ error, data }) {
        if (data) {
            // Assign category icons to the events based on the Event_Category__c field
            this.events = data.map(event => ({
                ...event,
                categoryIcon: this.getCategoryIcon(event.Event_Category__c)
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.events = undefined;
        }
    }

    // // Get the category icon for each event
    // getCategoryIcon(category) {
    //     return this.categoryImageMap[category] || null; // Return the corresponding icon or null if not found
    // }

    // Handle search input change and filter the events
    handleSearch(event) {
        this.searchTerm = event.target.value.toLowerCase();
        // You can implement additional logic here to filter `this.events` based on `searchTerm`
        if (this.searchTerm) {
            this.events = this.events.filter(ev =>
                ev.Event_Name__c.toLowerCase().includes(this.searchTerm)
            );
        }
    }

    handleDetails(event) {
        const eventId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Community_Event_Detail_Page__c'
            },
            state: {
                id: eventId // Pass the eventId as a state parameter
            }
        });
    }
}
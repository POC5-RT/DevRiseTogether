import { LightningElement, api, wire, track } from 'lwc';
import getCampaigns from '@salesforce/apex/CampaignController.getCampaigns';

export default class CampaignRecordsDisplay extends LightningElement {
    @api contactId; // Accept contactId from the parent component

    @track campaigns;
    @track error;
    @track isLoading = true;

    @wire(getCampaigns, { contactId: '$contactId' })
    wiredCampaigns({ error, data }) {
        console.log(data);
        if (data) {
            this.campaigns = data.map(campaign => ({
                ...campaign,
                StartDate: new Date(campaign.StartDate).toLocaleDateString(),
                EndDate: new Date(campaign.EndDate).toLocaleDateString(),
                CampaignImageId: '/sfc/servlet.shepherd/version/download/' + campaign.CampaignImageId
            }));
            this.isLoading = false;
        } 
        if (error) {
            console.log(error);
            this.error = error;
            this.isLoading = false;
        }
    }
}
import { LightningElement, api, track, wire } from 'lwc';
import getTimeline from '@salesforce/apex/PatentController.getTimeline';

export default class PatentTimeline extends LightningElement {
    @api recordId;
    @track timeline = [];
    @track error;

    @wire(getTimeline, { patentId: '$recordId' })
    wiredTimeline({ error, data }) {
        if (data) {
            // sort by date descending (most recent first)
            this.timeline = data.slice().sort((a,b) => new Date(b.when) - new Date(a.when));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.timeline = [];
        }
    }

    handleOpenRecord(event) {
        const recId = event.currentTarget.dataset.recordId;
        this.dispatchEvent(new CustomEvent('openrecord', { detail: recId }));
    }
}

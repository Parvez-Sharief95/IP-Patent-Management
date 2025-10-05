/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-03-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PatentController {
    public class TimelineItem {
        @AuraEnabled public String eventDate;
        @AuraEnabled public String type;
        @AuraEnabled public String title;
        @AuraEnabled public String status;
        @AuraEnabled public Id recordId;

        public TimelineItem(String eventDate, String type, String title, String status, Id rid) {
            this.eventDate = eventDate;
            this.type = type;
            this.title = title;
            this.status = status;
            this.recordId = rid;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<TimelineItem> getTimeline(Id patentId) {
        List<TimelineItem> items = new List<TimelineItem>();
        if (patentId == null) return items;

        // Filings
        for (Filing__c f : [SELECT Id, Filing_Date__c, Office__c, Status__c FROM Filing__c WHERE Patent__c = :patentId]) {
            items.add(new TimelineItem(
                String.valueOf(f.Filing_Date__c),
                'Filing',
                f.Office__c == null ? 'Filing' : f.Office__c,
                f.Status__c,
                f.Id
            ));
        }

        // Renewals
        for (Renewal__c r : [SELECT Id, Renewal_Date__c, Renewal_Status__c FROM Renewal__c WHERE Patent__c = :patentId]) {
            items.add(new TimelineItem(
                String.valueOf(r.Renewal_Date__c),
                'Renewal',
                'Renewal',
                r.Renewal_Status__c,
                r.Id
            ));
        }

        return items;
    }
}

public class EventController {
    @AuraEnabled(cacheable=true)
    public static List<Community_Event__c> getEvents() {
        return [SELECT Id, Event_Name__c, Event_Date__c, Event_Category__c,Event_Description__c FROM Community_Event__c ORDER BY Event_Date__c ASC];
    }

    @AuraEnabled(cacheable=true)
public static List<String> getEventAttachments(Id eventId) {
    List<String> base64Images = new List<String>();
    
    List<ContentDocumentLink> docLinks = [
        SELECT ContentDocumentId 
        FROM ContentDocumentLink 
        WHERE LinkedEntityId = :eventId
    ];
    
    for (ContentDocumentLink docLink : docLinks) {
        List<ContentVersion> contentVersions = [
            SELECT VersionData, FileExtension 
            FROM ContentVersion 
            WHERE ContentDocumentId = :docLink.ContentDocumentId 
            AND IsLatest = true
        ];
        
        for (ContentVersion cv : contentVersions) {
            // Get base64 encoded data and create a data URL with the correct MIME type
            String base64Data = EncodingUtil.base64Encode(cv.VersionData);
            String fileExtension = cv.FileExtension.toLowerCase();
            String mimeType;
            
            // Identify the MIME type based on file extension
            if (fileExtension == 'png') {
                mimeType = 'image/png';
            } else if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
                mimeType = 'image/jpeg';
            } else if (fileExtension == 'gif') {
                mimeType = 'image/gif';
            } else {
                continue; // Skip unsupported file types
            }
            
            // Create data URL with base64 encoding
            String dataUrl = 'data:' + mimeType + ';base64,' + base64Data;
            base64Images.add(dataUrl);
        }
    }
    
    return base64Images;
}
}
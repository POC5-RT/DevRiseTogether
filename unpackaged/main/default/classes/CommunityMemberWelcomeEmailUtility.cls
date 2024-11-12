// *** @Author : Bhargavi
// *** @Project : RiseTogether
// *** @Date : 08/oct/2024
// *** Purpose : To send Welcome email to Community Members

public class CommunityMemberWelcomeEmailUtility {
    public static void sendWelcomeEmail(List<Community_member__c> newMembers){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (Community_Member__c communityMember : newMembers){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            //Set Email Address of Recepients
            email.setToAddresses(new List<string> {communityMember.Email__c});
            //Use Custom Labels for Email Subject and body
            String subject = Label.Community_Member_Welcome_Email_Subject;
            String body = Label.Community_Member_Welcome_Email_Header.replace('{0}', communityMember.Last_Name__c) + '<br>' + '<br>'+
                Label.Community_Member_Welcome_Email_Body.replace ('{0}',communityMember.Name)
                //.replace('{1}',communityMember.Username__c)
                .replace ('{2}',communityMember.Approval_Status__c)
                .replace('{3}', communityMember.Member_Status__c);
            //Assign Email Subject and body
            email.setSubject(subject);
            email.setHtmlBody(body);
            //Add email to the list 'emails'
            emails.add(email);
        }
        //send all emails
        if (!emails.isEmpty()){
            Messaging.sendEmail(emails);   
        }      
    }    
}
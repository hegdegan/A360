/*
Apex class            :  MFS_ChatterApiUtility
Version               :  1.0
Created Date          :  21 OCT 2016
Function              :  This Utility class contains all the common methods related to Chatter API

Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Maheshkumar Selvaraj            21 OCT 2016              Initial Version
*/

public class MFS_ChatterApiUtility {

/*
** Method Name     : postChatterWithSingleTextMultiMentionAndSingleLink
** Description     : Method to post the chatter on particular record (subjectid) and mentioning particular user (mentionid) and a link to salesforce record
** Used in         : onclick of save button in Competitive Analysis Pop Up screen in Activity360 (for new record creation) . method called - postChatterWhenCompRequestCreated()
*/     
    public static Boolean postChatterWithSingleTextMultiMentionAndSingleLink(List<ID> secondaryMentionIds, ID subjectId, String chattertext, ID linkId){
        try{
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            textSegmentInput.text =  chattertext + '\n';
            messageBodyInput.messageSegments.add(textSegmentInput);
            if(linkId != NULL){
                ConnectApi.LinkSegmentInput  linkSegment = new ConnectApi.LinkSegmentInput();
                linkSegment.URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + linkId;  
                messageBodyInput.messageSegments.add(linkSegment);
             }
            
            for (ID mentionid : secondaryMentionIds){
                ConnectApi.MentionSegmentInput mentionSegmentInput2 = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput2.id = mentionid;
                messageBodyInput.messageSegments.add(mentionSegmentInput2);                
            }
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = subjectId;
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            
            return TRUE;
        }
        catch(Exception e){
            
            return FALSE;
        }
    }

 /*
** Method Name     : postChatterWithSingleTextSingleMentionAndSingleLink
** Description     : Method to post the chatter on particular record (subjectid) and mentioning particular user (mentionid) and a link to salesforce record
** Used in         : onclick of save button in Competitive Analysis Pop Up screen in Activity360 (for new record creation) . method called - postChatterWhenCompRequestCreated()
*/     
    public static Boolean postChatterWithSingleTextSingleMentionAndSingleLink(ID primaryMentionId, List<ID> secondaryMentionIds, ID subjectId, String chattertext, ID linkId){
        try{
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            mentionSegmentInput.id = Userinfo.getUserId();
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            textSegmentInput.text = '\n' + chattertext + '\n';
            messageBodyInput.messageSegments.add(textSegmentInput);
            if(linkId != NULL){
                ConnectApi.LinkSegmentInput  linkSegment = new ConnectApi.LinkSegmentInput();
                linkSegment.URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + linkId;  
                messageBodyInput.messageSegments.add(linkSegment);
            }
            for (ID mentionid : secondaryMentionIds){
                ConnectApi.MentionSegmentInput mentionSegmentInput2 = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput2.id = mentionid;
                messageBodyInput.messageSegments.add(mentionSegmentInput2);                
            }
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = subjectId;
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            return TRUE;
        }catch(Exception e){
            return FALSE;
        }
    }
    

    public static Boolean postChatterWithSingleTextSingleMentionAndSingleLink(ID mentionid, ID subjectId, String chattertext, ID linkId){
        try{
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            mentionSegmentInput.id = mentionid;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            ConnectApi.MentionSegmentInput mentionSegmentInput2 = new ConnectApi.MentionSegmentInput();
            mentionSegmentInput2.id = mentionid;
            messageBodyInput.messageSegments.add(mentionSegmentInput2);
            
            textSegmentInput.text = '\n' + chattertext;
            messageBodyInput.messageSegments.add(textSegmentInput);
            if(linkId != NULL){
                ConnectApi.LinkSegmentInput  linkSegment = new ConnectApi.LinkSegmentInput();
                linkSegment.URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + linkId;  
                messageBodyInput.messageSegments.add(linkSegment);
            }
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = subjectId;
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            return TRUE;
        }catch(Exception e){
            return FALSE;
        }
    }


    
/*
** Method Name     : postChatterWithSingleTextAndMention
** Description     : Method to post the chatter on particular record (subjectid) and mentioning particular user (mentionid)
** Used in         : onclick of save button in Competitive Analysis Pop Up screen in Activity360 (for new record creation) . method called - postChatterWhenCompRequestCreated()
*/     
    public static Boolean postChatterWithSingleTextAndMention(ID mentionid, ID subjectId, String chattertext){
        try{
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            mentionSegmentInput.id = mentionid;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            textSegmentInput.text = chattertext;
            messageBodyInput.messageSegments.add(textSegmentInput);
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = subjectId;
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            return TRUE;
        }catch(Exception e){
            return FALSE;
        }
    }
    
}
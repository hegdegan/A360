/***************************************************************************************************
Apex Class Name    : MFS_ApexSoapWebService
Version            : 1.0 
Created Date       : 10 Nov 2016
Function           : To be filled by Alex
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Alex Gomez           11/10/2016              Original Version
***************************************************************************************************/
global class MFS_ApexSoapWebService
{
	global class Mention
    {
        webservice string userName;
        webservice string userID;
        webservice string userURL;
    } //global class Mention
    
    webservice static List<Mention> GetChatterMentions(string feedItemId)
    {
    	String communityId = null;
        List<Mention> results = new List<Mention>();
		//String feedItemId = '0D5P000000F6MMUKA3';

		ConnectApi.FeedElement feedItem = ConnectApi.ChatterFeeds.getFeedElement(communityId, feedItemId);
		List<ConnectApi.MessageSegment> messageSegments = feedItem.body.messageSegments;
		for (ConnectApi.MessageSegment messageSegment : messageSegments) {
    		if (messageSegment instanceof ConnectApi.MentionSegment) {
        		ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) messageSegment;
                Mention mention = new Mention();
        		//System.debug('Mentioned user name: ' + mentionSegment.name);
                mention.userName = mentionSegment.name;
        		//System.debug('Mentioned user record: ' + mentionSegment.record);
        		ConnectApi.ActorWithId actorWithId = mentionSegment.record;
        		//System.debug('Mentioned user id: ' + actorWithId.id);
        		//System.debug('Mentioned user url: ' + actorWithId.url);
                mention.userID = actorWithId.id;
                mention.userURL = actorWithId.url;
                results.add(mention);
    		}
		}
        return results;
    } //GetChatterMentions
    
} //global class MFS_ApexSoapWebService
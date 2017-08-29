var MicroStrategyHelper = (function() {

	// Constructor
	function MicroStrategyHelper() {
	}
	
	// Public function to get URL for Rep Scorecard on contact detail page
	MicroStrategyHelper.prototype.GetRepScorecardURL = function(contactMDMId) {
		var url = getCustomSetting('RepScorecard');

		var ret = url.replace('{!Contact.MDM_ID__c}', contactMDMId);
		
		return ret;
	}
	
	function getCustomSetting(settingName) {
		var setting = {};

		//Run query to get contact info from SFDC
		try {
			var query = 'select Name, URL__c, QueryString__c from MicroStrategy_URLs__c';
			
			var records = sforce.connection.query(query); 
			settingRecords = records.getArray('records');

			for(var i=0; i<settingRecords.length; ++i) {
				if (settingRecords[i].Name == settingName) {
					return settingRecords[i].URL__c + '?' + settingRecords[i].QueryString__c;
				}
			}

			return '';
		}
		catch(e) {
			alert('Exception retrieving URL for ' + settingName + '. Error: ' + e);
			return '';
		}
	}
	
	return MicroStrategyHelper;
})();
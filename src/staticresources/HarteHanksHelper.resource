var HarteHanksHelper = (function() {

	// Constructor
	function HarteHanksHelper() {
	}

	// Public function to gather info based on contact ID and create form for HH then posts it
	HarteHanksHelper.prototype.postHHForm = function(contactId) {

		// Get contact data in array form
		var contact = getContactPostData(contactId);
		
		if (contact) {
			var form = createForm(contact);
			
			if (form) {
				var params = [
						'height='+screen.height,
						'width='+screen.width,
						'fullscreen=yes' // only works in IE, but here for completeness
				].join(',');

				var hh = window.open("", 'HarteHanks', params); 
				if (hh) {
					hh.moveTo(0,0);
					form.submit();
				}
				else {
					alert('You must allow popups to order from Harte Hanks.');
				}
			}
			else {
				alert('Unable to create document to send to Harte Hanks');
			}
		}
		else {
			alert('Unable to retrieve wholesaler information to send to Harte Hanks');
		}
	};
	
	function getContactPostData(contactId) {
		
		
		
		var contactRecords = {};

		//Run query to get contact info from SFDC
		try {
			var query = 'select firstname, lastname, account.name, mailingstreet, mailingcity, mailingstatecode, mailingpostalcode, mailingcountrycode, ' + 
									'(select coverage_owner__r.lastname, coverage_owner__r.firstname, coverage_owner__r.employeenumber from coverage_teams__r where coverage_role__c = \'External Wholesaler\') ' +
									'from contact where id = \'' + contactId + '\'';
			
			var records = sforce.connection.query(query);
			contactRecords = records.getArray('records');
		}
		catch(e) {
			alert('Exception retrieving contact info for literature request. Contact ID = ' + contactId + '. Error: ' + e);
			return null;
		}

		// If we didn't get contact info back then just get out of here. We can't do anything
		if (contactRecords.length <= 0) {
				alert('Unable to retrieve contact data for Harte Hanks order.');
				return null;
		}

		// External info may or may not exist. Try to get it (take first row if there's more than one)
		var exFirstName = '', exLastName = '', exNumber = '';
		try {

			if (null != contactRecords[0].Coverage_Teams__r) {
				var coverageRecords = contactRecords[0].Coverage_Teams__r.getArray('records');

				if (coverageRecords.length > 0) {
					exFirstName = coverageRecords[0].Coverage_Owner__r.FirstName;
					exLastName = coverageRecords[0].Coverage_Owner__r.FirstName;
					exNumber = coverageRecords[0].Coverage_Owner__r.FirstName;
				}
			}
		}
		catch(e) {
			alert('Exception interpreting external wholesaler info for literature request. Contact ID = ' + contactId + '. Error: ' + e);
			return null;
		}

		// Insert all contact/external data into array to be posted to HH and return array
		try{
			var contactInfo = {};

			contactInfo['ExternalFirstName'] = exFirstName;
			contactInfo['ExternalLastName'] = exLastName;
			contactInfo['ExternalEmployeeNumber'] = exNumber;
			contactInfo['ContactMailingStreet'] = contactRecords[0].MailingStreet;
			contactInfo['ContactMailingCity'] = contactRecords[0].MailingCity;
			contactInfo['ContactMailingStateCode'] = contactRecords[0].MailingStateCode;
			contactInfo['ContactMailingPostalCode'] = contactRecords[0].MailingPostalCode;
			contactInfo['ContactMailingCountryCode'] = contactRecords[0].MailingCountryCode;
			contactInfo['Company'] = contactRecords[0].Account.Name;
			contactInfo['ContactId'] = contactId;
			contactInfo['ContactFirstName'] = contactRecords[0].FirstName;
			contactInfo['ContactLastName'] = contactRecords[0].LastName;
			
			return contactInfo;
		}
		catch(e) {
			alert('Exception interpreting contact info for literature request. Contact ID = ' + contactId + '. Error: ' + e);
			return null;
		}
	}

	// create form to post to HH
	function createForm(contact) {
		var form = document.createElement('form');

		var userId = '';
		try {
			sforce.connection.sessionId = window.ApiUtils.getSessionId();
			var user = sforce.connection.getUserInfo();
			userId = user.userId;
		}
		catch(e) {
			alert('Unable to determine current user for submission to Harte-Hanks');
			return null;
		}
		
		try {
			form.setAttribute('method', 'POST');
			form.setAttribute('action', 'https://uatmfssso.hartehanks.com/SalesforceController');
			form.setAttribute('target', 'HarteHanks');

			var dictionary = {
				'firstName':contact['ContactFirstName']
				,'LastName':contact['ContactLastName']
				,'Address1':contact['ContactMailingStreet']
				,'City':contact['ContactMailingCity']
				,'State':contact['ContactMailingStateCode']
				,'Postal Code':contact['ContactMailingPostalCode']
				,'Country':contact['ContactMailingCountryCode']
				,'contactId':contact['ContactId']
				,'userId':userId
				,'wholesalerEmployeeId':contact['ExternalEmployeeNumber']
				,'wholesalerFirstName':contact['ExternalFirstName']
				,'wholesalerLastName':contact['ExternalLastName']
				,'Company':contact['Company']
			}

			for (key in dictionary) {
				var hiddenField = document.createElement("input");
				
				hiddenField.setAttribute("type", "hidden");
				hiddenField.setAttribute("name", key);
				hiddenField.setAttribute("value", dictionary[key]);

				form.appendChild(hiddenField);
			}

			document.body.appendChild(form);

			return form;
		}
		catch(e) {
			alert('Exception building request for Harte Hanks: ' + e);
			return null;
		}
	}
	
	return HarteHanksHelper;
})();

function AlertTheWorld() {
	
	alert('The World be da worst');
}
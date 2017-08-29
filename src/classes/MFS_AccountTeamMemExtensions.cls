/*
Apex Class Name    : MFS_AccountTeamMemExtensions
Version            : 1.0 
Created Date       : 23 May 2016
Function           : Extensions for AccountTeamMem Page
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            23/05/2016             Original Version
*/
public with Sharing class MFS_AccountTeamMemExtensions {
    public Account acctRec {get;set;}
    public Boolean isiPhone{get;set;}
    public String acctId{get;set;}
    public String acctName{get;set;}
    public list<AccountTeamMember> lstAcctteamMem {get;set;}
    public boolean isGotolist {get; set;}   // Gotolist link on the page, hide when on Gotolist page
    public boolean isShowbuttons {get; set;} // To display request new member button
    public list <AccountTeamMember> lstactTeMem {get;set;}
    public string editRow {get; set;}
    public string delRow {get; set;}
    public boolean isAdmin {get;set;} // To hide del link  
    public string accname{get;set;}
    public Boolean renderReq{get;set;}
    public Boolean renderEditDel{get;set;}
    public Boolean rendergotolist{get;set;}
    public String accntId{get;set;}
    public String accntName{get;set;}
    public String recordTypeId{get;set;}   
    public String editUrl{get;set;}
    public String requesterId{get;set;}
    public String requesterName{get;set;}
    public String requesterUserId{get;set;}
    public String teamMemberId{get;set;}
    public String teamMemberName{get;set;}
    public String caseType{get;set;}
    public String caseSubType{get;set;}
    public String caseTypeVal{get;set;}
    public String caseSubTypeVal{get;set;}
    public String caseSubject{get;set;}
    public String caseSubjectVal{get;set;}
    public String teamMemberlkId{get;set;}
    
    
    /***************************************************************************************************
    * Method name  : MFS_AccountTeamMemExtensions
    * Description  : constructor 
    * Return Type  : -
    * Parameter    : ApexPages.StandardController
    ***************************************************************************************************/      
    public MFS_AccountTeamMemExtensions(ApexPages.StandardController controller) {
        try{            
            acctRec = (Account)Controller.getRecord();
            accname=acctRec.id;
            Account acct = [select Name from Account where Id =: acctRec.Id]; 
            
            AcctTeamAppCustomSettings__c settings = AcctTeamAppCustomSettings__c.getinstance('Default');
            acctid = acct.Id;
            acctName = acct.Name;
            accntId = string.valueof(settings.AccountId__c);
            accntName = string.valueof(settings.AccountName__c);
            recordTypeId = string.valueof(settings.RecordType_Approval__c);
            editUrl = string.valueOf(settings.editUrl__c); 
            requesterId = string.valueOf(settings.Requester__c); 
            caseType = string.valueOf(settings.Case_Type__c); 
            caseSubType = string.valueOf(settings.Case_Subtype__c);
            caseTypeVal = System.Label.CT_Choose_Type;
            caseSubTypeVal = System.Label.CT_Choose_Sub_Type;
            requesterUserId = string.valueOf(UserInfo.getUserId());
            requesterName = string.valueOf(UserInfo.getName());
            caseSubject = string.valueOf(settings.Case_Subject__c);
            caseSubjectVal = System.Label.Territory_Management_Request;
            teamMemberId = string.valueOf(UserInfo.getUserId());
            teamMemberName = string.valueOf(UserInfo.getName());
            teamMemberlkId = string.valueOf(settings.Team_Member_lkid__c);
            if (settings != null) 
                if (settings.Admin_Profile_Id__c == Userinfo.getProfileId ()){
                    isAdmin = true;
                } else {
                    isAdmin = false;
                }
            
            if (acctRec.Id != null) {
                lstactTeMem = [SELECT AccountId,Id
                               FROM AccountTeamMember where AccountId=: acctRec.Id];
                isShowbuttons = true;
                if (((Apexpages.currentpage().getparameters().containsKey('gtl')) && (Apexpages.currentpage().getparameters().get('gtl')).equals('true'))|| !isMobile()){ // Gotolist page
                    isGotolist = false;
                    isShowbuttons = false;           
                    lstAcctteamMem = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.Name
                                      FROM AccountTeamMember where AccountId=: acctRec.Id AND User.IsActive = true];
                }     
                
                if (lstactTeMem.size() < 5){
                    isGotolist = false;
                    lstAcctteamMem = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId, User.Name
                                      FROM AccountTeamMember where AccountId=: acctRec.Id AND User.IsActive = true limit 5];                   
                }    
                else if (lstactTeMem.size() > 4 && !(Apexpages.currentpage().getparameters().containsKey('gtl')) && !isMobile()) {
                    lstAcctteamMem = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.Name 
                                      FROM AccountTeamMember where AccountId=: acctRec.Id AND User.IsActive = true limit 5]; 
                    isGotolist = true;     
                }
                
                if(isMobile()){
                    lstAcctteamMem = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.Name
                                      FROM AccountTeamMember where AccountId=: acctRec.Id AND User.IsActive = true];
                }
            } 
            
            if(isMobile())
                isiPhone=TRUE;
            renderReq=showReqMember();
            renderEditDel=showEditDelete();
            rendergotolist=showGotoList();
            
        }    
        catch (exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));   
        }
    }
    /***************************************************************************************************
    * Method name  : AcctTeamMemGotoList
    * Description  : navigates to GoToList link
    * Return Type  : pagereference
    * Parameter    : - 
    ***************************************************************************************************/          
    public pagereference AcctTeamMemGotoList () {
        Map<String,String> urlmap= new Map<String,String>();
        urlmap.put('id',string.valueof(acctRec.Id));
        urlmap.put('gtl','true');
        isGotolist = false;
        pagereference pgref;
        pgref = MFS_ACTRedirectPage.redirectPage('/apex/MFS_AccountTeamMem?', urlmap);
        pgref.setRedirect(true);
        return pgref;
    }
    
    /***************************************************************************************************
    * Method name  : editAction
    * Description  : Edit link 
    * Return Type  : pagereference
    * Parameter    : -
    ***************************************************************************************************/          
    
    /***************************************************************************************************
    * Method name  : delAction
    * Description  : del link 
    * Return Type  : pagereference
    * Parameter    : -
    ***************************************************************************************************/      
    
    
    public Boolean isMobile() {
        String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        if(userAgent.contains('iPhone')) {
            return TRUE;
        }
        return FALSE;
    }
    
    public Boolean showReqMember(){
        
        if(isMobile()&&isShowbuttons)
            return FALSE;
        return TRUE;
        
    }
    
    public Boolean showEditDelete(){
        
        if(isMobile()&&isAdmin)
            return FALSE;
        return TRUE;
        
    }
    
    public Boolean showGotoList(){
        
        if(isMobile())
            return FALSE;
        return TRUE;
        
    }
    
    public Pagereference redirectToUserPage() {
        String str = Apexpages.currentPage().getParameters().get('conId');
        return new Pagereference('/'+str);
        return null;
    }
    
}
/**
 * @author bthomas044
 * @description MFS App Engine - Activity360
 * @support balu.j.thomas@pwc.com
 * @date 4 Nov, 2016
 * @company PricewaterhouseCoopers LLP
 *  
 */

$("html").on("click", function(){
	$(".slds-lookup__menu").hide();
	$(".slds-dropdown").hide();
});

var initFollowUpAssignedTo = function(defaultUser, defaultUserId){
    if(allUsers !== ""){
        var allUsersObj = JSON.parse(allUsers);
        if(defaultUser && defaultUserId){
            __renderLookupField($(".mfs_follow_up_assigned_to"), allUsersObj["Users"], defaultUser, defaultUserId);
        }
        else{
            __renderLookupField($(".mfs_follow_up_assigned_to"), allUsersObj["Users"]);
        }
    }
    
    Lookup.initLookup();
};

var initLookupCompPortfolio = function(){
    if(allCompetitorPortfolios !== ""){
        var allCompetitorPortfoliosObj = JSON.parse(allCompetitorPortfolios);
        __renderLookupField($(".mfs_comp_analysis_portfolio"), allCompetitorPortfoliosObj["MFS Competitor Portfolios"]);
    }
    
    Lookup.initLookup();
};

var initLookupCompPortfolioNotify = function(){
    if(allUsers !== ""){
        var allUsersObj = JSON.parse(allUsers);
        __renderLookupField($(".mfs_comp_analysis_notify"), allUsersObj["Users"]);
    }
    
    Lookup.initLookup();
};

var initInviteesPortfolioLookup = function(){
    if(allPortfolios !== ""){
        var allPortfoliosObj = JSON.parse(allPortfolios);
        __renderLookupField($(".mfs_invitees_portfolio"), allPortfoliosObj["MFS Portfolios"]);
    }
    
    Lookup.initLookup();
};

var __renderLookupField = function(elem, lookupJSON, initValue, initID){
	elem.data("lookup-menu", lookupJSON);
	
	if(initValue){
		elem.data("lookup-menu-default", initID);
        
        setTimeout(function(){
            elem.val(initValue);
        }, 300);
	}
};

var __inviteesPortfolioSelected = function(val, currLookupElem){
    var invID = $(currLookupElem).parents(".invitee-row").data("invitee-id");
    $(currLookupElem).prev().val(val);
    addPortfToInvitee(invID);
};

var __comAnalysisPortfolioSelected = function(val, currLookupElem){
    showLoading();
    var parentRecordID = $.trim($(currLookupElem).parents(".slds-hint-parent").find(".comp_analysis_product_id").text());
    
    currLookupElem.prev("input[type='hidden']").val(val);
    selectedCompProductForCA(parentRecordID);
};

var __portfolioSelected = function(val){
	$("input[type='hidden'][data-lookup-name='selected_lookup3']").val(val);
};

var __userSelected = function(val){
    $("input[type='hidden'][data-lookup-name='selected_lookup1']").val(val);
};

var __speakerRequestedFor = function(val){
    $("input[type='hidden'][data-lookup-name='speaker_requested_for']").val(val);
};

var __compAnalysisNotifySelected = function(val){
    $("input[type='hidden'][data-lookup-name='comp_analysis_notify']").val(val);
};

var __userFollowUpSelected = function(val){
    $("input[type='hidden'][data-lookup-name='follow_up_assigned_to']").val(val);
};

var __compPortfolioSelected = function(val){
	$("input[type='hidden'][data-lookup-name='selected_lookup4']").val(val);
};

var initOrientationChange = function(){
	var isTablet = (window.screen.width == 768 && window.screen.height == 1024 ) ? true : false;
    if(!isTablet){
        isTablet = (window.screen.width == 1024 && window.screen.height == 768 ) ? true : false;
    }
    var isMobile = (window.screen.width >= 320 && window.screen.width < 768 ) ? true : false;
    var containerElement, scroller;
    
	if(isTablet){
        containerElement = document.getElementById('scroller');
        if(containerElement){
            scroller = new FTScroller(containerElement, {
                scrollbars: false,
                scrollingX: false,
                updateOnChanges : true,
                updateOnWindowResize : true
            });   
        }
        
        var readDeviceOrientation = function(){
			if (Math.abs(window.orientation) === 90) {
                //alert("Landscape : " +window.screen.width);
                containerElement = document.getElementById('scroller');
                
                scroller = new FTScroller(containerElement, {
                    scrollbars: false,
                    scrollingX: false
                });
			} else {
                //alert("Portrait");
                $("#scroller").height(window.screen.width + 120);
                containerElement = document.getElementById('scroller');
                
                scroller = new FTScroller(containerElement, {
                    scrollbars: false,
                    scrollingX: false
                });
			}
		};
        //readDeviceOrientation();
        if($('.mfs-list-related-sections').length > 0){
         	$('.mfs-list-related-sections').masonry({
                // options
                itemSelector: '.grid-item',
                columnWidth: ".grid-item",
                gutter : 23
            });   
        }
        
        $(window).on("orientationchange", function(){
			//readDeviceOrientation();
            if($('.mfs-list-related-sections').length > 0){
                $('.mfs-list-related-sections').masonry({
                    // options
                    itemSelector: '.grid-item',
                    columnWidth: ".grid-item",
                    gutter : 23
                });   
            }
			scroller.updateDimensions();
		});
	}
    else if(isMobile){
        //alert(window.screen.height);
        var resTextMobile = $(".res_button_txt_mobile").text();
        $("#scroller").height(window.screen.height - 120);
        containerElement = document.getElementById('scroller');
        
        scroller = new FTScroller(containerElement, {
            scrollbars: false,
            scrollingX: false,
            updateOnChanges : true,
            updateOnWindowResize : true
        });
        
        $(".mfs-btn-money-in-motion").val(resTextMobile);
    }
};

var setInitialHeight = function(orientation){
	if(orientation == "Landscape"){
		$(".slds").removeClass("slds-is-tablet--portrait").addClass("slds-is-tablet--landscape");
	}
	else if(orientation == "Portrait"){
		$(".slds").removeClass("slds-is-tablet--landscape").addClass("slds-is-tablet--portrait");
	}
};

var setContainerHeight = function(){
  	var pageH = window.screen.height - 74;
    $(".slds-inner-container").height(pageH);
};

var postReRenderFollowUpModal = function(){
    currFollowUpOwnerName = $.trim($(".follow_up_owner_name a").text());
    
    $("#dialog_box_follow_up .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_follow_up .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
    
    initFollowUpAssignedTo();
};

var postReRenderPortfolio = function(){
    $(".mfs_portfolio_selector_modal .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $(".mfs_portfolio_selector_modal .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var postReRenderCompPortfolio = function(){    
    $(".mfs_competitor_selector_modal .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $(".mfs_competitor_selector_modal .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var postReRenderCompPortfolio_CA = function(){
    $(".mfs_competitor_selector_modal_CA .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $(".mfs_competitor_selector_modal_CA .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var openCAPanelBack = function(saveFlag){
    $('#dialog_box_competitive_ananlysis .slds-modal').addClass('slds-fade-in-open');
    
    if(saveFlag){
        addSelComProductForCA();
    }
};

var postReRenderEditFollowUp = function(){
    var currUserName = currFollowUpOwnerName;
    var currUserId = currFollowUpOwnerID;
    var followUpWhoID = $.trim($(".follow_up_who_id_name").text());
    var followUpWhatID = $.trim($(".follow_up_what_id_name").text());
    
    $("#dialog_box_follow_up .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_follow_up .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
    
    if( $.trim($(".who_id_object_value_followup").text()) == "Lead" ){
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_account']").val("account_leads");
        $(".who-handle-icon-container_followup").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-lead slds-icon--small">'+
                                                      	'<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#lead"></use>'+
                                                      '</svg>');
        
        $("input[type='hidden'][data-lookup-name='follow_up_related_to']").val("");
        $(".curr_related_to_input_followup").attr("disabled", "disabled").val("");
        $(".curr_related_to_input_followup").parents(".slds-form-element__control").css("background", "#d8dde6");
    }
    else{
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_account']").val("account_contacts");
        $(".who-handle-icon-container_followup").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-opportunity slds-icon--small">'+
                                                      	'<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#contact"></use>'+
                                                   	  '</svg>');
        
        $(".curr_related_to_input_followup").removeAttr("disabled");
        $(".curr_related_to_input_followup").parents(".slds-form-element__control").css("background", "#FFF");
    }
    
    
    if( $.trim($(".what_id_object_value_followup").text()) == "Account" ){
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_related']").val("related_accounts");
        $(".what-handle-icon-container_followup").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">'+
                                                         '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#account"></use>'+
                                                       '</svg>');
    }
    else{
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_related']").val("related_opportunities");
        $(".what-handle-icon-container_followup").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-opportunity slds-icon--small">'+
                                                       	 '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#opportunity"></use>'+
                                                       '</svg>');
    }
    
    $(".curr_account_name_input_followup").val(followUpWhoID);
    $(".curr_related_to_input_followup").val(followUpWhatID);
    
    initFollowUpAssignedTo(currUserName, currUserId);
    initInviteesPortfolioLookup(); 
};

var currFollowUpOwnerID = "";
var currFollowUpOwnerName = "";
var setFollowUpOwnerID = function(ownerID, elem){
    currFollowUpOwnerID = ownerID;
    if(elem){
     	currFollowUpOwnerName = $.trim($(elem).parent().parent().find(".slds-tile__detail .follow_up_owner_new").text());   
    }
};

var closeFollowUpModal = function(){
    $("#dialog_box_follow_up").find(".slds-modal").removeClass("slds-fade-in-open").addClass("slds-fade-in-close");
    $("#dialog_box_follow_up").find(".slds-backdrop").removeClass("slds-backdrop--open").addClass("slds-backdrop--close");
};

var postReRenderActions = function(){
    
    $("#dialog_box_select_invitee .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_select_invitee .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var postReRenderEdit = function(){
	var currWhatID = $.trim($(".what_id_object_name_new").text());
    var currWhoID = $.trim($(".what_name_new").text());
    
	populateRelatedToField(currWhatID, currWhoID);
};

var postReRenderSave = function(){
    var isMobile = (window.screen.width >= 320 && window.screen.width < 768 ) ? true : false;
    if(isMobile){
        var resTextMobile = $(".res_button_txt_mobile").text();
        $(".mfs-btn-money-in-motion").val(resTextMobile);
    }
    
    var currWhatID = $.trim($(".what_id_object_name_new").text());
    var currWhoID = $.trim($(".what_name_new").text());
    
	populateRelatedToField(currWhatID, currWhoID);
    
    refreshPrimaryTab();
    
    if(isConsole == "true"){
    	sforce.console.setTabUnsavedChanges(false);    
    }
    else{
        window.onbeforeunload = null;
    }
};

var postReRenderMMRPopUpWindow = function(saveFlag){
    if(!saveFlag){
     	MMRMaterialTypeChange($(".mmr_material_type"));   
    }
    
    if($.trim($(".mmr_create_status").text()) == ""){
        $(".mmr_fld_org_name").val($.trim($(".curr_organization_name_create").text()));    
    }
    else{
        $(".mmr_fld_org_name").val($.trim($(".curr_organization_name").text()));    
    }
    
    if($.trim($("[id*='mmr_fld_user_profile_hidden']").text()) == $.trim($(".gcr_profile_name").text())){
        $("[id*='mmr_fld_user_profile_hidden']").next().attr("disabled", "disabled");
    }
    
    $("#dialog_box_meeting_material .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_meeting_material .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};


var postReRenderSRPopUpWindow = function(){
    $("#dialog_box_speaker_request .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_speaker_request .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var postReRenderCARPopUpWindow = function(){    
    initLookupCompPortfolioNotify();
    initLookupCompPortfolio();
    
    $("#dialog_box_competitive_ananlysis .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_competitive_ananlysis .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var disableCAStatus = function(){
    if($("[id*='request_report_check']").is(":checked") == false){
        $(".mfs_ca_status_disabled").attr("disabled", "disabled");
    }    
};

var postReRenderInvitees = function(){
    $(".dialog_box_select_invitee .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $(".dialog_box_select_invitee .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var initRES = function(){
  	$(".money_in_motion > div[role='alertdialog'], .money_in_motion > div[role='dialog']").removeClass("slds-fade-in-open");  
};

var closeRESErrorModal = function(elem){
    $(elem).parents("div[role='alertdialog']").removeClass("slds-fade-in-open");
    $(elem).parents("div[role='alertdialog']").next(".slds-backdrop").removeClass("slds-backdrop--open");
    
    $(".money_in_motion").addClass("slds-hide");
};

var closeRESModal = function(e, elem){
    if(e){
        e.preventDefault();
    }
    
    $(elem).parents(".slds-modal").removeClass("slds-fade-in-open");
    $(elem).parents(".slds-modal").next(".slds-backdrop").removeClass("slds-backdrop--open");
    
    $(elem).parents(".money_in_motion").addClass("slds-hide");
};

var postReRenderRES = function(){
    var resStatus = $.trim($(".res_status").text());
    console.log(resStatus);
    $('#op_closed_reason select').addClass('slds-select');
    
    hideLoading();
    $(".money_in_motion").removeClass("slds-hide");
    
    if(resStatus == "false"){
        $(".money_in_motion div[role='alertdialog']").removeClass("slds-fade-in-close").addClass("slds-fade-in-open");
    }
    else{
        console.log($(".money_in_motion div[role='dialog']"));
        $(".money_in_motion div[role='dialog']").removeClass("slds-fade-in-close").addClass("slds-fade-in-open");
    }
    
    $(".money_in_motion .slds-backdrop").removeClass("slds-backdrop--close").addClass("slds-backdrop--open");
};

var setCurrentLookupValue = function(val, elem){
    elem.val(val);
};

var setCurrentDateTimeValue = function(val, elem){
    elem.val(val);
};


var prevDefault = function(e){
    e.preventDefault();
};

var __setRelatedPerson = function(elem, lookupType){
    var sfdcID = $(elem).data("sfdc-id");
    var currSelectedText = $.trim($(elem).text());
    var currSearchElem = $(elem).parent(".slds-lookup__list").data("curr-search-elem");
    
    if(currSearchElem){
        $(currSearchElem).val(currSelectedText);
        if(lookupType == "Account"){
        	$("input[type='hidden'][data-lookup-name='selected_lookup']").val(sfdcID);    
        }
        else if(lookupType == "Related"){
         	$("input[type='hidden'][data-lookup-name='selected_lookup2']").val(sfdcID);
        }
        else if(lookupType == "FollowUpAccount"){
         	$("input[type='hidden'][data-lookup-name='follow_up_name']").val(sfdcID);
        }
        else if(lookupType == "FollowUpRelated"){
         	$("input[type='hidden'][data-lookup-name='follow_up_related_to']").val(sfdcID);
        }
    }
    
    displayOrganizationTiedToAContact();
};

var validatePortfolioField = function(elem, e){
    if($.trim($(elem).val()) == ""){
        return false;
    }
    
    e.preventDefault();
};

var validateModalForm = function(btn){
    var allRequiredElements = $(btn).parents(".slds-modal").find(".slds-form-element.slds-is-required:visible");
    var allGood = true;
    
    for(var i=0, iLen = allRequiredElements.length; i < iLen; i++){
        if($(allRequiredElements[i]).find("input.slds-input:not([disabled])").val() == "" || $(allRequiredElements[i]).find("select.slds-select:not([disabled])").val() == "" || $(allRequiredElements[i]).find('[data-aljs="multi-select"]').prev().val() == ""){
            $(allRequiredElements[i]).find("input.slds-input").addClass("slds-dirty-input");
            $(allRequiredElements[i]).find("select.slds-select").addClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-picklist--draggable .slds-picklist__options").addClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-form-element__label abbr").css("display","inline-block");
            allGood = false;
        }
        else{
            $(allRequiredElements[i]).find("input.slds-input").removeClass("slds-dirty-input");
            $(allRequiredElements[i]).find("select.slds-select").removeClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-picklist--draggable .slds-picklist__options").removeClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-form-element__label abbr").css("display","none");
        }
    }
    return allGood;
};

var openModalAttachments = function(modal, e){
    e.preventDefault();
    
    $(modal+" .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
    
    $(modal).find(".slds-modal").removeClass("slds-fade-in-close").addClass("slds-fade-in-open");
    $(modal).find(".slds-backdrop").removeClass("slds-backdrop--close").addClass("slds-backdrop--open");
};

var openModal = function(modal, e){
    e.preventDefault();
    
    $(modal+" .slds-modal__content.slds-modal--loading").removeClass("slds-hide");
    $(modal+" .slds-modal__content:not(.slds-modal--loading)").addClass("slds-hide");
    
    $(modal).find(".slds-modal").removeClass("slds-fade-in-close").addClass("slds-fade-in-open");
    $(modal).find(".slds-backdrop").removeClass("slds-backdrop--close").addClass("slds-backdrop--open");
};

var openSpeakerModal = function(){
    
    $("#dialog_box_speaker_request").find(".slds-modal").removeClass("slds-fade-in-close").addClass("slds-fade-in-open");
    $("#dialog_box_speaker_request").find(".slds-backdrop").removeClass("slds-backdrop--close").addClass("slds-backdrop--open");
    $("#dialog_box_speaker_request .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_speaker_request .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};


var closeModal = function(modal, e){
    e.preventDefault();
	
    //$(".slds-inner-scroll--test").css("height", "auto");
    
    $(modal).find(".slds-modal").addClass("slds-fade-in-close").removeClass("slds-fade-in-open");
    $(modal).find(".slds-backdrop").addClass("slds-backdrop--close").removeClass("slds-backdrop--open");
};

var forceCloseModal = function(elem, e){
    if(e){
        e.preventDefault();
    }
    
    //$(".slds-inner-scroll--test").css("height", "auto");
    
    $(elem).parents(".slds-modal").removeClass("slds-fade-in-open").addClass("slds-fade-in-close");
    $(elem).parents(".slds-modal").next(".slds-backdrop").removeClass("slds-backdrop--open").addClass("slds-backdrop--close");
};

var validatePageForm = function(btn, e, formSection){
    e.preventDefault();
    var allRequiredElements = "";
    var allGood = true;
    
    if(formSection){
        allRequiredElements = $(btn).parents(formSection).find(".slds-form-element.slds-is-required:visible");
    }
    else{
        allRequiredElements = $(btn).parents(".slds").find(".slds-form-element.slds-is-required[data-exclude-page-validation != 'true']:visible");
    }
    
    for(var i=0, iLen = allRequiredElements.length; i < iLen; i++){
        if( $(allRequiredElements[i]).find("input.slds-input").val() == ""){
            $(allRequiredElements[i]).find("input.slds-input").addClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-form-element__label abbr").css("display","inline-block");
            allGood = false;
        }
        else if($(allRequiredElements[i]).find("select.slds-select").val() == "" || $(allRequiredElements[i]).find("select.slds-select").val() === "None"){
            $(allRequiredElements[i]).find("select.slds-select").addClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-form-element__label abbr").css("display","inline-block");
            allGood = false;
        }
        else{
            $(allRequiredElements[i]).find("input.slds-input").removeClass("slds-dirty-input");
            $(allRequiredElements[i]).find("select.slds-select").removeClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-form-element__label abbr").css("display","none");
        }
    }
    
    if(allGood){
        console.log("allGood", allGood, $(btn).parent().find("input[type='submit']"));
        $(btn).parent().find("input[type='submit']").trigger("click");
        
        //$(btn).next("input[type='submit']").trigger("click");
    }
};

var validatePageFormBAR = function(btn, e, formSection){
    e.preventDefault();
    var allRequiredElements = "";
    var allGood = true;
    
    if(formSection){
        allRequiredElements = $(btn).parents(formSection).find(".slds-form-element.slds-is-required:visible");
    }
    else{
        allRequiredElements = $(btn).parents(".slds").find(".slds-form-element.slds-is-required[data-exclude-page-validation != 'true']:visible");
    }
    //console.log(allRequiredElements);
    
    for(var i=0, iLen = allRequiredElements.length; i < iLen; i++){
        if( $(allRequiredElements[i]).find("input.slds-input").val() == ""){
            $(allRequiredElements[i]).find("input.slds-input").addClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-form-element__label abbr").css("display","inline-block");
            allGood = false;
        }
        else if($(allRequiredElements[i]).find("select.slds-select").val() == "" || $(allRequiredElements[i]).find("select.slds-select").val() === "None"){
            $(allRequiredElements[i]).find("select.slds-select").addClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-form-element__label abbr").css("display","inline-block");
            allGood = false;
        }
        else if($(allRequiredElements[i]).find('[data-aljs="multi-select"]').prev().val() == ""){
            $(allRequiredElements[i]).find(".slds-picklist--draggable .slds-picklist__options").addClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-form-element__label abbr").css("display","inline-block");
            allGood = false;
        }
        else{
            $(allRequiredElements[i]).find("input.slds-input").removeClass("slds-dirty-input");
            $(allRequiredElements[i]).find("select.slds-select").removeClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-picklist--draggable .slds-picklist__options").removeClass("slds-dirty-input");
            $(allRequiredElements[i]).find(".slds-form-element__label abbr").css("display","none");
        }
    }
    
    if(allGood){
        console.log("allGood", allGood, $(btn).parent().find(".mfs_save_bar_action"));
        $(btn).parent().find(".mfs_save_bar_action").trigger("click");
        
        //$(btn).next("input[type='submit']").trigger("click");
    }
};

var showLoading = function(){
    $(".slds").append('<div class="slds-loader--container"><div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog"><div class="slds-modal__container"><div class="slds-text-align--center loader-container"><img src="/resource/MFS_UI_Assets/assets/images/spinners/slds_spinner_brand.gif" width="50" /></div></div></div><div class="slds-backdrop slds-backdrop--open"></div></div>');
};

var hideLoading = function(){
    $(".slds").find(".slds-loader--container").remove();
};


//Meeting Material Request
var MMRMaterialTypeChange = function(elem){
    var currVal = $(elem).val();
    var isEditable = $.trim($(".mmr_create_status").text()) !== "" ? true : false;
    console.log("isEditable MMR", isEditable);
    
    $(".meeting_material_request_form input[type='text']").attr("disabled", "disabled");
    $(".meeting_material_request_form input[type='text']").attr("disabled", "disabled");
    $(".meeting_material_request_form textarea").attr("disabled", "disabled");
    $(".meeting_material_request_form select:not(.mmr_material_type)").attr("disabled", "disabled");
    
    $(".mmr_fld_date_due_to_client").removeAttr("disabled");
    $(".mmr_fld_org_name").removeAttr("disabled");
    //$(".mmr_fld_inception_date").removeAttr("disabled");
    $(".mmr_fld_additional_comments").removeAttr("disabled");
    $(".mmr_fld_cover_page_title").removeAttr("disabled");
    $(".mmr_fld_do_materials_editable").removeAttr("disabled");
    $(".mmr_meeting_room_needed").removeAttr("disabled");
    $(".mmr_fld_desired_time_range").removeAttr("disabled");
    $(".mmr_fld_trinket").removeAttr("disabled");
    //$(".mmr_fld_bench_mark").val('Default - Please update if custom');
    //$(".mmr_fld_cover_page_title").val($(".curr_org_what_name").text());
    //$(".mmr_fld_syntax").val('US English');
    //$(".mmr_fld_do_materials_editable").val('Requested');
    
    $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").removeClass("slds-is-required");
    $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").find("label.slds-form-element__label").find("abbr").remove();
    $(".mfs-time-period-values").parents(".slds-form-element").removeClass("slds-is-required");
    $(".mfs-time-period-values").parents(".slds-form-element").find("label.slds-form-element__label").find("abbr").remove();
    
    $(".mfs-time-period-values").find("button[data-aljs-multi-select]").removeAttr("disabled");
    $(".mfs-time-period-values").find("ul.slds-picklist__options > li").attr("draggable", "true");
    
    switch(currVal){
        case "Client":
            $(".mmr_fld_data_time_period").removeAttr("disabled");
            //$(".mmr_fld_sector_scheme").val("").removeAttr("disabled");
            MMRFieldEmptyHelper($(".mmr_fld_sector_scheme"), isEditable, false);
            $(".mmr_fld_bench_mark").removeAttr("disabled");
            
            $(".mmr_fld_use_crp").removeAttr("disabled");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_syntax").removeAttr("disabled");
            $(".mmr_fld_data_as_of_end_date").removeAttr("disabled", "disabled");
            $(".mmr_fld_overview_section").removeAttr("disabled");
            
            $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").addClass("slds-is-required");
            $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").find("label.slds-form-element__label").append("<abbr>Please complete this field</abbr>");
            
            $(".mfs-time-period-values").parents(".slds-form-element").addClass("slds-is-required");
            $(".mfs-time-period-values").parents(".slds-form-element").find("label.slds-form-element__label").append("<abbr>Please complete this field</abbr>");
            break;
        
        case "Client - CRP":
            if($(".mmr_fld_cover_page_title").val() == ''){
                $(".mmr_fld_cover_page_title").val($(".curr_org_what_name").text());
            }
            
            if($(".mmr_fld_bench_mark").val()==''){
             	$(".mmr_fld_bench_mark").val("Default - Please update if custom");   
            }
            
            $(".mmr_fld_syntax").removeAttr("disabled");
            $(".mmr_fld_data_as_of_end_date").removeAttr("disabled", "disabled");
            $(".mmr_fld_overview_section").removeAttr("disabled");
            //$(".mmr_fld_sector_scheme").val("");
            MMRFieldEmptyHelper($(".mmr_fld_sector_scheme"), isEditable);
            
            $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").addClass("slds-is-required");
            $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").find("label.slds-form-element__label").append("<abbr>Please complete this field</abbr>");
            
            $(".mfs-time-period-values").parents(".slds-form-element").addClass("slds-is-required");
            $(".mfs-time-period-values").parents(".slds-form-element").find("label.slds-form-element__label").append("<abbr>Please complete this field</abbr>");
            
            break;
            
        case "Client - PRP":
            if($(".mmr_fld_cover_page_title").val() == ''){
                $(".mmr_fld_cover_page_title").val($(".curr_org_what_name").text());
            }
            if($(".mmr_fld_bench_mark").val()==''){
             	$(".mmr_fld_bench_mark").val("Default - Please update if custom");   
            }
            
            $(".mmr_fld_syntax").removeAttr("disabled");
            $(".mmr_fld_data_as_of_end_date").removeAttr("disabled", "disabled");
            $(".mmr_fld_overview_section").removeAttr("disabled");
            //$(".mmr_fld_sector_scheme").val("").attr("disabled", "disabled");
            MMRFieldEmptyHelper($(".mmr_fld_sector_scheme"), isEditable, true);
            
            $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").addClass("slds-is-required");
            $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").find("label.slds-form-element__label").append("<abbr>Please complete this field</abbr>");
            
            $(".mfs-time-period-values").parents(".slds-form-element").addClass("slds-is-required");
            $(".mfs-time-period-values").parents(".slds-form-element").find("label.slds-form-element__label").append("<abbr>Please complete this field</abbr>");
            
            break;
            
        case "Consultant":
            $(".mmr_fld_data_time_period").removeAttr("disabled");
            $(".mmr_fld_sector_scheme").removeAttr("disabled");
            $(".mmr_fld_bench_mark").removeAttr("disabled");
            if($(".mmr_fld_cover_page_title").val() == ''){
                $(".mmr_fld_cover_page_title").val($(".curr_org_what_name").text());
            }
            if($(".mmr_fld_bench_mark").val()==''){
             	$(".mmr_fld_bench_mark").val("Default - Please update if custom");   
            }
            
            $(".mmr_fld_use_crp").removeAttr("disabled");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_syntax").removeAttr("disabled");
            $(".mmr_fld_data_as_of_end_date").removeAttr("disabled", "disabled");
            $(".mmr_fld_overview_section").removeAttr("disabled");
            $(".mmr_fld_sector_scheme").val("MFSI Standard (13 Sectors)");
            
            $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").addClass("slds-is-required");
            $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").find("label.slds-form-element__label").append("<abbr>Please complete this field</abbr>");
            
            $(".mfs-time-period-values").parents(".slds-form-element").addClass("slds-is-required");
            $(".mfs-time-period-values").parents(".slds-form-element").find("label.slds-form-element__label").append("<abbr>Please complete this field</abbr>");
            break;    
            
        case "Introductory Transition Call":
            if($(".mmr_fld_cover_page_title").val() == ''){
                $(".mmr_fld_cover_page_title").val($(".curr_org_what_name").text());
            }
            if($(".mmr_fld_bench_mark").val() == ''){
                $(".mmr_fld_bench_mark").val("Default - Please update if custom");   
            }
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_desired_time_range").attr("disabled", "disabled");
            $(".mmr_fld_syntax").removeAttr("disabled");
            //$(".mmr_fld_sector_scheme").val("");
            MMRFieldEmptyHelper($(".mmr_fld_sector_scheme"), isEditable);
            
            $(".mfs-time-period-values").find("button[data-aljs-multi-select]").attr("disabled", "disabled");
            $(".mfs-time-period-values").find("ul.slds-picklist__options > li").removeAttr("draggable");
            break;
        
        case "CRP Only":
            if($(".mmr_fld_cover_page_title").val() == ''){
                $(".mmr_fld_cover_page_title").val($(".curr_org_what_name").text());
            }
            if($(".mmr_fld_bench_mark").val()=='')
            	$(".mmr_fld_bench_mark").val("Default - Please update if custom");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_desired_time_range").attr("disabled", "disabled");
            //$(".mmr_fld_sector_scheme").val("");
            MMRFieldEmptyHelper($(".mmr_fld_sector_scheme"), isEditable);
            
            $(".mfs-time-period-values").find("button[data-aljs-multi-select]").attr("disabled", "disabled");
            $(".mfs-time-period-values").find("ul.slds-picklist__options > li").removeAttr("draggable");
            break;
            
        case "PRP Only":
            if($(".mmr_fld_cover_page_title").val() == ''){
                $(".mmr_fld_cover_page_title").val($(".curr_org_what_name").text());
            }
            if($(".mmr_fld_bench_mark").val()==''){
             	$(".mmr_fld_bench_mark").val("Default - Please update if custom");   
            }
            
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_desired_time_range").attr("disabled", "disabled");
            //$(".mmr_fld_sector_scheme").val("");
            MMRFieldEmptyHelper($(".mmr_fld_sector_scheme"), isEditable);
            
            $(".mfs-time-period-values").find("button[data-aljs-multi-select]").attr("disabled", "disabled");
            $(".mfs-time-period-values").find("ul.slds-picklist__options > li").removeAttr("draggable");
            break;
        
            
        case "Webcast":
            if($(".mmr_fld_cover_page_title").val() == ''){
                $(".mmr_fld_cover_page_title").val($(".curr_org_what_name").text());
            }
            if($(".mmr_fld_bench_mark").val()==''){
             	$(".mmr_fld_bench_mark").val("Default - Please update if custom");   
            }
            
            $(".mmr_fld_trinket").val("Hardcopy (in person)").attr("disabled", "disabled");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_cover_page_title").attr("disabled", "disabled");
            $(".mmr_fld_data_as_of_end_date").removeAttr( "disabled");
            $(".mmr_fld_syntax").removeAttr("disabled");
            $(".mmr_fld_bench_mark").val("Default - Please update if custom");
            //$(".mmr_fld_sector_scheme").val("");
            MMRFieldEmptyHelper($(".mmr_fld_sector_scheme"), isEditable);
            
            $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").addClass("slds-is-required");
            $(".mmr_fld_data_as_of_end_date").parents(".slds-form-element").find("label.slds-form-element__label").append("<abbr>Please complete this field</abbr>");
            
            $(".mfs-time-period-values").parents(".slds-form-element").addClass("slds-is-required");
            $(".mfs-time-period-values").parents(".slds-form-element").find("label.slds-form-element__label").append("<abbr>Please complete this field</abbr>");
            
            break;
                
        case "Generic/Sales":
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_desired_time_range").attr("disabled", "disabled");
            $(".mmr_fld_syntax").removeAttr("disabled");
            $(".mmr_fld_overview_section").removeAttr("disabled");
            $(".mmr_fld_sector_scheme").val("MFSI Standard (13 Sectors)");
            
            $(".mfs-time-period-values").find("button[data-aljs-multi-select]").attr("disabled", "disabled");
            $(".mfs-time-period-values").find("ul.slds-picklist__options > li").removeAttr("draggable");
            break;
            
        default:
            $(".mmr_fld_bench_mark").removeAttr("disabled");
            $(".mmr_fld_overview_section").removeAttr("disabled");
            $(".mmr_fld_data_as_of_end_date").removeAttr("disabled");
            $(".mmr_fld_syntax").removeAttr("disabled");
            $(".mmr_fld_sector_scheme").removeAttr("disabled");
            break;
    }   
};

var MMRFieldEmptyHelper = function(field, emptyFlag, disableFlag){
    if(emptyFlag && field.val() !== ""){
        //debugger;
        //field.val("");
    }
    else{
        console.log("sector scheme is going to get cleared");
        field.val("");
    }
    
    if(disableFlag){
        field.attr("disabled", "disabled");
    }
    else{
       field.removeAttr("disabled"); 
    }
};

var MMRDataTimePeriodChange = function(elem){
    var currVal = $(elem).val();
    
    if(currVal == "Other"){
        $(".mmr_fld_data_as_of_end_date").attr("disabled", "disabled");
    }
    else{
        $(".mmr_fld_data_as_of_end_date").removeAttr("disabled");
    }
};

var setSelectedMMRLookup = function(elem, e, lookupType){
    var sfdcID = $(elem).data("sfdc-id");
    var currSelectedText = $.trim($(elem).text());
    var currSearchElem = $(elem).parents(".slds-lookup").find("input[type='text']");
    currSearchElem.prev("input[type='hidden']").val(sfdcID);
    
    if(lookupType == "ORG_NAME"){
    	fetchMMRTeamMembers();
    }
    else if(lookupType == "CLIENT_INVESTMENTS"){
        addMMRPortfolios();
    }
    
    $(currSearchElem).val(currSelectedText);
};

var setSelectedRESLookup = function(elem, e, lookupType){
    var sfdcID = $(elem).data("sfdc-id");
    var currSelectedText = $.trim($(elem).text());
    var currSearchElem = $(elem).parents(".slds-lookup").find("input[type='text']");
    currSearchElem.prev("input[type='hidden']").val(sfdcID);
    
    $(currSearchElem).val(currSelectedText);
};

var dateDueToClient = function(val, elem){
    constructMMRName();
};

var setFollowUpActivityTypeValues = function(){
    setTimeout(function(){
        var selectedActTypes = $(".mfs-follow-up-act-types").multiSelect("getSelectedItems");
        
        var selectedActsArr = [];
        for(var i=0, iLen = selectedActTypes.length; i < iLen; i++){
            selectedActsArr.push(selectedActTypes[i]["label"]);
        }
        $("input[id*='follow_up_activity_type_hidden']").val(selectedActsArr.join(";"));
        
    }, 100);
};

var setActivityTypeValues = function(){
    setTimeout(function(){
        var selectedActTypes = $(".mfs-act-types").multiSelect("getSelectedItems");
        
        var selectedActsArr = [];
        for(var i=0, iLen = selectedActTypes.length; i < iLen; i++){
            selectedActsArr.push(selectedActTypes[i]["label"]);
        }
        $("input[id*='activity_type_hidden']").val(selectedActsArr.join(";"));
        
    }, 100);
};

var setTranslationLangValues = function(){
    setTimeout(function(){
        var selectedTranslationLangs = $(".mfs-translation-languages").multiSelect("getSelectedItems");
        
        var selectedLangsArr = [];
        for(var i=0, iLen = selectedTranslationLangs.length; i < iLen; i++){
            selectedLangsArr.push(selectedTranslationLangs[i]["label"]);
        }
        $("input[id*='mmr_fld_translation_lang_hidden']").val(selectedLangsArr.join(";"));
          
        addLanguageFields();
    }, 100);
};

//Added for MMR
var setTimePeriodValues = function(){
    setTimeout(function(){
        var selectedTranslationLangs = $(".mfs-time-period-values").multiSelect("getSelectedItems");
        
        var selectedLangsArr = [];
        for(var i=0, iLen = selectedTranslationLangs.length; i < iLen; i++){
            selectedLangsArr.push(selectedTranslationLangs[i]["label"]);
        }
        $("input[id*='mmr_fld_time_period_hidden']").val(selectedLangsArr.join(";"));
    }, 100);
};

var setPerformancePeriodValues = function(){
    setTimeout(function(){
        var selectedTranslationLangs = $(".mfs-performance-period").multiSelect("getSelectedItems");
        
        var selectedLangsArr = [];
        for(var i=0, iLen = selectedTranslationLangs.length; i < iLen; i++){
            selectedLangsArr.push(selectedTranslationLangs[i]["label"]);
        }
        $("input[id*='mmr_fld_performance_period__hidden']").val(selectedLangsArr.join(";"));
          
        //addLanguageFields();
    }, 100);
};

var setEventTypeValues = function(){
    setTimeout(function(){
        var selectedTranslationLangs = $(".mfs-event-type").multiSelect("getSelectedItems");
        
        var selectedLangsArr = [];
        for(var i=0, iLen = selectedTranslationLangs.length; i < iLen; i++){
            selectedLangsArr.push(selectedTranslationLangs[i]["label"]);
        }
        $("input[id*='mmr_fld_event_type__hidden']").val(selectedLangsArr.join(";"));
        //console.log($("input[id*='mmr_fld_event_type__hidden']").val()) 
        //addLanguageFields();
    }, 100);
};

var setRecurrenceStartDay = function(){
    setTimeout(function(){
        var selectedDays = $(".mfs-recurrence-start-day").multiSelect("getSelectedItems");
        var selectedDaysArr = [];
        
        for(var i=0, iLen = selectedDays.length; i < iLen; i++){
            selectedDaysArr.push(selectedDays[i]["label"]);
        }
        $(".mfs-recurrence-start-day").prev().val(selectedDaysArr.join(";"));
        
        renderSummary();
    }, 100);
};

var selectedAttendeesRelatedActs = [];
var setValuesToInviteePopupForRelatedActsSearch = function(){
    setTimeout(function(){
        var selectedAdditionalNotifiers = $(".mfs-invitees-popup").multiSelect("getSelectedItems");
        var selectedNotifiersObj = {};
        var selectedItemsArrSemicolon = [];
        
        selectedAttendeesRelatedActs = [];
        for(var i=0, iLen = selectedAdditionalNotifiers.length; i < iLen; i++){
            selectedNotifiersObj = {};
            selectedNotifiersObj["id"] = selectedAdditionalNotifiers[i]["id"];
            selectedNotifiersObj["name"] = selectedAdditionalNotifiers[i]["label"].split("-")[0];
            
            selectedAttendeesRelatedActs.push(selectedNotifiersObj);
            selectedItemsArrSemicolon.push(selectedNotifiersObj["id"]);
            
            //$("[id*='selectedAttendeeHidden']").val(selectedItemsArrSemicolon.join(","));
            $(".mfs-invitees-popup").prev().val(selectedItemsArrSemicolon.join(","));
        }
    }, 100);
};

var setValuesToInviteePopup = function(){
    setTimeout(function(){
        var selectedAdditionalNotifiers = $(".mfs-invitees-popup").multiSelect("getSelectedItems");
        var selectedNotifiersArr = [];
        for(var i=0, iLen = selectedAdditionalNotifiers.length; i < iLen; i++){
            selectedNotifiersArr.push(selectedAdditionalNotifiers[i]["id"]);
        }
        
        $("input[id*='mfs_fld_selected_invitees_hidden']").val(selectedNotifiersArr.join(";"));
        
        //console.log($("[id*='mfs_fld_selected_invitees_hidden']").val());
        
    }, 100);
};

var setAttributionPeriod = function(){
    setTimeout(function(){
        var selectedAttrPeriod = $(".mfs-attribution-period").multiSelect("getSelectedItems");
        
        var selectedLangsArr = [];
        for(var i=0, iLen = selectedAttrPeriod.length; i < iLen; i++){
            selectedLangsArr.push(selectedAttrPeriod[i]["label"]);
        }
        $("input[id*='mmr_fld_attribution_period_hidden']").val(selectedLangsArr.join(";"));
          
     }, 100);
};

var setAdditionalNotifiersCA = function(){
    setTimeout(function(){
        var selectedAdditionalNotifiers = $(".mfs-additional-notifiers").multiSelect("getSelectedItems");
        var selectedNotifiersArr = [];
        for(var i=0, iLen = selectedAdditionalNotifiers.length; i < iLen; i++){
            selectedNotifiersArr.push(selectedAdditionalNotifiers[i]["id"]);
        }
        pullJsonForSelectedNotifiersOfCA(selectedNotifiersArr.join(","));
        //$("[id*='testInputHidden']").val(selectedNotifiersArr.join(","));
        
    }, 100);
};

var setAdditionalNotifiersRES = function(){
    setTimeout(function(){
        var selectedAdditionalNotifiers = $(".mfs-res-additional-notifiers").multiSelect("getSelectedItems");
        var selectedNotifiersArr = [];
        for(var i=0, iLen = selectedAdditionalNotifiers.length; i < iLen; i++){
            selectedNotifiersArr.push(selectedAdditionalNotifiers[i]["id"]);
        }
        
        $("[id*='selectedCoverageTeamMembers']").val(selectedNotifiersArr.join(","));
        
        console.log($("[id*='selectedCoverageTeamMembers']").val());
        
    }, 100);
};

var setScrollBarPosition = function(){
    var mmrModalContent = $('#dialog_box_meeting_material .slds-modal__content:not(.slds-modal--loading)');
    var height = mmrModalContent[0].scrollHeight;
    mmrModalContent.scrollTop(height);
};

var populateRelatedToField = function(currWhatID, currWhoID){ 
    //console.log(currWhatID, currWhoID);
    
    var mainRelatedToElem = $(".slds-lookup--polymorphic");
    
    if(currWhatID == "Account" ){
        $(".what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#account"></use>'+
                                           '</svg>');
        
        $(".curr_related_to_input").val(currWhoID);
    }
    else if(currWhatID == "Opportunity"){
        $(".what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-opportunity slds-icon--small">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#opportunity"></use>'+
                                           '</svg>');
        
        $(".curr_related_to_input").val(currWhoID);
    }
    else if(currWhatID == "Campaign"){
        $(".what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon--small slds-icon-standard-campaign">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#campaign"></use>'+
                                           '</svg>');
        
        $(".curr_related_to_input").val(currWhoID);
    }
    else if(currWhatID == "Business_at_Risk__c"){
        $(".what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon--small slds-icon-custom-custom84">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/custom-sprite/svg/symbols.svg#custom84"></use>'+
                                           '</svg>');
        
        $(".curr_related_to_input").val(currWhoID);
    }
    else if(currWhatID == "Strategy_Plan__c"){
        $(".what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon--small slds-icon-standard-goals">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#goals"></use>'+
                                           '</svg>');
        
        $(".curr_related_to_input").val(currWhoID);
    }
    else if(currWhatID == "Consultant_Rating__c"){
        $(".what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon--small slds-icon-standard-poll">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#poll"></use>'+
                                           '</svg>');
        
        $(".curr_related_to_input").val(currWhoID);
    }
    else if(currWhatID == "Case"){
        $(".what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon--small slds-icon-standard-case">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#case"></use>'+
                                           '</svg>');
        
        $(".curr_related_to_input").val(currWhoID);
    }
	else{
        $(".what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#account"></use>'+
                                           '</svg>');
        
        $(".curr_related_to_input").val(currWhoID);
	}
};

var checkIfEventTimeFieldsDisabled = function(){
    var allEventTimeList = $(".mfs_event_time_field");
    for(var i=0, iLen = allEventTimeList.length; i < iLen; i++){
        if($(allEventTimeList[i]).find("select").is(":disabled")){
           $(allEventTimeList[i]).removeClass("slds-is-required"); 
        }
        else{
            $(allEventTimeList[i]).addClass("slds-is-required"); 
        }
    }
};

var disableEnterKey = function(e){
    if(e.keyCode === 13){
        e.preventDefault();
        e.stopPropagation();
        showLoading();
        searchInvitee();
        
        return false;
    }
};

var searchComPortfolioCAGo = function(){
    showLoading();
    searchComPortfolioFromCAOnEnter();
};

var searchPortfolioGo = function(){
    showLoading();
    allSelectedPorts = [];
    $("[id*='sProd']").val("");
    $("[id*='cProd']").val("");
    searchPortfolioOnEnter();
};

var searchComPortfolioGo = function(){
    showLoading();
    allSelectedPorts = [];
    $("[id*='scProdc']").val("");
    $("[id*='ccProdc']").val("");
    searchComPortfolioOnEnter();
};

var refreshPrimaryTab = function(){
    sforce.console.getEnclosingPrimaryTabId(function(result){
        console.log(result.id);
        var primaryTabId = result.id;
        sforce.console.refreshPrimaryTabById(primaryTabId, true, refreshSuccess);
    });
};

var refreshSuccess = function refreshSuccess(result) {
    //Report whether refreshing the primary tab was successful
    if (result.success == true) {
        console.log('Primary tab refreshed successfully');
    } else {
        console.log('Primary did not refresh');
    }
};


var postReRenderAdditionalMeetingDetails = function(){
    $("#additional_meeting_details_modal .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#additional_meeting_details_modal .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var postReRenderMeetingPrepPopUpWindow = function(){    
        
        $("#additional_meeting_details_modal .slds-modal__content.slds-modal--loading").addClass("slds-hide");
        $("#additional_meeting_details_modal .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};
function srcUp(url){
    //var url = "/"+recordID;
    if(sforce.console.isInConsole() || isConsole == 'true'){
        A360OpenPrimaryTab(url, "");
    }
    else if((typeof sforce != 'undefined') && sforce && (!!sforce.one)){
        sforce.one.navigateToURL(url);
    }
	else{
		window.open(url, "_parent");
	}
}

function openHyperlinks(recordID, title, isConsole){
    //alert('inside openhyperlinks');
    var url = "/"+recordID
    if(sforce.console.isInConsole() || isConsole == 'true'){
        A360OpenPrimaryTab(url, title);
    }
    else if((typeof sforce != 'undefined') && sforce && (!!sforce.one)){
        sforce.one.navigateToURL(url);
    }
	else{
		window.open(url, "_new");
	}
}

function A360OpenPrimaryTab(url, title){
    sforce.console.openPrimaryTab(null, url, true, title);
}

var postReRenderConstructMMR = function(){
    MMRMaterialTypeChange($(".mmr_material_type"));
};

var setPageModifiedEvent = function(){
    window.onbeforeunload = function(evt) {
        console.log("Page modified!");
        var message = 'Seems like there are some un-saved changes in the form.';
        if (typeof evt == 'undefined') {
            evt = window.event;
        }
        if (evt) {
            evt.returnValue = message;
        }
        
        return message;
    }
};

$("html").on("click", function(){
	$(".slds-lookup__menu").hide();
	$(".slds-dropdown").hide();
	//closeDropDowns();
});

var initDatePickers = function(){
    
    $.aljsInit({
        assetsLocation: "/resource/SLDS202"
    });
    
    var allDatePickers = $(".dateInput input[type='text']");
    
    for(var i=0, iLen = allDatePickers.length; i < iLen; i++){
        (function(datePickerElem){
            var mainParentElem, datePickerHTML;
            var iconHTML = '<svg aria-hidden="true" class="slds-input__icon slds-icon-text-default" style="cursor: pointer;"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/utility-sprite/svg/symbols.svg#event"></use></svg>';
            
            $(datePickerElem)[0].removeAttribute("onfocus");
            $(datePickerElem).parent().find(".dateFormat").remove();
            
            mainParentElem = $(datePickerElem).parent().parent();
            datePickerHTML = $(datePickerElem).parent().html();
            
            $(datePickerElem).parent().remove();
            mainParentElem.html(iconHTML+datePickerHTML);
            
            mainParentElem.find("input[type='text']").datepicker({
                onChange : function(datepicker){
                    if($(datePickerElem).data("callback")){
                        var res = ( new Function( 'return ' + $(datePickerElem).data("callback") ) )();
                        
                        if(typeof(res) == "function"){
                            res(datepicker.$el.val(), datepicker.$el);
                        }
                    }
                }
            });
        })(allDatePickers[i]);
    }
};

var initMultiSelects = function(){
    var allMultiSelects = $("[data-aljs='multi-select']");
    
    for(var i=0, iLen = allMultiSelects.length; i < iLen; i++){
        (function(multiSelectElem){
            var dataType = $(multiSelectElem).data("type") == "json" ? "JSON" : "CSV";
            if($(multiSelectElem).data("unselected-items")){
                if(dataType == "JSON"){
                 	var leftValuesJSON = $(multiSelectElem).data("unselected-items");
                }
                else{
                    var leftValuesJSON = formatToJSON($(multiSelectElem).data("unselected-items")) ? formatToJSON($(multiSelectElem).data("unselected-items")) : [];
                }
            }
            
            if($(multiSelectElem).data("selected-items")){
                if(dataType == "JSON"){
                	var rightValuesJSON = $(multiSelectElem).data("selected-items");
                }
                else{
                    var rightValuesJSON = formatToJSON($(multiSelectElem).data("selected-items")) ? formatToJSON($(multiSelectElem).data("selected-items")) : [];
                }
            }
            $(multiSelectElem).multiSelect({
                unselectedItems: leftValuesJSON,
                selectedItems: rightValuesJSON
            });
        })(allMultiSelects[i]);
    } 
};

var formatToJSON = function(csv){
    var csvArr = csv.split(",");
    var jsonArr = [];
    for(var i=0, iLen = csvArr.length; i < iLen; i++){
        jsonArr[i] = {};
        jsonArr[i]["id"] = csvArr[i].replace(/ /g, "__");
        jsonArr[i]["label"] = csvArr[i];
    }
    
    return jsonArr;
};

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

var initLookup1 = function(){
    if(allUsers !== ""){
        var allUsersObj = JSON.parse(allUsers);
        var currUserIDFromEdit = $("input[type='hidden'][data-lookup-name='selected_lookup1']").val();
        
        __renderLookupField($(".mfs_assigned_to"), allUsersObj["Users"], currUserNameFromEdit, currUserIDFromEdit);
    }
    
    Lookup.initLookup();
};



var initLookup3 = function(){
    if(allPortfolios !== ""){
        var allPortfoliosObj = JSON.parse(allPortfolios);
        __renderLookupField($(".mfs_portfolio"), allPortfoliosObj["MFS Portfolios"]);
    }
    
    Lookup.initLookup();
};

var initLookup4 = function(){
    if(allCompetitorPortfolios !== ""){
        var allCompetitorPortfoliosObj = JSON.parse(allCompetitorPortfolios);
        __renderLookupField($(".mfs_comp_portfolio"), allCompetitorPortfoliosObj["MFS Competitor Portfolios"]);
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
    //showLoading();
    //currLookupElem.prev("input[type='hidden']").val(val);
    //console.log(val);
    
    var invID = $(currLookupElem).parents(".invitee-row").data("invitee-id");
    $(currLookupElem).prev().val(val);
    console.log("after setting", $(currLookupElem).prev().val());
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
    
    //alert($("input[type='hidden'][data-lookup-name='selected_lookup1']").val());
    
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
	var isTablet = $(window).width() <= 769 ? true : false;
	if(isTablet){
		var readDeviceOrientation = function(){
			if (Math.abs(window.orientation) === 90) {
				setInitialHeight("Landscape");
			} else {
				setInitialHeight("Portrait");
			}
		};
		
        readDeviceOrientation();
		
        $(window).on("orientationchange", function(){
			readDeviceOrientation();
			setContainerHeight();
		});
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

var initSelectModal = function(){
	$(".selectInviteeBtn").click(function(e) {
		 e.preventDefault();
		
        $("#dialog_box_select_invitee .slds-modal__content.slds-modal--loading").removeClass("slds-hide");
		$("#dialog_box_select_invitee .slds-modal__content:not(.slds-modal--loading)").addClass("slds-hide");
        
		$("#dialog_box_select_invitee").find(".slds-modal").removeClass("slds-fade-in-close").addClass("slds-fade-in-open");
		$("#dialog_box_select_invitee").find(".slds-backdrop").removeClass("slds-backdrop--close").addClass("slds-backdrop--open");
	});
	
	$('.closeInviteeModalWindow').click(function(e) {
		e.preventDefault();
		
		$("#dialog_box_select_invitee").find(".slds-modal").removeClass("slds-fade-in-open").addClass("slds-fade-in-close");
		$("#dialog_box_select_invitee").find(".slds-backdrop").removeClass("slds-backdrop--open").addClass("slds-backdrop--close");
	});
};

var initFollowUpModalWindow = function(){
    $(".follow_up_button").on("click", function(e){
        e.preventDefault();
        
        $("#dialog_box_follow_up .slds-modal__content.slds-modal--loading").removeClass("slds-hide");
        $("#dialog_box_follow_up .slds-modal__content:not(.slds-modal--loading)").addClass("slds-hide");
        
		$("#dialog_box_follow_up").find(".slds-modal").removeClass("slds-fade-in-close").addClass("slds-fade-in-open");
		$("#dialog_box_follow_up").find(".slds-backdrop").removeClass("slds-backdrop--close").addClass("slds-backdrop--open");
	});
	
    $('.close_follow_up').on("click", function(e){
		e.preventDefault();
		
		$("#dialog_box_follow_up").find(".slds-modal").removeClass("slds-fade-in-open").addClass("slds-fade-in-close");
		$("#dialog_box_follow_up").find(".slds-backdrop").removeClass("slds-backdrop--open").addClass("slds-backdrop--close");
	});
};

var postReRenderFollowUpModal = function(){
    currFollowUpOwnerName = $.trim($(".follow_up_owner_name a").text());
    
    $("#dialog_box_follow_up .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_follow_up .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
    
    initFollowUpAssignedTo();
    initDatePickers();
    initMultiSelects();
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
                                                      	'<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#lead"></use>'+
                                                      '</svg>');
        
        $("input[type='hidden'][data-lookup-name='follow_up_related_to']").val("");
        $(".curr_related_to_input_followup").attr("disabled", "disabled").val("");
        $(".curr_related_to_input_followup").parents(".slds-form-element__control").css("background", "#d8dde6");
    }
    else{
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_account']").val("account_contacts");
        $(".who-handle-icon-container_followup").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-opportunity slds-icon--small">'+
                                                      	'<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#contact"></use>'+
                                                   	  '</svg>');
        
        $(".curr_related_to_input_followup").removeAttr("disabled");
        $(".curr_related_to_input_followup").parents(".slds-form-element__control").css("background", "#FFF");
    }
    
    
    if( $.trim($(".what_id_object_value_followup").text()) == "Account" ){
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_related']").val("related_accounts");
        $(".what-handle-icon-container_followup").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">'+
                                                         '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#account"></use>'+
                                                       '</svg>');
    }
    else{
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_related']").val("related_opportunities");
        $(".what-handle-icon-container_followup").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-opportunity slds-icon--small">'+
                                                       	 '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#opportunity"></use>'+
                                                       '</svg>');
    }
    
    $(".curr_account_name_input_followup").val(followUpWhoID);
    $(".curr_related_to_input_followup").val(followUpWhatID);
    
    initFollowUpAssignedTo(currUserName, currUserId);
    initDatePickers();
    initInviteesPortfolioLookup(); 
    initMultiSelects();
    
};

var currFollowUpOwnerID = "";
var currFollowUpOwnerName = "";
var setFollowUpOwnerID = function(ownerID, elem){
    currFollowUpOwnerID = ownerID;
    if(elem){
     	currFollowUpOwnerName = $.trim($(elem).parents(".slds-hint-parent").find("td[data-label='Assigned To']").text());   
    }
};

var closeFollowUpModal = function(){
    $("#dialog_box_follow_up").find(".slds-modal").removeClass("slds-fade-in-open").addClass("slds-fade-in-close");
    $("#dialog_box_follow_up").find(".slds-backdrop").removeClass("slds-backdrop--open").addClass("slds-backdrop--close");
};

var postReRenderCancel = function(){
	initSelectModal();
	initLookup3();
	initLookup4();
	initDateTimePicker();
	//initCARModalWindow();
	//initMMRModalWindow();
    hideLoading();
};

var reRenderIcons = function(container){
	var allIcons = $(container).find(".slds-icon__container");
	for(var i=0, iLen = allIcons.length; i < iLen; i++){
		var iconHTML = '',
			svgIcon = $($(allIcons)[i]).data("rerender-icon"),
			svgClasses = $($(allIcons)[i]).data("render-icon-class");
		
		iconHTML =  '<svg aria-hidden="true" class="'+svgClasses+'">'+
			'<use xlink:href="'+svgIcon+'"></use>'+
			'</svg>';
		
		$($(allIcons)[i]).html(iconHTML);
	}
};

var postReRenderActions = function(){
	reRenderIcons($("#dialog_box_select_invitee"));
    
    $("#dialog_box_select_invitee .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_select_invitee .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var postReRenderEdit = function(){
	reRenderIcons($(".nameLookupFieldIcon"));
	reRenderIcons($(".relatedToLookupFieldIcon"));
	
	var currAssignedTo = $.trim($(".currAssignedTo").text());
	var currWhoID = $.trim($(".currWhoIdName").text());
	var currWhatID = $.trim($(".currWhatIdName").text());
	
	setCurrentLookupValue(currWhoID, $("#lookup"));
	setCurrentLookupValue(currAssignedTo, $("#lookup1"));
	setCurrentLookupValue(currWhatID, $("#lookup2"));
    
    if( $.trim($(".who_id_object_value").text()) == "Lead" ){
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_account']").val("account_leads");
        $(".who-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-lead slds-icon--small">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#lead"></use>'+
                                           '</svg>');
        
        $(".curr_account_name_input").attr("placeholder","Search Lead");
        
        $("input[type='hidden'][data-lookup-name='selected_lookup2']").val("");
        $(".curr_related_to_input").attr("disabled", "disabled").val("");
        $(".curr_related_to_input").parents(".slds-form-element__control").css("background", "#d8dde6");
    }
    else{
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_account']").val("account_contacts");
        $(".who-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-opportunity slds-icon--small">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#contact"></use>'+
                                           '</svg>');
        
        $(".curr_account_name_input").attr("placeholder","Search Contact");
        
        $(".curr_related_to_input").removeAttr("disabled");
        $(".curr_related_to_input").parents(".slds-form-element__control").css("background", "#FFF");
    }
    
    
    if( $.trim($(".what_id_object_value").text()) == "Account" ){
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_related']").val("related_accounts");
        $(".what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#account"></use>'+
                                           '</svg>');
        
        $(".curr_related_to_input").attr("placeholder","Search Account");
    }
    else{
        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_related']").val("related_opportunities");
        $(".what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-opportunity slds-icon--small">'+
                                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#opportunity"></use>'+
                                           '</svg>');
        
        $(".curr_related_to_input").attr("placeholder","Search Opportunity");
    }
    
    $(".curr_account_name_input").val(currAccNameFromEdit);
    $(".curr_related_to_input").val(currRelatedToFromEdit);
    
    
    initLookup1();
    initDatePickers();
    initMultiSelects();
    hideLoading();
};

var postReRenderSave = function(){
	var currAssignedTo = $.trim($(".currAssignedTo").text());
	var currWhoID = $.trim($(".currWhoIdName").text());
	var currWhatID = $.trim($(".currWhatIdName").text());
	
	setCurrentLookupValue(currWhoID, $("#lookup"));
	setCurrentLookupValue(currAssignedTo, $("#lookup1"));
	setCurrentLookupValue(currWhatID, $("#lookup2"));
	
	initLookup3();
	initLookup4();
	//initCARModalWindow();
	//initMMRModalWindow();
    //initFollowUpModalWindow();
    hideLoading();
    
    /*$("#dialog_box_speaker_request .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_speaker_request .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");*/

};
var postReRenderMFSPortfolioAdd = function(){
	initLookup3();
    $(".mfs_portfolio").val("");
    $("input[type='hidden'][data-lookup-name='selected_lookup3']").val("");
    hideLoading();
};
var postReRenderMFSCompPortfolioAdd = function(){
	initLookup4();
    $(".mfs_comp_portfolio").val("");
    $("input[type='hidden'][data-lookup-name='selected_lookup4']").val("");
    
    hideLoading();
};

var postReRenderMMRPopUpWindow = function(){
	//initMMRModalWindow();
    MMRMaterialTypeChange($(".mmr_material_type"));
    initDatePickers();
    initMultiSelects();
    
    if($.trim($(".mmr_create_status").text()) == ""){
        $(".mmr_fld_org_name").val($.trim($(".curr_organization_name_create").text()));    
    }
    else{
        $(".mmr_fld_org_name").val($.trim($(".curr_organization_name").text()));    
    }
    
    $("#dialog_box_meeting_material .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_meeting_material .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};


var postReRenderSRPopUpWindow = function(){
    //MMRMaterialTypeChange($(".mmr_material_type"));
    //initDatePickers();
    //initMultiSelects();
    
    /*if($.trim($(".mmr_create_status").text()) == ""){
        $(".mmr_fld_org_name").val($.trim($(".curr_organization_name_create").text()));    
    }
    else{
        $(".mmr_fld_org_name").val($.trim($(".curr_organization_name").text()));    
    }*/
    
    $("#dialog_box_speaker_request .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_speaker_request .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var postReRenderCARPopUpWindow = function(){
    initLookupCompPortfolio();
    initLookupCompPortfolioNotify();
    initMultiSelects();
    enableDisableType($("[id*='request_report_check']")[0]);
    
    $("#dialog_box_competitive_ananlysis .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_competitive_ananlysis .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var postReRenderRES = function(){
    //var opOrgName = $.trim($(".op_org_name_text").text());
    //var opClientContact = $.trim($(".op_client_contact_text").text());
    
    initMultiSelects();
    initDatePickers();
    
    $('#op_closed_reason select').addClass('slds-select');
    //$(".op_org_name").val(opOrgName);
    //$(".op_client_contact").val(opClientContact);
    
    $("#money_in_motion .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#money_in_motion .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
};

var postReRenderCARProductAdd = function(){
	//initCompAnanlysisProdLookup();
};
var postReRenderCARCompProductAdd = function(){
	//initCompAnanlysisCompProdLookup();
};

var initDateTimePicker = function(){
    /*$('#datetimepicker').datetimepicker({
        format: 'dd/MM/yyyy hh:mm:ss',
        pick12HourFormat: true
    });*/
};

var setCurrentLookupValue = function(val, elem){
    elem.val(val);
};
var setCurrentDateTimeValue = function(val, elem){
    elem.val(val);
};

function CheckWhoIdObject(){
    
}

function populateLookup(result){
    if(result){                        
        $( result ).each(function() {                        
            $('#ui_results').append('<li class="slds-lookup__item">' + 
                                    '<a id="' + this.Id + '" href="javascript:void(0)" role="option">' + 
                                    '<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">' + 
                                    '<use xlink:href="/resource/SLDS202/assets/icons/utility-sprite/svg/symbols.svg#user"></use>' + 
                                    '</svg>' + this.FirstName+ ' ' + this.LastName +'</a>' + 
                                    '</li>');
        });
        
        $('ul.slds-lookup__list a').click(function(e) { 
            $('#lookup').val($(this)[0].innerText);
            $('#lookup').attr('aria-activedescendant',$(this)[0].id);
            $('#lookup').attr('aria-expanded','false');
            $('#results').css("display","none");
            $("input[type='hidden'][data-lookup-name='selected_lookup']").val($(this)[0].id);
            
            e.stopPropagation();
        }); 
    }
}

function populateLookup1(result){
    if(result){                        
        $( result ).each(function() {                        
            $('#ui_results1').append('<li class="slds-lookup__item1">' + 
                                     '<a id="' + this.Id + '" href="javascript:void(0)" role="option">' + 
                                     '<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">' + 
                                     '<use xlink:href="/resource/SLDS202/assets/icons/utility-sprite/svg/symbols.svg#user"></use>' + 
                                     '</svg>' + this.Name+
                                     '</a>' + 
                                     '</li>');
        });
        
        $('ul.slds-lookup__list1 a').click(function(e) { 
            $('#lookup1').val($(this)[0].innerText);
            $('#lookup1').attr('aria-activedescendant',$(this)[0].id);
            $('#lookup1').attr('aria-expanded','false');
            $('#results1').css("display","none");
            $("input[type='hidden'][data-lookup-name='selected_lookup1']").val($(this)[0].id);
            
            e.stopPropagation();
            
        }); 
    }
}

function populateLookup2(result){
    if(result){                        
        $( result ).each(function() {                        
            $('#ui_results2').append('<li class="slds-lookup__item2">' + 
                                     '<a id="' + this.Id + '" href="javascript:void(0)" role="option">' + 
                                     '<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">' + 
                                     '<use xlink:href="/resource/SLDS202/assets/icons/utility-sprite/svg/symbols.svg#user"></use>' + 
                                     '</svg>' + this.Name + '</a>' + 
                                     '</li>');
        });
        
        $('ul.slds-lookup__list2 a').click(function(e) { 
            $('#lookup2').val($(this)[0].innerText);
            $('#lookup2').attr('aria-activedescendant',$(this)[0].id);
            $('#lookup2').attr('aria-expanded','false');
            $('#results2').css("display","none");
            $("input[type='hidden'][data-lookup-name='selected_lookup2']").val($(this)[0].id);
            
            e.stopPropagation();
        }); 
    } 
}

function populateCompAnalysisProdLookup(result){
    if(result){                        
        $( result ).each(function() {                        
            $('#carui_results').append('<li class="car_slds-lookup__item">' + 
                                       '<a id="' + this.Id + '" href="javascript:void(0)" role="option">' + 
                                       '<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">' + 
                                       '<use xlink:href="/resource/SLDS202/assets/icons/utility-sprite/svg/symbols.svg#user"></use>' + 
                                       '</svg>' + this.Name+'</a>' + 
                                       '</li>');
        });
        
        $('ul.car_slds-lookup__list a').click(function(e) { 
            $('#carlookup').val($(this)[0].innerText);
            $('#carlookup').attr('aria-activedescendant',$(this)[0].id);
            $('#carlookup').attr('aria-expanded','false');
            $('#carresults').css("display","none");
            $("input[type='hidden'][data-lookup-name='carselected_lookup']").val($(this)[0].id);
            
            e.stopPropagation();
        }); 
    }
}

function populateCompAnalysisCompProdLookup(result){
    if(result){                        
        $( result ).each(function() {                        
            $('#carui_results1').append('<li class="car_slds-lookup__item1">' + 
                                        '<a id="' + this.Id + '" href="javascript:void(0)" role="option">' + 
                                        '<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">' + 
                                        '<use xlink:href="/resource/SLDS202/assets/icons/utility-sprite/svg/symbols.svg#user"></use>' + 
                                        '</svg>' + this.Name+'</a>' + 
                                        '</li>');
        });
        
        $('ul.car_slds-lookup__list1 a').click(function(e) { 
            $('#carlookup1').val($(this)[0].innerText);
            $('#carlookup1').attr('aria-activedescendant',$(this)[0].id);
            $('#carlookup1').attr('aria-expanded','false');
            $('#carresults1').css("display","none");
            $("input[type='hidden'][data-lookup-name='carselected_lookup1']").val($(this)[0].id);
            //changeHostForInvitees();
            e.stopPropagation();
        }); 
    }
}

function populateCARContactLookup(result){
    if(result){
        $( result ).each(function() {                        
            $('#car_contact_ui_results').append('<li class="car_contact_slds-lookup__item">' + 
                                                '<a id="' + this.Id + '" href="javascript:void(0)" role="option">' + 
                                                '<svg aria-hidden="true" class="slds-icon slds-icon-standard-contact slds-icon--small">' + 
                                                '<use xlink:href="/resource/SLDS202/assets/icons/utility-sprite/svg/symbols.svg#user"></use>' + 
                                                '</svg>' + this.FirstName+ ' ' + this.LastName + '</a>' + 
                                                '</li>');
        });
        
        $('ul.car_contact_slds-lookup__list a').click(function(e) { 
            $('#car_contact_lookup').val($(this)[0].innerText);
            $('#car_contact_lookup').attr('aria-activedescendant',$(this)[0].id);
            $('#car_contact_lookup').attr('aria-expanded','false');
            $('#car_contact_results').css("display","none");
            $("input[type='hidden'][data-lookup-name='car_contact_selected_lookup']").val($(this)[0].id);
            //alert('Selected Contact: ' + $(this)[0].innerText + '  ' + $(this)[0].id);
            
            e.stopPropagation();
        }); 
    }
}

var prevDefault = function(e){
    e.preventDefault();
};

var openPolyLookupTypeSelector = function(elem, e, lookupType){
    e.stopPropagation();
    
    if(!$(elem).parents(".slds-lookup--polymorphic").find(".slds-lookup__search-input").is(":disabled")){
        
        $(".slds-lookup__menu").hide();
        $(elem).next(".slds-dropdown").slideToggle("fast");
        $(elem).next(".slds-dropdown").find(".slds-dropdown__item").off("click").on("click", function(){
            
            $(elem).parents(".slds-lookup--polymorphic").find(".slds-lookup__search-input").val("");
            
            if(lookupType == "Account"){
                $("input[type='hidden'][data-lookup-name='selected_lookup']").val("");
                
                if($.trim($(this).text()).toLowerCase() == "contact"){
                    $("input[type='hidden'][data-lookup-name='sel_whoId_obj_account']").val("account_contacts");
                    
                    $(".curr_related_to_input").removeAttr("disabled");
                    $(".curr_related_to_input").parents(".slds-form-element__control").css("background", "#FFF");
                    
                    $(elem).parents(".slds-lookup--polymorphic").find(".slds-lookup__search-input").attr("placeholder","Search Contact");
                    $(elem).prev("span.slds-icon__container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-opportunity slds-icon--small"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#contact"></use></svg>');
                }
                else{
                    $("input[type='hidden'][data-lookup-name='sel_whoId_obj_account']").val("account_leads");
                    
                    $(".curr_related_to_input").attr("disabled", "disabled").val("");
                    $(".curr_related_to_input").parents(".slds-form-element__control").css("background", "#d8dde6");
                    
                    $("input[type='hidden'][data-lookup-name='selected_lookup2']").val("");
                    
                    $(elem).parents(".slds-lookup--polymorphic").find(".slds-lookup__search-input").attr("placeholder","Search Lead");
                    $(elem).prev("span.slds-icon__container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-lead slds-icon--small"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#lead"></use></svg>');                
                }
            }
            else if(lookupType == "Related To"){
                $("input[type='hidden'][data-lookup-name='selected_lookup2']").val("");
                
                if($.trim($(this).text()).toLowerCase() == "accounts"){
                    $("input[type='hidden'][data-lookup-name='sel_whoId_obj_related']").val("related_accounts");
                    
                    $(elem).parents(".slds-lookup--polymorphic").find(".slds-lookup__search-input").attr("placeholder","Search Account");
                    $(elem).prev("span.slds-icon__container").html('<svg aria-hidden="true" class="slds-icon slds-icon--small slds-icon-standard-account slds-m-right--small"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#account"></use></svg>');
                }
                else{
                    $("input[type='hidden'][data-lookup-name='sel_whoId_obj_related']").val("related_opportunities");
                    
                    $(elem).parents(".slds-lookup--polymorphic").find(".slds-lookup__search-input").attr("placeholder","Search Opportunity");
                    $(elem).prev("span.slds-icon__container").html('<svg aria-hidden="true" class="slds-icon slds-icon--small slds-icon-standard-opportunity slds-m-right--small"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#opportunity"></use></svg>');
                }
            }
                else if(lookupType == "Account_Followup"){
                    $("input[type='hidden'][data-lookup-name='follow_up_related_to']").val("");
                    
                    if($.trim($(this).text()).toLowerCase() == "contact"){
                        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_account']").val("account_contacts");
                        
                        $(".curr_related_to_input_followup").removeAttr("disabled");
                        $(".curr_related_to_input_followup").parents(".slds-form-element__control").css("background", "#FFF");
                        
                        $(elem).parents(".slds-lookup--polymorphic").find(".slds-lookup__search-input").attr("placeholder","Search Contact");
                        $(elem).prev("span.slds-icon__container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-opportunity slds-icon--small"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#contact"></use></svg>');
                    }
                    else{
                        $("input[type='hidden'][data-lookup-name='sel_whoId_obj_account']").val("account_leads");
                        
                        $(".curr_related_to_input_followup").attr("disabled", "disabled").val("");
                        $(".curr_related_to_input_followup").parents(".slds-form-element__control").css("background", "#d8dde6");
                        
                        $(elem).parents(".slds-lookup--polymorphic").find(".slds-lookup__search-input").attr("placeholder","Search Lead");
                        $(elem).prev("span.slds-icon__container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-lead slds-icon--small"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#lead"></use></svg>');                
                    }
                }
                    else if(lookupType == "Related_To_FollowUp"){
                        $("input[type='hidden'][data-lookup-name='follow_up_name']").val("");
                        
                        if($.trim($(this).text()).toLowerCase() == "accounts"){
                            $("input[type='hidden'][data-lookup-name='sel_whoId_obj_related']").val("related_accounts");
                            
                            $(elem).parents(".slds-lookup--polymorphic").find(".slds-lookup__search-input").attr("placeholder","Search Account");
                            $(elem).prev("span.slds-icon__container").html('<svg aria-hidden="true" class="slds-icon slds-icon--small slds-icon-standard-account slds-m-right--small"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#account"></use></svg>');
                        }
                        else{
                            $("input[type='hidden'][data-lookup-name='sel_whoId_obj_related']").val("related_opportunities");
                            
                            $(elem).parents(".slds-lookup--polymorphic").find(".slds-lookup__search-input").attr("placeholder","Search Opportunity");
                            $(elem).prev("span.slds-icon__container").html('<svg aria-hidden="true" class="slds-icon slds-icon--small slds-icon-standard-opportunity slds-m-right--small"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/SLDS202/assets/icons/standard-sprite/svg/symbols.svg#opportunity"></use></svg>');
                        }
                    }
        });   
    }

};

var setSelectedAccountID = function(elem, lookupType){
    
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
    var allRequiredElements = $(btn).parents(".slds-modal").find(".slds-form-element.slds-is-required");
    var allGood = true;
    
    for(var i=0, iLen = allRequiredElements.length; i < iLen; i++){
        if($(allRequiredElements[i]).find("input.slds-input:not([disabled])").val() == "" || $(allRequiredElements[i]).find("select.slds-select:not([disabled])").val() == ""){
            $(allRequiredElements[i]).find("input.slds-input").addClass("slds-dirty-input");
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
    return allGood;
};

var openModalAttachments = function(modal, e){
    e.preventDefault();
    
    $(modal+" .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
    
    $(modal).find(".slds-modal").removeClass("slds-fade-in-close").addClass("slds-fade-in-open");
    $(modal).find(".slds-backdrop").removeClass("slds-backdrop--close").addClass("slds-backdrop--open");
};

var openModal = function(modal, e){
    console.log('inside modal e='+e);
    e.preventDefault();
    console.log('1');
    /*if(Math.abs(window.orientation) === 90) {
        $(".slds-inner-scroll--test").height(700);
    } else {
        $(".slds-inner-scroll--test").height(950);
    }*/
    
    $(modal+" .slds-modal__content.slds-modal--loading").removeClass("slds-hide");
    $(modal+" .slds-modal__content:not(.slds-modal--loading)").addClass("slds-hide");
    console.log('2');
    $(modal).find(".slds-modal").removeClass("slds-fade-in-close").addClass("slds-fade-in-open");
    $(modal).find(".slds-backdrop").removeClass("slds-backdrop--close").addClass("slds-backdrop--open");
    console.log('3');
};

//var openSpeakerModal = function(modal, e){}
var openSpeakerModal = function(){
    
    $("#dialog_box_speaker_request").find(".slds-modal").removeClass("slds-fade-in-close").addClass("slds-fade-in-open");
    $("#dialog_box_speaker_request").find(".slds-backdrop").removeClass("slds-backdrop--close").addClass("slds-backdrop--open");
    $("#dialog_box_speaker_request .slds-modal__content.slds-modal--loading").addClass("slds-hide");
    $("#dialog_box_speaker_request .slds-modal__content:not(.slds-modal--loading)").removeClass("slds-hide");
    
	//Populate Requested For field
    if(allUsers !== ""){
        var allUsersObj = JSON.parse(allUsers);
        var currUserIDFromEdit = $("input[type='hidden'][data-lookup-name='selected_requestor']").val();
        
        __renderLookupField($(".er_requested_for"), allUsersObj["Users"], currUserNameFromEdit, currUserIDFromEdit);
    }
    Lookup.initLookup();
   
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
    
    $(".slds-inner-scroll--test").css("height", "auto");
    
    $(elem).parents(".slds-modal").removeClass("slds-fade-in-open").addClass("slds-fade-in-close");
    $(elem).parents(".slds-modal").next(".slds-backdrop").removeClass("slds-backdrop--open").addClass("slds-backdrop--close");
};

var validatePageForm = function(btn, e, formSection){
    e.stopPropagation();
    var allRequiredElements = "";
    var allGood = true;
    
    if(formSection){
        allRequiredElements = $(btn).parents(formSection).find(".slds-form-element.slds-is-required");
    }
    else{
        allRequiredElements = $(btn).parents(".slds").find(".slds-form-element.slds-is-required[data-exclude-page-validation != 'true']");
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

var showLoading = function(){
    $(".slds").append('<div class="slds-loader--container"><div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog"><div class="slds-modal__container"><div class="slds-text-align--center loader-container"><img src="/resource/SLDS202/assets/images/spinners/slds_spinner_brand.gif" width="50" /></div></div></div><div class="slds-backdrop slds-backdrop--open"></div></div>');
};

var hideLoading = function(){
    $(".slds").find(".slds-loader--container").remove();
};

var MMRMaterialTypeChange = function(elem){
    var currVal = $(elem).val();
    
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
    
    switch(currVal){
        case "Client":
            $(".mmr_fld_data_time_period").removeAttr("disabled");
            $(".mmr_fld_sector_scheme").removeAttr("disabled");
            $(".mmr_fld_bench_mark").removeAttr("disabled");
            if($(".mmr_fld_bench_mark").val()=='')
            	$(".mmr_fld_bench_mark").val("Default - Please update if custom");
            $(".mmr_fld_use_crp").removeAttr("disabled");
            $(".mmr_fld_trinket").removeAttr("disabled");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_syntax").removeAttr("disabled");
            break;
            
		case "Consultant":
            $(".mmr_fld_data_time_period").removeAttr("disabled");
            $(".mmr_fld_sector_scheme").removeAttr("disabled");
            $(".mmr_fld_bench_mark").removeAttr("disabled");
            if($(".mmr_fld_bench_mark").val()=='')
            	$(".mmr_fld_bench_mark").val("Default - Please update if custom");
            $(".mmr_fld_use_crp").removeAttr("disabled");
            $(".mmr_fld_trinket").removeAttr("disabled");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_syntax").removeAttr("disabled");
            break;
            
        case "Generic/Sales":
            $(".mmr_fld_sector_scheme").removeAttr("disabled");
            $(".mmr_fld_bench_mark").removeAttr("disabled");
            if($(".mmr_fld_bench_mark").val()=='')
            $(".mmr_fld_bench_mark").val("Default - Please update if custom");
            $(".mmr_fld_trinket").removeAttr("disabled");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            
            break;
		
        case "CRP Only":
            $(".mmr_fld_trinket").removeAttr("disabled");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_bench_mark").val("");
            break;
            
        case "PRP Only":
            $(".mmr_fld_trinket").removeAttr("disabled");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_bench_mark").val("");
            break;
            
        case "Introductory Transition Call":
            //$(".mmr_fld_agreement_finalized_date").removeAttr("disabled");
            //$(".mmr_fld_account_estimate_funding_date").removeAttr("disabled");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_bench_mark").val("");
            break;
            
        case "Webcast":
            $(".mmr_fld_trinket").removeAttr("disabled");
            $(".mmr_fld_gov_entity").removeAttr("disabled");
            $(".mmr_fld_bench_mark").val("");
            break;
            
        default:
            
            break;
    }
};

var MMRDataTimePeriodChange = function(elem){
    var currVal = $(elem).val();
    
    if(currVal == "Other"){
        $(".mmr_fld_data_as_of_end_date").attr("disabled", "disabled");
        //$(".mmr_fld_desired_time_range").removeAttr("disabled");
    }
    else{
        $(".mmr_fld_data_as_of_end_date").removeAttr("disabled");
        //$(".mmr_fld_desired_time_range").attr("disabled", "disabled");
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
    
    console.log(currSearchElem.prev("input[type='hidden']").val());
    
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
        
        //showLoading();
        //populateActivitySubType();
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
        
        //showLoading();
        //populateActivitySubType();
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

var setPerformancePeriodValues = function(){
    setTimeout(function(){
        var selectedTranslationLangs = $(".mfs-performance-period").multiSelect("getSelectedItems");
        
        var selectedLangsArr = [];
        for(var i=0, iLen = selectedTranslationLangs.length; i < iLen; i++){
            selectedLangsArr.push(selectedTranslationLangs[i]["label"]);
        }
        $("input[id*='mmr_fld_performance_period__hidden']").val(selectedLangsArr.join(";"));
        //console.log($("input[id*='mmr_fld_event_type__hidden']").val);
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
        console.log($("input[id*='mmr_fld_event_type__hidden']").val()) 
        //addLanguageFields();
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
        
        console.log($("[id*='mfs_fld_selected_invitees_hidden']").val());
        
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

var setContainerHeight = function(){
  	var pageH = $(window).height() - 74;
    
    $(".slds-inner-container").height(pageH);
};
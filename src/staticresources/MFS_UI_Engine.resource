/**
 * @author bthomas044
 * @description MFS UI Interactions
 * @support balu.j.thomas@pwc.com
 * @date 4 Nov, 2016
 * @company PricewaterhouseCoopers LLP
 *  
 */

var MFSApp = function($){
	
    "use strict";
    
	/**
	 * Private Methods
	 */
    
    var __isTablet = (window.screen.width == 768 && window.screen.height == 1024 ) ? true : false;
    if(!__isTablet){
        __isTablet = (window.screen.width == 1024 && window.screen.height == 768 ) ? true : false;
    }
    var __isMobile = (window.screen.width >= 320 && window.screen.width < 768 ) ? true : false;
    
    //$(".console").append(__isTablet+":"+__isMobile);
    
	var __eventListeners = function(){
		$("body").on("click", function(){
			$(".mfs-more-actions").hide();
            if($(".mfs-top-arrow--small").is(":visible")){
             	$(".mfs-top-buttons-container").hide();   
            }
		});
		
		$(".mfs_portfolio_selector").off("click").on("click", function(e){
            openModal('.mfs_portfolio_selector_modal', e);
		});
        
        $(".mfs_comp_portfolio_selector_CA").off("click").on("click", function(e){
			$("#dialog_box_competitive_ananlysis .slds-modal").removeClass("slds-fade-in-open");
            openModal('.mfs_competitor_selector_modal_CA', e);
		});
		
		$(".mfs_comp_portfolio_selector").off("click").on("click", function(e){
            openModal('.mfs_competitor_selector_modal', e);
        });
		
        $(".mfs_open_invitees_modal").off("click").on("click", function(e){
            openModal('.dialog_box_select_invitee', e);
        });
        
        $(".mfs_additional_meeting_details").off("click").on("click", function(e){
            openModal('#additional_meeting_details_modal', e);
        });
        
        $(".mfs-top-arrow--small button.slds-button").off("click").on("click", function(e){
            e.preventDefault();
            e.stopPropagation();
            
            $(this).parent().next(".mfs-top-buttons-container").toggle();
        });
        
		$(".mfs-modal-cancel, .mfs-modal-close").off("click").on("click", function(e){
			e.preventDefault();
			
			$(this).parents(".slds-modal").removeClass("slds-fade-in-open");
			$(this).parents(".slds-modal").next(".slds-backdrop").removeClass("slds-backdrop--open");
		});
        
        var allSelectedPorts = [];
        $(".all-portfolios > tbody > tr > td input[type='checkbox']").on("change", function(){
            if($(this).is(":checked")){
                allSelectedPorts.push($(this).data("prg-id"));
            }
            else{
                allSelectedPorts.splice(allSelectedPorts.indexOf($(this).data("prg-id")), 1);
            }
            
            $("[id*='sProd']").val(allSelectedPorts);
            $("[id*='cProd']").val(allSelectedPorts.length);
        });
        
        $(".mfs_portfolios_search_btn").off("click").on("click", function(){
            allSelectedPorts = [];
            $("[id*='sProd']").val("");
            $("[id*='cProd']").val("");
        });
        
        $(".mfs_comp_portfolios_search_btn").off("click").on("click", function(){
            allSelectedPorts = [];
            $("[id*='scProdc']").val("");
            $("[id*='ccProdc']").val("");
        });
        
        var allSelectedPortsSearch = [];
        $(".all-portfolios-in-search > tbody > tr > td input[type='checkbox']").on("change", function(){
            var currSelectedPortSearch = {};
            if($(this).is(":checked")){
                currSelectedPortSearch["name"] = $(this).data("prg-name");
                currSelectedPortSearch["id"] = $(this).data("prg-id");
                
                allSelectedPortsSearch.push(currSelectedPortSearch);
            }
            else{
                for(var i=0, iLen = allSelectedPortsSearch.length; i < iLen; i++){
                    if(allSelectedPortsSearch[i]["id"] == $(this).data("prg-id")){
                        delete allSelectedPortsSearch[i];
                    }
                }
            }
            
            $("[id*='sProd']").val(allSelectedPortsSearch);
            $("[id*='cProd']").val(allSelectedPortsSearch.length);
        });
        
        /* Starts : Related Activities Search Functionalities */
        
        $(".mfs-add-products-to-search").on("click", function(){
            var pillHTML = "";
            var hiddenField = $(".products-pills-search").prev(".slds-lookup").find(".slds-lookup__search-input").prev();
            var currHiddenVals = (hiddenField.val() !== "") ? hiddenField.val().split(",") : [];
            var newHiddenVals = "";
            var listText = "";
            
            for(var i=0, iLen = allSelectedPortsSearch.length; i < iLen; i++){
                var sfdcID = allSelectedPortsSearch[i]["id"];
                var currSelectedText = allSelectedPortsSearch[i]["name"];
                if(currHiddenVals.indexOf(sfdcID) === -1 || currHiddenVals.length === 0){
               		pillHTML += 	'<span class="slds-pill">'+
                                        '<span class="slds-icon_container slds-icon-standard-product slds-pill__icon_container">'+
                                            '<svg class="slds-icon" aria-hidden="true">'+
                                                '<use xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#product"></use>'+
                                            '</svg>'+
                                        '</span>'+
                                        '<a href="javascript:void(0);" class="slds-pill__label" title="" data-pill-id="'+sfdcID+'">'+currSelectedText+'</a>'+
                                        '<button class="slds-button slds-button--icon slds-pill__remove" title="Remove">'+
                                            '<svg class="slds-button__icon" aria-hidden="true">'+
                                                '<use xlink:href="/resource/MFS_UI_Assets/assets/icons/utility-sprite/svg/symbols.svg#close"></use>'+
                                            '</svg>'+
                                        '</button>'+
                                    '</span>';
                
					currHiddenVals.push(sfdcID);
                }
            }
            
            if(pillHTML !== ""){
                newHiddenVals = currHiddenVals.join(",");
                hiddenField.val(newHiddenVals);
                
                if(currHiddenVals.length - 1 > 0){
                    listText = "<strong>"+currSelectedText +"</strong> and "+ (currHiddenVals.length - 1)+ " more";
                }
                else{
                    listText = "<strong>"+currSelectedText +"</strong>";
                }
                
                
                $(".products-pills-search").removeClass("slds-hide").prepend(pillHTML);
                $(".products-list-search").html(listText);
                
                //showLoading();
                //search();
            }
            
            $(".products-pills-search").find(".slds-pill button.slds-pill__remove").off("click").on("click", function(e){
                e.preventDefault();
                e.stopPropagation();
                
                var pillID = $(this).prev("a").data("pill-id");
                var newHiddenValsAfterDel = hiddenField.val().split(",");
                var pillIndex = newHiddenValsAfterDel.indexOf(pillID);
                var newHiddenValsStrAfterDel = "";
                var listText = "";
                var firstPillTextAfterDel = "";
                
                //console.log(pillID);
                //console.log("Before Del", newHiddenValsAfterDel, pillIndex);
                newHiddenValsAfterDel.splice(pillIndex, 1);
                //console.log("After Del", newHiddenValsAfterDel);
                
                newHiddenValsStrAfterDel = newHiddenValsAfterDel.join(",");
                hiddenField.val(newHiddenValsStrAfterDel);
                
                $(this).parent().remove();
                
                if(newHiddenValsAfterDel.length === 0){
                    $(".products-pills-search").addClass("slds-hide");
                }
                
                firstPillTextAfterDel = $.trim($(".products-pills-search").find(".slds-pill:first-child").text());
                
                if(newHiddenValsAfterDel.length - 1 > 0){
                	listText = "<strong>"+firstPillTextAfterDel +"</strong> and "+ (newHiddenValsAfterDel.length - 1)+ " more";
                }
                else{
                    listText = "<strong>"+firstPillTextAfterDel +"</strong>";
                }
                
                
                $(".products-list-search").html(listText);
                
                //showLoading();
                //search();
            });
        });
        
        $(".mfs-add-attendees-to-search").on("click", function(){
            var pillHTML = "";
            var hiddenField = $(".attendees-pills-search").prev(".slds-lookup").find(".slds-lookup__search-input").prev();
            var currHiddenVals = (hiddenField.val() !== "") ? hiddenField.val().split(",") : [];
            var newHiddenVals = "";
            var listText = "";
            //console.log(currHiddenVals);
            for(var i=0, iLen = selectedAttendeesRelatedActs.length; i < iLen; i++){
                var sfdcID = selectedAttendeesRelatedActs[i]["id"];
                var currSelectedText = selectedAttendeesRelatedActs[i]["name"];
                
                if(currHiddenVals.indexOf(sfdcID) === -1 || currHiddenVals.length === 0){
                
                    var isContact = sfdcID.lastIndexOf("003", 0) === 0 ? true : false;
                    var iconPath = isContact ? "/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#contact" : "/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#user";
                    var iconClass = isContact ? "slds-icon-standard-contact" : "slds-icon-standard-user";
                        
                    pillHTML += 	'<span class="slds-pill">'+
                                        '<span class="slds-icon_container '+iconClass+' slds-pill__icon_container">'+
                                                '<svg class="slds-icon" aria-hidden="true">'+
                                                    '<use xlink:href="'+iconPath+'"></use>'+
                                                '</svg>'+
                                        '</span>'+
                                        '<a href="javascript:void(0);" class="slds-pill__label" title="" data-pill-id="'+sfdcID+'">'+currSelectedText+'</a>'+
                                        '<button class="slds-button slds-button--icon slds-pill__remove" title="Remove">'+
                                            '<svg class="slds-button__icon" aria-hidden="true">'+
                                                '<use xlink:href="/resource/MFS_UI_Assets/assets/icons/utility-sprite/svg/symbols.svg#close"></use>'+
                                            '</svg>'+
                                        '</button>'+
                                    '</span>';
                    
					currHiddenVals.push(sfdcID);
                }
            }
            
            if(pillHTML !== ""){
                newHiddenVals = currHiddenVals.join(",");
                hiddenField.val(newHiddenVals);
                
                if(currHiddenVals.length - 1 > 0){
                    listText = "<strong>"+currSelectedText +"</strong> and "+ (currHiddenVals.length - 1)+ " more";
                }
                else{
                    listText = "<strong>"+currSelectedText +"</strong>";
                }
                
                
                $(".attendees-pills-search").removeClass("slds-hide").prepend(pillHTML);
                $(".attendees-list-search").html(listText);
                
                //showLoading();
                //search();   
            }
            
            $(".attendees-pills-search").find(".slds-pill button.slds-pill__remove").off("click").on("click", function(e){
                e.preventDefault();
                e.stopPropagation();
                
                var pillID = $(this).prev("a").data("pill-id");
                var newHiddenValsAfterDel = hiddenField.val().split(",");
                var pillIndex = newHiddenValsAfterDel.indexOf(pillID);
                var newHiddenValsStrAfterDel = "";
                var listText = "";
                var firstPillTextAfterDel = "";
                
                //console.log(pillID);
                //console.log("Before Del", newHiddenValsAfterDel, pillIndex);
                newHiddenValsAfterDel.splice(pillIndex, 1);
                //console.log("After Del", newHiddenValsAfterDel);
                
                newHiddenValsStrAfterDel = newHiddenValsAfterDel.join(",");
                hiddenField.val(newHiddenValsStrAfterDel);
                
                $(this).parent().remove();
                
                if(newHiddenValsAfterDel.length === 0){
                    $(".attendees-pills-search").addClass("slds-hide");
                }
                
                firstPillTextAfterDel = $.trim($(".attendees-pills-search").find(".slds-pill:first-child").text());
                
                if(newHiddenValsAfterDel.length - 1 > 0){
                	listText = "<strong>"+firstPillTextAfterDel +"</strong> and "+ (newHiddenValsAfterDel.length - 1)+ " more";
                }
                else{
                    listText = "<strong>"+firstPillTextAfterDel +"</strong>";
                }
                
                
                $(".attendees-list-search").html(listText);
                
                //showLoading();
                //search();
            });
        });
        
        $(".mfs-related-search-timeframe").off("change").on("change", function(){
        	//showLoading();
            //search();
        });
        
        $(".mfs-related-search-method").off("change").on("change", function(){
            if($(this).val() !== ""){
            	var sfdcID = $(this).val();
                var currSelectedText = $(this).val();
                var hiddenField = $(this).prev();
                var currHiddenVals = (hiddenField.val() !== "") ? hiddenField.val().split(",") : [];
                var newHiddenVals = "";
                var listText = "";
                var pillHTML = '<span class="slds-pill">'+
                                    '<span class="slds-icon_container slds-icon-standard-process slds-pill__icon_container">'+
                                        '<svg class="slds-icon" aria-hidden="true">'+
                                            '<use xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#process"></use>'+
                                        '</svg>'+
                                    '</span>'+
                                    '<a href="javascript:void(0);" class="slds-pill__label" title="" data-pill-id="'+sfdcID+'">'+currSelectedText+'</a>'+
                                    '<button class="slds-button slds-button--icon slds-pill__remove" title="Remove">'+
                                        '<svg class="slds-button__icon" aria-hidden="true">'+
                                            '<use xlink:href="/resource/MFS_UI_Assets/assets/icons/utility-sprite/svg/symbols.svg#close"></use>'+
                                        '</svg>'+
                                    '</button>'+
                                '</span>';
                
                if(currHiddenVals.indexOf("'"+sfdcID+"'") === -1 || currHiddenVals.length === 0){
                    currHiddenVals.push("'"+sfdcID+"'");
                    newHiddenVals = currHiddenVals.join(",");
                    hiddenField.val(newHiddenVals);
        
                    if(currHiddenVals.length - 1 > 0){
                        listText = "<strong>"+currSelectedText +"</strong> and "+ (currHiddenVals.length - 1)+ " more";
                    }
                    else{
                        listText = "<strong>"+currSelectedText +"</strong>";
                    }
                    
                    $(this).parent().next(".methods-pills-search").prepend(pillHTML).removeClass("slds-hide");
                    $(this).parent().next(".methods-pills-search").next(".methods-list-search").html(listText).addClass("slds-hide");
                    
                    $(this).val("");
                    
                    //showLoading();
                    //search();
                }
                else{
                    $(this).val("");
                }
                
                $(".methods-pills-search").find(".slds-pill button.slds-pill__remove").off("click").on("click", function(e){
                    e.preventDefault();
                    e.stopPropagation();
                    
                    var pillID = $(this).prev("a").data("pill-id");
                    var newHiddenValsAfterDel = hiddenField.val().split(",");
                    var pillIndex = newHiddenValsAfterDel.indexOf("'"+pillID+"'");
                    var newHiddenValsStrAfterDel = "";
                    var listText = "";
                    var firstPillTextAfterDel = "";
                    
                    //console.log(pillID);
                    //console.log("Before Del", newHiddenValsAfterDel, pillIndex);
                    newHiddenValsAfterDel.splice(pillIndex, 1);
                    //console.log("After Del", newHiddenValsAfterDel);
                    
                    newHiddenValsStrAfterDel = newHiddenValsAfterDel.join(",");
                    hiddenField.val(newHiddenValsStrAfterDel);
                    
                    $(this).parent().remove();
                    
                    if(newHiddenValsAfterDel.length === 0){
                        $(".methods-pills-search").addClass("slds-hide");
                    }
                    
                    firstPillTextAfterDel = $.trim($(".methods-pills-search").find(".slds-pill:first-child").text());
                    
                    if(newHiddenValsAfterDel.length - 1 > 0){
                        listText = "<strong>"+firstPillTextAfterDel +"</strong> and "+ (newHiddenValsAfterDel.length - 1)+ " more";
                    }
                    else{
                        listText = "<strong>"+firstPillTextAfterDel +"</strong>";
                    }
                    
                    
                    $(".methods-list-search").html(listText);
                    
                    //showLoading();
                    //search();
                });
            }
        });
        
        $(".mfs-related-search-reset").off("click").on("click", function(e){
            e.preventDefault();
            $(".mfs-related-search-timeframe").val("1 Year");
            
            $(".mfs-related-search-method").val("");
            $(".mfs-related-search-method").prev().val("");
            $(".mfs-related-search-method").parent().next(".methods-pills-search").empty().addClass("slds-hide");
            $(".mfs-related-search-method").parent().next(".methods-pills-search").next(".methods-list-search").empty().addClass("slds-hide");
            
            $(".slds-lookup--polymorphic .slds-lookup__menu").addClass("slds-hide");
            $(".slds-lookup--polymorphic .slds-lookup__menu .slds-lookup__list").empty();
            $(".slds-lookup--polymorphic").next(".attendees-pills-search").empty().addClass("slds-hide");
            $(".slds-lookup--polymorphic").next(".attendees-pills-search").next(".attendees-list-search").empty().addClass("slds-hide");
            $(".slds-lookup--polymorphic .slds-button").data("query-default-url", "MFS_RelatedActivitiesController.queryContacts");
            $(".slds-lookup--polymorphic .what-handle-icon-container").html('<svg aria-hidden="true" class="slds-icon slds-icon-standard-contact slds-icon--small"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#contact"></use></svg>');
            $(".slds-lookup--polymorphic .slds-lookup__search-input").val("");
            $(".slds-lookup--polymorphic .slds-lookup__search-input").prev().val("");
            
            $(".mfs-rel-search-assigned-to").prev().val("");
            $(".mfs-rel-search-assigned-to").val("");
            
            $(".search-related-products").prev().val("");
            $(".search-related-products").val("");
            $(".search-related-products").parents(".slds-lookup").next(".products-pills-search").empty().addClass("slds-hide");
            $(".search-related-products").parents(".slds-lookup").next(".products-pills-search").next(".products-list-search").empty().addClass("slds-hide");
            
            $("[id*='mfs_fld_selected_invitees_hidden']").val("");
            
            showLoading();
            search();
        });
        
        $(".mfs_show_additional_notes_modal").off("click").on("click", function(e){
            e.stopPropagation();
            
            var modalHeading = $(this).data("modal-heading");
            var modalContent = __htmlDecode($(this).prev().html());
            
            $("#mfs_modal_header_txt").empty().html(modalHeading);
            $("#mfs_modal_content_txt").empty().html(modalContent);
            
            $(".mfs_additional_notes_full").find(".slds-modal").addClass("slds-fade-in-open");
            $(".mfs_additional_notes_full").find(".slds-backdrop").addClass("slds-backdrop--open");
        });
        
        /* Ends : Related Activities Search Functionalities */
        
        var allSelectedPorts = [];
        $(".all-comp-portfolios > tbody > tr > td input[type='checkbox']").on("change", function(){
            if($(this).is(":checked")){
                allSelectedPorts.push($(this).data("prg-id"));
            }
            else{
                allSelectedPorts.splice(allSelectedPorts.indexOf($(this).data("prg-id")), 1);
            }
            
            $("[id*='scProdc']").val(allSelectedPorts);
            $("[id*='ccProdc']").val(allSelectedPorts.length);
        });
        
        var allSelectedPortsCA = [];
        $(".all-comp-portfolios-ca > tbody > tr > td input[type='checkbox']").on("change", function(){
            if($(this).is(":checked")){
                allSelectedPorts.push($(this).data("prg-id"));
            }
            else{
                allSelectedPorts.splice(allSelectedPorts.indexOf($(this).data("prg-id")), 1);
            }
            
            $("[id*='scProdc_CA']").val(allSelectedPorts);
        });
        
        $(".mfs_hide_chatter").off("click").on("click", function(){
            var showChatterLabel = $(".show_chatter_label").text();
            var hideChatterLabel = $(".hide_chatter_label").text();
            
            if($(".mfs-chatter-feeds").is(":visible")){
                $(".mfs-chatter-feeds").hide();
                $(this).val(showChatterLabel);
            }
            else{
                $(".mfs-chatter-feeds").show();
                $(this).val(hideChatterLabel);
            }
        });
        
        $(".mfs-more-actions-handle").on("click", function(e){
            $(this).next(".mfs-more-actions").toggle();
			e.stopPropagation();
		});
        
        $(".add_enter_key_listener").on("keypress", function(e){
            if(e.keyCode === 13){
                e.stopPropagation();
                e.preventDefault();
                
                var callBack = $(this).data("enter-key-callback");
                var currElem = $(this);
                var res = ( new Function( 'return ' + callBack ) )();
                
                if(typeof(res) == "function"){
                    res(currElem);
                }
            }
        });
        
        if($(".exclude-page-close-warning").length === 0){
            $("input[type='text']:visible, select:visible, textarea:visible").off("change").on("change", function(){
                //console.log(isConsole);
                if(isConsole == "true"){
                    console.log("Page modified in console!");
                    sforce.console.setTabUnsavedChanges(true);
                }
                else{
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
                }
            });   
        }
        console.log("isConsole", isConsole);
        if(isConsole && isConsole == "true"){
            $("body").css("padding-bottom", "0");
            if(!__isTablet && !__isMobile){
                $(window).on("resize", function(){
                    //console.log($(window).height(), $(window).width());
                    __setConsoleResizeScroll();
                });   
            }
        }
	};
    
    var __setConsoleResizeScroll = function(){
        if($(".no-console-scroll").length == 0){
            if($(window).width() <= 1280 && $(window).width() >= 1105){
                //alert("1");
                //$(".mfs-main-container").css({"height": ($(window).height()) +"px", "overflow":"auto"});
                $(".MFS .slds-page-header").css({"position":"fixed"});
                $(".mfs-main-container").css({"height": "auto", "overflow":"auto", "padding-top":"70px"});
                
                if($('.mfs_fixed_table_head').length > 0 && !__isTablet && !__isMobile){
                    $('.mfs_fixed_table_head').floatThead("destroy");
                    
                    setTimeout(function(){
                        $('.mfs_fixed_table_head').removeAttr("style")
                        $('.mfs_fixed_table_head thead').html(fixedTableHeaderHTML);
                        
                        $('.mfs_fixed_table_head').floatThead({
                            position: "fixed",
                            top: 69
                        });
                    }, 500);
                }
            }
            else if($(window).width() <= 1104 && $(window).width() >= 1023){
                //alert("2 new");
                $(".MFS .slds-page-header").css({"position":"relative"});
                $(".mfs-main-container").css({"height": ($(window).height() - 80) +"px", "overflow":"auto", "padding-top":"0"});
                
                if($('.mfs_fixed_table_head').length > 0 && !__isTablet && !__isMobile){
                    $('.mfs_fixed_table_head').floatThead("destroy");
                    
                    setTimeout(function(){
                        $('.mfs_fixed_table_head').removeAttr("style")
                        $('.mfs_fixed_table_head thead').html(fixedTableHeaderHTML);
                        
                        $('.mfs_fixed_table_head').floatThead({
                            scrollContainer: function($table){
                                return $table.closest('.mfs-main-container');
                            }
                        });
                    }, 500);
                }
            }
			else if($(window).width() < 1024 && $(window).width() >= 10){
                //alert("2 old");
                $(".MFS .slds-page-header").css({"position":"relative"});
                $(".mfs-main-container").css({"height": ($(window).height() - 70) +"px", "overflow":"auto", "padding-top":"0"});
                
                if($('.mfs_fixed_table_head').length > 0 && !__isTablet && !__isMobile){
                    $('.mfs_fixed_table_head').floatThead("destroy");
                    
                    setTimeout(function(){
                        $('.mfs_fixed_table_head').removeAttr("style")
                        $('.mfs_fixed_table_head thead').html(fixedTableHeaderHTML);
                        
                        $('.mfs_fixed_table_head').floatThead({
                            scrollContainer: function($table){
                                return $table.closest('.mfs-main-container');
                            }
                        });
                    }, 500);
                }
			}
			else if($(window).width() > 1280){
                //alert("3");
                $(".MFS .slds-page-header").css({"position":"fixed"});
                $(".mfs-main-container").css({"height": "auto", "overflow":"auto", "padding-top":"70px"});
                
                if($('.mfs_fixed_table_head').length > 0 && !__isTablet && !__isMobile){
                    $('.mfs_fixed_table_head').floatThead("destroy");
                    
                    setTimeout(function(){
                        $('.mfs_fixed_table_head').removeAttr("style")
                        $('.mfs_fixed_table_head thead').html(fixedTableHeaderHTML);
                        
                        $('.mfs_fixed_table_head').floatThead({
                            position: "fixed",
                            top: 69
                        });
                    }, 500);
                }
			}     
        }
    };
	
    var __listenToReRenderEvent = function(){
        (function() {
            var origOpen = XMLHttpRequest.prototype.open;
            XMLHttpRequest.prototype.open = function() {
                
                //console.log('request started!');
                //_UIHelpers.showLoader();
                
                this.addEventListener('load', function() {
                    //console.log('request completed!');
                    //console.log(this.readyState); //will always be 4 (ajax is completed successfully)
                    //console.log(this.responseText);
                    
                    
                    //Re-Initialize all the interactions after re-render, it may have lost the event bindings.
                    //console.log("Re-Initialize");
                    
                    try{
                        JSON.parse(this.responseText);
                    }
                    catch(e){
                        var isTablet = (window.screen.width == 768 && window.screen.height == 1024 ) ? true : false;
                        if(!isTablet){
                            isTablet = (window.screen.width == 1024 && window.screen.height == 768 ) ? true : false;
                        }
                        if(isTablet){
                            if($('.mfs-list-related-sections').length > 0){
                                $('.mfs-list-related-sections').masonry({
                                    // options
                                    itemSelector: '.grid-item',
                                    columnWidth: ".grid-item",
                                    gutter : 23
                                });   
                            }
                        }
                        __eventListeners();
                        __initEventAssignedTo();
                        __initTaskAssignedTo();
                        __initSpeakerRequestedFor();
                        
                        __setupPolymorphicLookups();
                        __setupLookups();
                        
                        _UIHelpers.initDatePickers();
                        _UIHelpers.initMultiSelects();
                        
                        _UIHelpers.hideLoader();
                    }
                });
                origOpen.apply(this, arguments);   
            };
        })();
    };
    
    var __reRenderIcons = function(container){
        var allIcons;
        if(container){
         	allIcons = $(container).find(".slds-icon__container[data-reset-icons='true']");   
        }
        else{
            allIcons = $("body").find(".slds-icon__container[data-reset-icons='true']");
        }
        
        for(var i=0, iLen = allIcons.length; i < iLen; i++){
            var iconHTML = '',
                svgIcon = $($(allIcons)[i]).data("rerender-icon"),
                svgClasses = $($(allIcons)[i]).data("render-icon-class");
            
            iconHTML =   '<svg aria-hidden="true" class="'+svgClasses+'">'+
                            '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="'+svgIcon+'"></use>'+
                         '</svg>';
            
            $($(allIcons)[i]).html(iconHTML);
        }
    };
    
    var __initEventAssignedTo = function(){
        if(allUsers !== ""){
            var allUsersObj = JSON.parse(allUsers);
            
            _UIHelpers.renderLookupField($(".mfs_ev_assigned_to"), allUsersObj["Users"]);
            Lookup.initLookup();
        }
    };
    
    var __initSpeakerRequestedFor = function(){
        if(allUsers !== ""){
            var allUsersObj = JSON.parse(allUsers);
            _UIHelpers.renderLookupField($(".er_requested_for"), allUsersObj["Users"]);
            Lookup.initLookup();
        }
    };
    
    var __initTaskAssignedTo = function(){
        if(allUsers !== ""){
            var allUsersObj = JSON.parse(allUsers);
            
            _UIHelpers.renderLookupField($(".mfs_task_assigned_to"), allUsersObj["Users"]);
            Lookup.initLookup();
        }
    };
    
    var __setupPolymorphicLookups = function(){
        $(".slds-lookup.slds-lookup--polymorphic").polymorphicLookup();
    };
    
    var __setupLookups = function(){
        $(".slds-lookup[data-lookup-type='normal']").lookup();
    };
    
    var __setAdditionalNotesHeight = function(){
        var hasEditorLoaded = setInterval(function(){
            if($(".mfs-additional-notes-rte .cke_contents").length > 0){
                clearInterval(hasEditorLoaded);
                var isTask = $(".mfs_task_section").length > 0 ? true : false;
                var recType = $.trim($(".recType").text());
                
                if(recType != "inst"){
                    if(isTask){
                        $(".mfs-additional-notes-rte .cke_contents").height(545);
                    }
                    else{
                        $(".mfs-additional-notes-rte .cke_contents").height(880);
                    }
                }
                else{
                    if(isTask){
                        $(".mfs-additional-notes-rte .cke_contents").height(235);
                    }
                    else{
                        $(".mfs-additional-notes-rte .cke_contents").height(545);
                    }   
                }
            }
        }, 100);
    };
    
    var __clearEmptyRelatedLists = function(){
        var relatedList = $(".mfs-list-related-sections > li");
        for(var i=0, iLen = relatedList.length; i < iLen; i++){
            if($.trim($(relatedList[i]).text()) == ""){
                $(relatedList[i]).remove(); 
            }
        }
        
        if($(".mfs-list-related-sections > li").length == 1){
            $(".mfs-list-related-sections > li:first-child").css("width", "100%");
        }
    };
    
    var __htmlDecode = function(val){
        var str = String(val);
        return String(str)
            .replace(/&amp;/g, '&')
            .replace(/&quot;/g, '"')
            .replace(/&#39;/g, '\'')
            .replace(/&lt;/g, '<')
            .replace(/&gt;/g, '>')
            .replace(/&#x2F;/g, '\/');
    };
    
	/**
	 * Ends : Private Methods
	 */
	
	
	/**
	 * Privileged Methods
	 */
	
	var _initApp = function(){
        _UIHelpers.initDatePickers();
        _UIHelpers.initMultiSelects();
        _UIHelpers.initPolyMorphicLookups();
        _UIHelpers.initLookups();
        
        __eventListeners();
        __listenToReRenderEvent();
        __initEventAssignedTo();
        __initTaskAssignedTo();
        __initSpeakerRequestedFor();
        __setupPolymorphicLookups();
        __setupLookups();
        __setAdditionalNotesHeight();
        __clearEmptyRelatedLists();
        __setConsoleResizeScroll();
        
        initOrientationChange();
	};
	
	var _UIHelpers = function(){
		var _openModal = function(modalSelector, e){
			e.preventDefault();
			
			$(modalSelector).parents(".slds-modal").removeClass("slds-fade-in-open");
			$(modalSelector).parents(".slds-modal").next(".slds-backdrop").removeClass("slds-backdrop--open");
		};
		
		var _closeModal = function(modalSelector, e){
			e.preventDefault();
			
			$(modalSelector).parents(".slds-modal").removeClass("slds-fade-in-open");
			$(modalSelector).parents(".slds-modal").next(".slds-backdrop").removeClass("slds-backdrop--open");
		};
        
        var _initDatePickers = function(){
            
            $.aljsInit({
                assetsLocation: "/resource/MFS_UI_Assets"
            });
            
            var allDatePickers = $(".dateInput input[type='text']");
            
            for(var i=0, iLen = allDatePickers.length; i < iLen; i++){
                (function(datePickerElem){
                    var mainParentElem, datePickerHTML;
                    var iconHTML = '<svg aria-hidden="true" class="slds-input__icon slds-icon-text-default" style="cursor: pointer;"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/resource/MFS_UI_Assets/assets/icons/utility-sprite/svg/symbols.svg#event"></use></svg>';
                    
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
		
        var _initMultiSelects = function(){
            var allMultiSelects = $("[data-aljs='multi-select']");
            
            for(var i=0, iLen = allMultiSelects.length; i < iLen; i++){
                (function(multiSelectElem){
                    var dataType = $(multiSelectElem).data("type") == "json" ? "JSON" : "CSV";
                    if($(multiSelectElem).data("unselected-items")){
                        if(dataType == "JSON"){
                            var leftValuesJSON = $(multiSelectElem).data("unselected-items");
                        }
                        else{
                            var leftValuesJSON = __formatToJSON($(multiSelectElem).data("unselected-items")) ? __formatToJSON($(multiSelectElem).data("unselected-items")) : [];
                        }
                    }
                    
                    if($(multiSelectElem).data("selected-items")){
                        if(dataType == "JSON"){
                            var rightValuesJSON = $(multiSelectElem).data("selected-items");
                        }
                        else{
                            var rightValuesJSON = __formatToJSON($(multiSelectElem).data("selected-items")) ? __formatToJSON($(multiSelectElem).data("selected-items")) : [];
                        }
                    }
                    $(multiSelectElem).multiSelect({
                        unselectedItems: leftValuesJSON,
                        selectedItems: rightValuesJSON
                    });
                })(allMultiSelects[i]);
            } 
        };
        
        var _initLookups = function(){
           	 $.fn.lookup = function(){
                 var that = $(this);
                 for(var i=0, iLen = that.length; i < iLen; i++){
                     (function(currElem){
                         var queryURL = currElem.data("query-url");
                         var iconPath = currElem.data("icon-path") ? currElem.data("icon-path") : '/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#account';
                         var isMulti = (currElem.data("select") == "multi") ? true : false;
                         
                         currElem.find("input[type='text']").off("keyup").on("keyup", function(e){
                             //console.log(queryURL, $(this).val());
                             
                             if($(this).val() !== ""){
                                 Visualforce.remoting.Manager.invokeAction(
                                     queryURL, $(this).val(),
                                     function(result, event){
                                         var listHTML =  '';
                                         
                                         currElem.find(".slds-lookup__menu > .slds-lookup__list").empty();
                                         
                                         if(event.status){
                                             if($(currElem).data("callback")){
                                                 var res = ( new Function( 'return ' + $(currElem).data("callback") ) )();
                                                 if(typeof(res) == "function"){
                                                     res(result, currElem, iconPath, isMulti);
                                                 }
                                             }
                                         }
                                     }, 
                                     {escape: true}
                                 );
                             }
                             else{
                                 if(!isMulti){
                                     currElem.find(".slds-lookup__menu > .slds-lookup__list").empty();
                                     currElem.find(".slds-lookup__search-input").prev().val("");
                                     
                                     var res = ( new Function( 'return ' + $(currElem).data("callback") ) )();
                                     if(typeof(res) == "function"){
                                         res("", currElem, iconPath, isMulti);
                                     }
                                 }
                             }
                         });
                     })($(that[i]));
                 }
            };
        };
        
        var _initPolyMorphicLookups = function(){
            $.fn.polymorphicLookup = function(){
              	var that = $(this);
                
                for(var i=0, iLen = that.length; i < iLen; i++){
                    (function(currElem){
                        var queryURL = currElem.find('button.slds-button[aria-haspopup="true"]').data("query-default-url");
                        var selectedIconHtml = currElem.find(".selected-icon-container").html();
                        var isMulti = (currElem.data("select") == "multi") ? true : false;
                        
                        currElem.find('button.slds-button[aria-haspopup="true"]').off("click").on("click", function(e){
                            e.preventDefault();
                            e.stopPropagation();
                            
                            $(this).next(".slds-dropdown.slds-dropdown--left").slideToggle("fast");
                        });
                        
                        currElem.find(".slds-dropdown.slds-dropdown--left ul.dropdown__list > li.slds-dropdown__item").off("click").on("click", function(){
                            selectedIconHtml = $(this).find(".slds-icon__container > span").html();
                            queryURL = $(this).data("query-url");
                            currElem.find(".selected-icon-container").html(selectedIconHtml);
                            
                            currElem.find('button.slds-button[aria-haspopup="true"]').data("query-default-url", queryURL);
                            
                            if(!isMulti){
                                currElem.find(".slds-lookup__search-input").val("");
                                currElem.find(".slds-lookup__search-input").prev().val("");   
                            }
                            
                            //console.log(that.find(".slds-lookup__search-input"));
                        });
                        
                        currElem.find(".slds-lookup__search-input").off("keyup").on("keyup", function(e){
                            queryURL = currElem.find('button.slds-button[aria-haspopup="true"]').data("query-default-url");
                            selectedIconHtml = currElem.find(".selected-icon-container").html();
                            //console.log(queryURL, $(this).val());
                            if(e.keyCode !== 13){
                                if($(this).val() !== ""){
                                    Visualforce.remoting.Manager.invokeAction(
                                        queryURL, $(this).val(),
                                        function(result, event){
                                            var listHTML =  '';
                                            
                                            currElem.find(".slds-lookup__menu > .slds-lookup__list").empty();
                                            
                                            //console.log(result);
                                            
                                            if(event.status){
                                                if($(currElem).data("callback")){
                                                    var res = ( new Function( 'return ' + $(currElem).data("callback") ) )();
                                                    
                                                    if(typeof(res) == "function"){
                                                        res(result, currElem, selectedIconHtml, isMulti);
                                                    }
                                                }
                                            }
                                        }, 
                                        {escape: true}
                                    );   
                                }
                                else{
                                    currElem.find(".slds-lookup__menu > .slds-lookup__list").empty();
                                    currElem.find(".slds-lookup__search-input").prev().val("");
                                }    
                            }
                        });
                    })($(that[i]));
                    
                }
            };
        };
        
        var _renderLookupField = function(elem, lookupJSON, initValue, initID){
            elem.data("lookup-menu", lookupJSON);
            
            if(initValue){
                elem.data("lookup-menu-default", initID);
                
                setTimeout(function(){
                    elem.val(initValue);
                }, 300);
            }
        };
        
        var _prevDefault = function(e){
            e.preventDefault();
        };
        
        var _showLoader = function(){
            /*if($(".slds").find(".mfs-spinner").length == 0){
                $(".slds").append('<div class="slds-spinner_container mfs-spinner">'+
                                          '<div class="slds-spinner" role="alert">'+
                                            '<span class="slds-assistive-text">Loading</span>'+
                                          '<div><img src="/resource/MFS_UI_Assets/assets/images/spinners/slds_spinner_brand.gif" width="50" /></div>'+
                                      '</div>'+
                                  '</div>');
            }*/
            
            if($(".slds").find(".slds-loader--container").length == 0){
                $(".slds").append('<div class="slds-loader--container"><div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog"><div class="slds-modal__container"><div class="slds-text-align--center loader-container"><img src="/resource/MFS_UI_Assets/assets/images/spinners/slds_spinner_brand.gif" width="50" /></div></div></div><div class="slds-backdrop slds-backdrop--open"></div></div>');
            }
        };
        
        var _hideLoader = function(){
            $(".slds").find('.slds-loader--container').remove();
        };
        
        
        
        var __formatToJSON = function(csv){
            var csvArr = csv.toString().split(",");
            var jsonArr = [];
            for(var i=0, iLen = csvArr.length; i < iLen; i++){
                jsonArr[i] = {};
                jsonArr[i]["id"] = csvArr[i].replace(/ /g, "__").replace(/\//g, 'ForwardSlash').replace(/["'\(\)]/g, "__");
                jsonArr[i]["label"] = csvArr[i];
            }
            
            return jsonArr;
        };
        
		return {
			openModal : _openModal,
            closeModal : _closeModal,
            showLoader : _showLoader,
            hideLoader : _hideLoader,
            initDatePickers : _initDatePickers,
            initMultiSelects : _initMultiSelects,
            initLookups : _initLookups,
            initPolyMorphicLookups : _initPolyMorphicLookups,
            renderLookupField : _renderLookupField,
            prevDefault : _prevDefault
		};
	}();
    
    var _setSelectedLookupToHiddenField = function(val, elem){
        $(elem).prev().val(val);
        console.log($(elem), $(elem).prev().val());
    };
    
    var _eventDateTimeChange = function(){
        _UIHelpers.showLoader();
        dateTimeChange();
        
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
    
    var _eventInviteeDateTimeChange = function(){
        _UIHelpers.showLoader();
        changeInviteeTimeSlots();
    };
    
    var _selectEventName = function(result, currElem, iconHTML){
        var listHTML = "";
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var sfdcID = result[i]["Id"];
                var firstName = result[i]["FirstName"] ? result[i]["FirstName"] : "";
                var lastName = result[i]["LastName"] ? result[i]["LastName"] : "";
                var nameToShow = $.trim(firstName+" "+lastName);
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelection(this)">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconHTML+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text">'+nameToShow+'</div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
        }
    };
    
    var _selectContactNameInst = function(result, currElem, iconHTML){
        var listHTML = "";
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var sfdcID = result[i]["Id"];
                var firstName = result[i]["FirstName"] ? result[i]["FirstName"] : "";
                var lastName = result[i]["LastName"] ? result[i]["LastName"] : "";
                var nameToShow = $.trim(firstName+" "+lastName);
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelectionInstContact(this)">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconHTML+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text">'+nameToShow+'</div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
        }
    };
    
    var _selectEventRelatedTo = function(result, currElem, iconHTML){
        var listHTML = "";
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var isCase = result[i]["CaseNumber"] ? true : false;
                var sfdcID = result[i]["Id"];
                var nameToShow = result[i]["Name"];
                
                if(isCase){
                    nameToShow = result[i]["CaseNumber"];
                }
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelection(this)">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconHTML+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text">'+nameToShow+'</div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
        }
    };
    
    var _selectEventRequest = function(result, currElem, iconPath){
        var listHTML = "";
        console.log(result);
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var sfdcID = result[i]["Id"];
                var nameToShow = result[i]["Name"];
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelection(this)">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconPath+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text">'+nameToShow+'</div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
        }
    };
    
    var _selectContactLookup = function(result, currElem, iconPath){
        var listHTML = "";
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var sfdcID = result[i]["Id"];
                var firstName = result[i]["FirstName"] ? result[i]["FirstName"] : "";
                var lastName = result[i]["LastName"] ? result[i]["LastName"] : "";
                var nameToShow = $.trim(firstName+" "+lastName);
                var iconHTML = '<span class="slds-icon__container selected-icon-container">'+
                                '<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small slds-m-right--small">'+
                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="'+iconPath+'"></use>'+
                                '</svg>'+
                                '</span>';
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelection(this)">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconHTML+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text">'+nameToShow+'</div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
        }
    };
    
    var _selectOrgLookup = function(result, currElem, iconPath){
        var listHTML = "";
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var sfdcID = result[i]["Id"];
                var nameToShow = result[i]["Name"];
                
                var iconHTML = '<span class="slds-icon__container selected-icon-container">'+
                                '<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small slds-m-right--small">'+
                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="'+iconPath+'"></use>'+
                                '</svg>'+
                                '</span>';
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelection(this)">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconHTML+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text">'+nameToShow+'</div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
        }
    };
    
    var _selectMMRClientInvestment = function(result, currElem, iconPath){
        var listHTML = "";
        //console.log(result, currElem);
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var sfdcID = result[i]["Id"];
                var name = result[i]["Name"] ? result[i]["Name"] : "";
                var nameToShow = $.trim(name);
                var iconHTML = '<span class="slds-icon__container selected-icon-container">'+
                                '<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small slds-m-right--small">'+
                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="'+iconPath+'"></use>'+
                                '</svg>'+
                                '</span>';
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelectionMMR(this)">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconHTML+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text">'+nameToShow+'</div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
        }
    };
    
    var _selectSpeakerRequest = function(result, currElem, iconPath){
        var listHTML = "";
        console.log(result);
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var sfdcID = result[i]["Id"];
                var name = result[i]["Name"] ? result[i]["Name"] : "";
                var eventTitle = result[i]["Event_Title__c"] ? result[i]["Event_Title__c"] : "";
                var requestor = result[i]["Requester__r"] ? result[i]["Requester__r"]["Name"] : "";
                var startDateTS = result[i]["Start_Date__c"] ? result[i]["Start_Date__c"] : "";
                var startDate = "";
                if(startDateTS !== ""){
                    var startDateObj = new Date(startDateTS);
                    
                    startDate = startDateObj.getMonth()+"/"+startDateObj.getDate()+"/"+startDateObj.getFullYear()+" "+startDateObj.getHours()+":"+startDateObj.getMinutes();
                }
                
                var iconHTML = '<span class="slds-icon__container selected-icon-container">'+
                                '<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small slds-m-right--small">'+
                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="'+iconPath+'"></use>'+
                                '</svg>'+
                                '</span>';
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelectionSR(this)">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconHTML+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text"><div class="slds-text-title">'+$.trim(name)+'</div><div>'+requestor+' : '+startDate+'</div><div class="slds-text-title--caps speaker-request-name">'+eventTitle+'</div></div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
        }
    };
    
    var _setLookupSelectionMMR = function(elem){
        var sfdcID = $(elem).data("sfdc-id");
        var currSelectedText = $.trim($(elem).text());
        
        //console.log(sfdcID, $(elem).prev());
        
        $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").val(currSelectedText);
        $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev().val(sfdcID);
        
        //console.log($(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev().val());
        
        addMMRPortfolios();
    };
    
    var _setLookupSelection = function(elem){
        var sfdcID = $(elem).data("sfdc-id");
        var currSelectedText = $.trim($(elem).text());
        
        //console.log(sfdcID, $(elem).prev());
        
        $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").val(currSelectedText);
        $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev().val(sfdcID);
        
        //console.log($(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev().val());
    };
    
    var _setLookupSelectionMulti = function(elem, isMulti, iconPath, iconClass){
        var sfdcID = $(elem).data("sfdc-id");
        var currSelectedText = $.trim($(elem).text());
        var iconClassNew = iconClass ? iconClass : "";
        var iconPathNew = iconPath ? iconPath : "";
        
        if(!isMulti){
            $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").val(currSelectedText);
            $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev().val(sfdcID);   
        }
        else{
            //Create some pills here..
            $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").val("");
            var pillHTML = '<span class="slds-pill">'+
                				'<span class="slds-icon_container '+iconClass+' slds-pill__icon_container">'+
                                    '<svg class="slds-icon" aria-hidden="true">'+
                                        '<use xlink:href="'+iconPath+'"></use>'+
                                    '</svg>'+
								'</span>'+
                                '<a href="javascript:void(0);" class="slds-pill__label" title="" data-pill-id="'+sfdcID+'">'+currSelectedText+'</a>'+
                                '<button class="slds-button slds-button--icon slds-pill__remove" title="Remove">'+
                                    '<svg class="slds-button__icon" aria-hidden="true">'+
                                        '<use xlink:href="/resource/MFS_UI_Assets/assets/icons/utility-sprite/svg/symbols.svg#close"></use>'+
                                    '</svg>'+
                                '</button>'+
                            '</span>';
			var hiddenField = $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev();
            var currHiddenVals = (hiddenField.val() !== "") ? hiddenField.val().split(",") : [];
            var newHiddenVals = "";
            var listText = "";
            
            if(currHiddenVals.indexOf(sfdcID) === -1 || currHiddenVals.length === 0){
                currHiddenVals.push(sfdcID);
                newHiddenVals = currHiddenVals.join(",");
                hiddenField.val(newHiddenVals);
                
                if(currHiddenVals.length - 1 > 0){
                    listText = "<strong>"+currSelectedText +"</strong> and "+ (currHiddenVals.length - 1)+ " more";
                }
                else{
                    listText = "<strong>"+currSelectedText +"</strong>";
                }
                                
                $(elem).parents(".slds-lookup").next(".slds-pill_container").removeClass("slds-hide").prepend(pillHTML);
                $(elem).parents(".slds-lookup").next().next(".added-list-container").addClass("slds-hide").html(listText);
                
                //showLoading();
                //search();
            }
            
            $(elem).parents(".slds-lookup").next(".slds-pill_container").find(".slds-pill button.slds-pill__remove").off("click").on("click", function(e){
                e.preventDefault();
                e.stopPropagation();
                
                var pillID = $(this).prev("a").data("pill-id");
                var newHiddenValsAfterDel = hiddenField.val().split(",");
                var pillIndex = newHiddenValsAfterDel.indexOf(pillID);
                var newHiddenValsStrAfterDel = "";
                var listText = "";
                var firstPillTextAfterDel = "";
                
                //console.log(pillID);
                //console.log("Before Del", newHiddenValsAfterDel, pillIndex);
                newHiddenValsAfterDel.splice(pillIndex, 1);
                //console.log("After Del", newHiddenValsAfterDel);
                
                newHiddenValsStrAfterDel = newHiddenValsAfterDel.join(",");
                hiddenField.val(newHiddenValsStrAfterDel);
                
                $(this).parent().remove();
                
                if(newHiddenValsAfterDel.length === 0){
                    $(elem).parents(".slds-lookup").next(".slds-pill_container").addClass("slds-hide");
                }
                
                firstPillTextAfterDel = $.trim($(elem).parents(".slds-lookup").next(".slds-pill_container").find(".slds-pill:first-child").text());
                
                if(newHiddenValsAfterDel.length - 1 > 0){
                    listText = "<strong>"+firstPillTextAfterDel +"</strong> and "+ (newHiddenValsAfterDel.length - 1)+ " more";    
                }
                else{
                    listText = "<strong>"+firstPillTextAfterDel +"</strong>";
                }
                
                
                $(elem).parents(".slds-lookup").next().next(".added-list-container").html(listText);
                
                //showLoading();
                //search();
            });
        }
    };
	
    var _setLookupSelectionSR = function(elem){
        var sfdcID = $(elem).data("sfdc-id");
        var currSelectedText = $.trim($(elem).find(".speaker-request-name").text());
        
        //console.log(sfdcID, $(elem).prev());
        
        $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").val(currSelectedText);
        $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev().val(sfdcID);
        
        //console.log($(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev().val());
    };
    
    var _setLookupSelectionRelSearchAssigned = function(elem){
        if(elem){
            var sfdcID = $(elem).data("sfdc-id");
            var currSelectedText = $.trim($(elem).text());
            
            //console.log(sfdcID, $(elem).prev());
            
            $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").val(currSelectedText);
            $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev().val(sfdcID);
        }
        
        //showLoading();
        //search();
    };
    
    var _setLookupSelectionInstContact = function(elem){
      	var sfdcID = $(elem).data("sfdc-id");
        var currSelectedText = $.trim($(elem).text());
        
        //console.log(sfdcID, $(elem).prev());
        
        $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").val(currSelectedText);
        $(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev().val(sfdcID);
        
        changeEventLocation();
        
        //console.log($(elem).parents(".slds-lookup").find(".slds-lookup__search-input").prev().val());  
    };
    
    var _setSelectedAssignedTo = function(val, elem){
        $(elem).prev().val(val);
        showLoading();
        changeHostForInvitees();
    };
    
    var _setRelatedSearchAttendee = function(result, currElem, iconHTML, isMulti){
      	var listHTML = "";
        
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var sfdcID = result[i]["Id"];
                var firstName = result[i]["FirstName"] ? result[i]["FirstName"] : "";
                var lastName = result[i]["LastName"] ? result[i]["LastName"] : "";
                var nameToShow = $.trim(firstName+" "+lastName);
                var isContact = sfdcID.lastIndexOf("003", 0) === 0 ? true : false;
                var iconPath = isContact ? "/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#contact" : "/resource/MFS_UI_Assets/assets/icons/standard-sprite/svg/symbols.svg#user";
                var iconClass = isContact ? "slds-icon-standard-contact" : "slds-icon-standard-user";
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelectionMulti(this, '+isMulti+',\''+iconPath+'\', \''+iconClass+'\')">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconHTML+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text">'+nameToShow+'</div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
        }  
    };
    
    var _setRelatedSearchAssignedTo = function(result, currElem, iconPath){
        var listHTML = "";
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var sfdcID = result[i]["Id"];
                var fName = result[i]["FirstName"] ? result[i]["FirstName"] : "";
                var lName = result[i]["LastName"] ? result[i]["LastName"] : "";
                var nameToShow = $.trim(fName+" "+lName);
                
                var iconHTML = '<span class="slds-icon__container selected-icon-container">'+
                                '<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small slds-m-right--small">'+
                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="'+iconPath+'"></use>'+
                                '</svg>'+
                                '</span>';
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelectionRelSearchAssigned(this)">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconHTML+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text">'+nameToShow+'</div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
            _setLookupSelectionRelSearchAssigned("");
        }
    };
    
    var _setRelatedSearchProducts = function(result, currElem, iconPath, isMulti){
        var listHTML = "";
        if(result && result.length > 0){
            for(var i=0, iLen = result.length; i < iLen; i++){
                var sfdcID = result[i]["Id"];
                var name = result[i]["Name"] ? result[i]["Name"] : "";
                var nameToShow = $.trim(name);
                var iconClass = "slds-icon-standard-product";
                var iconHTML = '<span class="slds-icon__container selected-icon-container">'+
                                '<svg aria-hidden="true" class="slds-icon '+iconClass+' slds-icon--small slds-m-right--small">'+
                                '<use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="'+iconPath+'"></use>'+
                                '</svg>'+
                                '</span>';
                
                listHTML +=     '<li data-sfdc-id="'+sfdcID+'" role="presentation" onclick="MFSApp.setLookupSelectionMulti(this, '+isMulti+',\''+iconPath+'\', \''+iconClass+'\')">'+
                    '<span class="slds-lookup__item-action slds-media slds-media--center" role="option">'+
                    iconHTML+
                    '<div class="slds-media__body">'+
                    '<div class="slds-lookup__result-text">'+nameToShow+'</div>'+
                    '</div>'+
                    '</span>'+
                    '</li>';
            }
            
            currElem.find(".slds-lookup__menu").removeClass("slds-hide").show();
            currElem.find(".slds-lookup__menu > .slds-lookup__list").html(listHTML);
        }
        else{
            currElem.find(".slds-lookup__menu").addClass("slds-hide");
        }
    };
    
    var _relatedActsSearchOnEnterKey = function(e){
        if(e.keyCode === 13){
            e.preventDefault();
            e.stopPropagation();
            
            $(".mfs-related-search-button").trigger("click");
            
            return false;
        }
    };
    
    var _relatedActsSearchTableReflow = function(){
        if($(window).width() <= 1280 && $(window).width() >= 1024 && !__isTablet && !__isMobile){
            if($('.mfs_fixed_table_head').length > 0){
                $('.mfs_fixed_table_head').floatThead("destroy");
                
                setTimeout(function(){
                    $('.mfs_fixed_table_head').removeAttr("style")
                    $('.mfs_fixed_table_head thead').html(fixedTableHeaderHTML);
                    
                    $('.mfs_fixed_table_head').floatThead({
                        position: "fixed",
                        top: 69
                    });
                }, 500);
            }
        }
        else if($(window).width() < 1024 && $(window).width() >= 10 && !__isTablet && !__isMobile){
            if($('.mfs_fixed_table_head').length > 0){
                $('.mfs_fixed_table_head').floatThead("destroy");
                
                setTimeout(function(){
                    $('.mfs_fixed_table_head').removeAttr("style")
                    $('.mfs_fixed_table_head thead').html(fixedTableHeaderHTML);
                    
                    $('.mfs_fixed_table_head').floatThead({
                        scrollContainer: function($table){
                            return $table.closest('.mfs-main-container');
                        }
                    });
                }, 500);
            }
        }
		else if($(window).width() > 1280 && !__isTablet && !__isMobile){
            if($('.mfs_fixed_table_head').length > 0){
                $('.mfs_fixed_table_head').floatThead("destroy");
                
                setTimeout(function(){
                    $('.mfs_fixed_table_head').removeAttr("style")
                    $('.mfs_fixed_table_head thead').html(fixedTableHeaderHTML);
                    
                    $('.mfs_fixed_table_head').floatThead({
                        position: "fixed",
                        top: 69
                    });
                }, 500);
            }
		}  
    };
    
	/**
	 * Ends : Privileged Methods
	 */
	
	return {
		initApp : _initApp,
		UIHelpers : _UIHelpers,
        setSelectedLookupToHiddenField : _setSelectedLookupToHiddenField,
        eventDateTimeChange : _eventDateTimeChange,
        eventInviteeDateTimeChange : _eventInviteeDateTimeChange,
        selectEventName : _selectEventName,
        selectEventRelatedTo : _selectEventRelatedTo,
        selectEventRequest : _selectEventRequest,
        selectContactLookup : _selectContactLookup,
        selectOrgLookup : _selectOrgLookup,
        selectMMRClientInvestment : _selectMMRClientInvestment,
        selectSpeakerRequest : _selectSpeakerRequest,
        setLookupSelection : _setLookupSelection,
        setLookupSelectionMulti : _setLookupSelectionMulti,
        setLookupSelectionMMR : _setLookupSelectionMMR,
        setLookupSelectionSR : _setLookupSelectionSR,
        selectContactNameInst : _selectContactNameInst,
        setLookupSelectionRelSearchAssigned : _setLookupSelectionRelSearchAssigned,
        setLookupSelectionInstContact : _setLookupSelectionInstContact,
        setSelectedAssignedTo : _setSelectedAssignedTo,
        setRelatedSearchAttendee : _setRelatedSearchAttendee,
        setRelatedSearchAssignedTo : _setRelatedSearchAssignedTo,
        setRelatedSearchProducts : _setRelatedSearchProducts,
        relatedActsSearchOnEnterKey : _relatedActsSearchOnEnterKey,
        relatedActsSearchTableReflow : _relatedActsSearchTableReflow
	};
}(jQuery);

$(document).ready(function(){
	MFSApp.initApp();
});

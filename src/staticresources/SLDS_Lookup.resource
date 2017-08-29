/**
 * @author Balu John Thomas
 * @description Lookup module for SLDS JS
 * @support balujohnthomas@gmail.com
 * @date Apr 28, 2016
 * @company PricewaterhouseCoopers
 *  
 */

var Lookup = function(){
	
	"use strict";
	
	/**
	 * Lookup Module
	 * @description Lookup functionality methods
	 */
	
	var lookupConfigs = {
		minSearchChar : 1	
	};
	
	var _initLookup = function(lookupFields){
		var allLookupFields;
		
		if(lookupFields){
			allLookupFields = lookupFields;
		}
		else{
			allLookupFields = $("input[role='combobox']");
		}
        
        var lookupHTML = '<div class="slds-lookup__menu" role="listbox" style="display:none;"><ul class="slds-lookup__list" role="presentation"></ul></div>';
		
		for(var i=0, iLen = allLookupFields.length; i < iLen; i++){
			(function(lookupField){
				var lookupMenuItemsRaw = (lookupField.data("lookup-menu")) ? lookupField.data("lookup-menu") : "";
				var lookupMenuDefaultVal = (lookupField.data("lookup-menu-default")) ? lookupField.data("lookup-menu-default") : "";
				var isLookUpDataInJSON = (lookupField.data("lookup-data-type")) ? true : false;
				var isMultiSelect = (lookupField.data("select") == "multi") ? true : false;
				var prePopulateLookupDetails = "";
				
				if(lookupMenuDefaultVal !== ""){
					prePopulateLookupDetails = {
						"lookupField" : lookupField,
						"lookupDefaultVal" : lookupMenuDefaultVal,
						"isMultiSelect" : isMultiSelect
					};
				}
				
				if(lookupMenuItemsRaw !== ""){
					var lookupMenuItems = isLookUpDataInJSON ? lookupMenuItemsRaw : lookupMenuItemsRaw.split(",");
                    if(lookupField.next(".slds-lookup__menu").length == 0){
                        $(lookupHTML).insertAfter(lookupField);
                        __populateLookupMenu(lookupMenuItems, lookupField.next("div.slds-lookup__menu").find("ul.slds-lookup__list"), isLookUpDataInJSON, lookupField, isMultiSelect, prePopulateLookupDetails);
                        __eventListeners(lookupField, lookupField.next("div.slds-lookup__menu"), isMultiSelect);
                    }
				}
			})($(allLookupFields[i]));
		}
	};
	
	var __populateLookupMenu = function(lookupItems, listElem, isLookUpDataInJSON, currLookupElem, isMultiSelect, prePopulateLookupDetails){
		var listHTML = '';
		
		if(isMultiSelect){
			var pillContainerHTML = '<div class="slds-pill_container slds-hide animated fadeIn"></div>';
			$(pillContainerHTML).insertAfter(currLookupElem.parents(".slds-form-element"));
		}
		
		if(!isLookUpDataInJSON){
			for(var i=0, iLen = lookupItems.length; i < iLen; i++){
				if($.trim(lookupItems[i]) !== ""){
					listHTML +=	'<li class="slds-lookup__item" data-list-item="'+$.trim(lookupItems[i])+'">'+
									'<a href="javascript:void(0);" role="option">'+
										'<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">'+
											'<use xlink:href="/resource/SLDS202/assets/icons/utility-sprite/svg/symbols.svg#user"></use>'+
										'</svg>'+
										$.trim(lookupItems[i])+
									'</a>'+
								'</li>';
				}
			}
		}
		else{
			for(var i=0, iLen = lookupItems.length; i < iLen; i++){
				listHTML +=	'<li class="slds-lookup__item" data-list-item="'+lookupItems[i]["Name"]+'" data-actual-value-from-json="'+lookupItems[i]["Id"]+'">'+
								'<a href="javascript:void(0);" role="option">'+
									'<svg aria-hidden="true" class="slds-icon slds-icon-standard-account slds-icon--small">'+
										'<use xlink:href="/resource/SLDS202/assets/icons/utility-sprite/svg/symbols.svg#user"></use>'+
									'</svg>'+
									$.trim(lookupItems[i]["Name"])+
								'</a>'+
							'</li>';
			}
		}
		
		listElem.html(listHTML);
		
		/* Show default values in lookup */
		if(prePopulateLookupDetails !== ""){
			if(prePopulateLookupDetails["isMultiSelect"]){
				var pillsHTML = "";
				var pillsContainer = prePopulateLookupDetails["lookupField"].parents(".slds-form-element").next();
				
				for(var i=0, iLen = prePopulateLookupDetails["lookupDefaultVal"].length; i < iLen; i++){
					pillsHTML 	+=	'<span class="slds-pill" onclick="StaffingApp.UIHelpers.removeLookupPills(this);">'+
									  	'<a href="javascript:void(0);" class="slds-pill__label" data-pill-id="'+prePopulateLookupDetails["lookupDefaultVal"][i]["Id"]+'">'+prePopulateLookupDetails["lookupDefaultVal"][i]["Name"]+'</a>'+
									  	'<button class="slds-button slds-button--icon slds-pill__remove">'+
									  		'<svg aria-hidden="true" class="slds-button__icon">'+
									  			'<use xlink:href="#close"></use>'+
											'</svg>'+
										'</button>'+
									'</span>';
				}
				
				if(pillsHTML !== ""){
					pillsContainer.removeClass("slds-hide");
					pillsContainer.html(pillsHTML);
				}
				prePopulateLookupDetails["lookupField"].val("");
			}
			else{
				if(prePopulateLookupDetails["lookupDefaultVal"].length > 0){
					prePopulateLookupDetails["lookupField"].val(prePopulateLookupDetails["lookupDefaultVal"][0]["Name"]);
					prePopulateLookupDetails["lookupField"].data("actual-selected-value", prePopulateLookupDetails["lookupDefaultVal"][0]["Id"]);
				}
			}
		}
	};
	
	var __eventListeners = function(lookupElem, menuListDOM, isMultiSelect){
		
		for(var i=0, iLen = lookupElem.length; i < iLen; i++){
			(function(currLookupElem, currMenuListDOM){
				currLookupElem.off("keyup").on("keyup", function(e){
					var inputVal = $(this).val(),
						lookUpContentBox = currMenuListDOM,
						allLookUps = lookUpContentBox.find("li.slds-lookup__item"),
						matchFound = false,
						lookupCallBackFn = $(this).data("callback");
					
					if(inputVal.length >= lookupConfigs.minSearchChar){
						
						var currElem = $(this),
			    			currVal = inputVal,
			    			currLookingItem;
			    		
			    		e.preventDefault();
			    		e.stopPropagation();
			    		e.stopImmediatePropagation();
			    		
			    		if(currVal !== ""){
			    			/* Filter the List */
			    			currLookingItem = getCurrentlyLookingItem(lookUpContentBox);
			    			currLookingItem.removeClass("active");
			    			
			    			for(var i=0, iLen = allLookUps.length; i < iLen; i++){
			    				var listStr = $(allLookUps[i]).data("list-item").toLowerCase();
			    				var currValSmall = currVal.toLowerCase();
			    					    				
			    				if(listStr.search(currValSmall) !== -1){
			    					matchFound = true;
			    					lookUpContentBox.show();
			    					$(allLookUps[i]).show();
			    				}
			    				else{
			    					if(!matchFound){
			    						lookUpContentBox.hide();
			    					}
			    					$(allLookUps[i]).hide();
			    				}
			    			}
			    			
			    			/* Ends Filter */
			    			
			    			
			    			switch(e.keyCode){
			    				case 40:
			    					/**
				    				 * Down Arrow
				    				 */
				    				
			    				break;
			    				
			    				case 38:
			    					/**
				    				 * Up Arrow
				    				 */
				    				
			    				break;
			    				
			    				case 27:
			    					/**
				    				 * Esc 
				    				 */
			    					currElem.val("");
			    					
			    					lookUpContentBox.hide();
			    				break;
			    				
			    				case 13:
			    					/**
				    				 * Enter 
				    				 */
			    					
			    				break;
			    				
			    				default:
			    					
			    			}
			    		}
			    		else{
			    			lookUpContentBox.hide();
			    		}
					}
					else{
						if(lookupCallBackFn){
		    				var res = ( new Function( 'return ' + lookupCallBackFn ) )();
		    				
		    				if(typeof(res) == "function"){
		    					res("", currLookupElem);
		    				}
		    			}
						
						lookUpContentBox.hide();
					}
				});
				
				
				currLookupElem.next(".slds-lookup__menu").find(".slds-lookup__list > li").off("click").on("click", function(e){
					e.stopPropagation();
					
					var currSelectedVal = $(this).data("list-item");
					var currSelectedID = $(this).data("actual-value-from-json");
	    			var lookupCallBack = currLookupElem.data("callback");
	    				    			
	    			if(isMultiSelect){
	    				//console.log("Implement pills");
	    				//currLookupElem.val(currSelectedVal);
	    				
	    				var pillsContainer = currLookupElem.parents(".slds-form-element").next();
	    				var pillsHTML ='<span class="slds-pill" onclick="StaffingApp.UIHelpers.removeLookupPills(this);">'+
				    				      '<a href="javascript:void(0);" class="slds-pill__label" data-pill-id="'+currSelectedID+'">'+currSelectedVal+'</a>'+
				    				      '<button class="slds-button slds-button--icon slds-pill__remove">'+
				    				         '<svg aria-hidden="true" class="slds-button__icon">'+
				    				            '<use xlink:href="#close"></use>'+
				    				         '</svg>'+
				    				      '</button>'+
				    				   '</span>';
	    				pillsContainer.removeClass("slds-hide");
	    				pillsContainer.append(pillsHTML);
	    				currLookupElem.val("");
	    			}
	    			else{
	    				currLookupElem.val(currSelectedVal);
	    			}
	    			
	    			if($(e.target).parent().data("actual-value-from-json")){
	    				currLookupElem.data("actual-selected-value", $(e.target).parent().data("actual-value-from-json"));
	    			}
	    			else{
	    				currLookupElem.data("actual-selected-value", currSelectedVal);
	    			}
	    			
	    			currSelectedVal = lookupElem.data("actual-selected-value");
	    				    			
	    			if(lookupCallBack){
	    				//A real smarter alternative to eval(). Thanks to Paul Irish
	    				var res = ( new Function( 'return ' + lookupCallBack ) )();
	    				
	    				if(typeof(res) == "function"){
	    					res(currSelectedVal, lookupElem);
	    				}
	    			}
	    			
	    			currMenuListDOM.hide();
				});
			})($(lookupElem[i]), $(menuListDOM[i]));
		}
		
		$(window).off("click").on("click", function(){
			$(".slds-lookup__menu").hide();
		});
	};
	
	var getCurrentlyLookingItem = function(lookUpBox){
		var currLookingItem = [];
		if(lookUpBox.find("ul > li.slds-lookup__item").length > 0){
			currLookingItem = (lookUpBox.find("ul > li.slds-lookup__item.active").length > 0) ? lookUpBox.find("ul > li.slds-lookup__item.active") : $(lookUpBox.find("ul > li.slds-lookup__item")[0]);
		}
		
		return currLookingItem;
	};
	
	return {
		initLookup : _initLookup
	};
}();
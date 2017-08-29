var MFS_BAR_Table_Engine = function($){
    var _init = function(){
        initPlugins();
        invokePlugins();
    };
    
    var nextCount = 0;
    var totaltemsDisplayed = 5;
    var rowsPerPage = 5;
    var totalPageRows;
    
    var initPlugins = function(){
        $.fn.expandableTables = function(){
            var that = $(this);
            var isEditMode = ($(this).data("render-mode") && $(this).data("render-mode") === "edit") ? true : false;
            
            $(".mfs_table_minus").addClass("slds-hide");
            $(".mfs_table_plus").removeClass("slds-hide");
            
            that.find("tbody > tr[scope='expandable-row'] > td:first-child").on("click", function(){
                var handleName = $(this).data("label");
                var allRowChildren = $("tr[scope='expanded-content'][aria-expand-parent='"+handleName+"']");
                
                if($(this).find(".mfs_table_minus").hasClass("slds-hide")){
                    //Expand
                    $(this).find(".mfs_table_plus").addClass("slds-hide");
                    $(this).find(".mfs_table_minus").removeClass("slds-hide");
                    allRowChildren.removeClass("slds-hide");
                }
                else{
                    //Collapse
                    $(this).find(".mfs_table_plus").removeClass("slds-hide");
                    $(this).find(".mfs_table_minus").addClass("slds-hide"); 
                    allRowChildren.addClass("slds-hide");
                    
                    $("tr[scope='expanded-content']").find(".mfs_table_plus").removeClass("slds-hide");
                    $("tr[scope='expanded-content']").find(".mfs_table_minus").addClass("slds-hide");   
                }
                
                
                allRowChildren.find("input[type='checkbox']").on("change", function(){
                    var thatPlan = $(this);
                    if($(this).is(":checked")){
                        
                        $(this).prev().val($(this).is(":checked"));
                        
                        $(this).parent().parent().find("input[type='text'][id*='numbersOnly']").val(100);
                        $(this).parent().parent().find("input[type='text'][id*='numbersOnly']").off("keyup").on("keyup", function(){
                            var currVal = ($(this).val() !== "") ? parseInt($(this).val(), 10) : 0;
                            $(this).val(currVal);
                            
                            calculatePlanPercentage(allRowChildren, $("td[data-label='"+handleName+"']").parent().find("input[type='text'][check-type='plan']"));
                            calculateRiskValue();
                        });     
                    }
                    else{
                        $(this).parent().parent().find("input[type='text'][id*='numbersOnly']").off("keyup");
                        $(this).parent().parent().find("input[type='text'][id*='numbersOnly']").val(0);
                    }
                    
                    calculatePlanPercentage(allRowChildren, $("td[data-label='"+handleName+"']").parent().find("input[type='text'][check-type='plan']"));
                    calculateRiskValue();
                });
            });
            
            that.find("tbody > tr > td [id*='planCB']").on("change", function(e){
                var handleName = $(this).parents("tr[scope='expandable-row']").find("td:first-child").data("label");
                var allRowChildren = $("tr[scope='expanded-content'][aria-expand-parent='"+handleName+"']");
                var thatPlan = $(this);
                
                if($(this).is(":checked")){
                    $(this).parents("tr[scope='expandable-row']").find("td:first-child .mfs_table_plus").addClass("slds-hide");
                    $(this).parents("tr[scope='expandable-row']").find("td:first-child .mfs_table_minus").removeClass("slds-hide");
                    
                    allRowChildren.removeClass("slds-hide");
                    checkUncheckHelper(allRowChildren.find(".portfolio_cb"), true);
                 	allRowChildren.find("input[type='checkbox']").attr("disabled", "disabled");   
                    
                    $(this).parents("tr[scope='expandable-row']").find("[id*='numbersOnly']").val(100);
                    allRowChildren.find("input[type='text'][id*='numbersOnly']").val(100).show();
                    allRowChildren.find("span[id*='numbersOnly1']").text("100").hide();
                    
                    $(this).parents("tr[scope='expandable-row']").find("[id*='numbersOnly']").on("keyup", function(e){
                        var currPercentage = ($(this).val() !== "") ? parseInt($(this).val(), 10) : 0;
                        $(this).val(currPercentage);
                        
                        allRowChildren.find("input[type='text'][id*='numbersOnly']").val(currPercentage);
                        allRowChildren.find("span[id*='numbersOnly1']").text(currPercentage);
                        calculateRiskValue();
                    });
                    
                    allRowChildren.find("input[type='text'][id*='numbersOnly']").on("keyup", function(){
                        var currPercentage = ($(this).val() !== "") ? parseInt($(this).val(), 10) : 0;
                        $(this).val(currPercentage);
                        
                        calculatePlanPercentage(allRowChildren, thatPlan.parents("tr[scope='expandable-row']").find("[id*='numbersOnly'][check-type='plan']"));
                        calculateRiskValue();
                    });
                }
                else{
                    $(this).parents("tr[scope='expandable-row']").find("td:first-child .mfs_table_plus").removeClass("slds-hide");
                    $(this).parents("tr[scope='expandable-row']").find("td:first-child .mfs_table_minus").addClass("slds-hide");
                    
                    allRowChildren.addClass("slds-hide");
                    checkUncheckHelper(allRowChildren.find("input[type='checkbox']"), false);
                    allRowChildren.find("input[type='checkbox']").removeAttr("disabled");
                    
                    $(this).parents("tr[scope='expandable-row']").find("[id*='numbersOnly']").val(0);
                    allRowChildren.find("input[type='text'][id*='numbersOnly']").val(0).show();
                    allRowChildren.find("span[id*='numbersOnly1']").hide();
                    
                    $(this).parents("tr[scope='expandable-row']").find("[id*='numbersOnly']").off("keyup");
                    allRowChildren.find("input[type='text'][id*='numbersOnly']").off("keyup");
                }
                
                calculatePlanPercentage(allRowChildren, thatPlan.parents("tr[scope='expandable-row']").find("[id*='numbersOnly'][check-type='plan']"));
                calculateRiskValue();
            });
             
            that.find("thead .sum-all").on("change", function(e){
                var allRowChildren = $("tr[scope='expanded-content']");
                if($(this).is(":checked")){
                    $(".mfs_table_plus").addClass("slds-hide");
                    $(".mfs_table_minus").removeClass("slds-hide");
                 	allRowChildren.removeClass("slds-hide");
                    
                    checkUncheckHelper(that.find("tbody > tr > td [id*='planCB']"), true);
                    checkUncheckHelper(allRowChildren.find("input[type='checkbox']"), true);
                    
                    allRowChildren.find("input[type='checkbox']").attr("disabled", "disabled");
                    
                    $("[id*='numbersOnly'][check-type='plan']").val(100).show();
                    $("[id*='numbersOnly']:not([check-type='plan'])").val(100).show();
                    $("span[id*='numbersOnly1']").text("100").hide();
                    
                    $("tr[scope='expandable-row']").find("[id*='numbersOnly']").on("keyup", function(e){
                        var currPercentage = ($(this).val() !== "") ? parseInt($(this).val(), 10) : 0;
                        var handleName = $(this).parents("tr[scope='expandable-row']").find("td:first-child").data("label");
                        var onlyThisGroup = $("tr[scope='expanded-content'][aria-expand-parent='"+handleName+"']");
                        
                        $(this).val(currPercentage);
                        onlyThisGroup.find("span[id*='numbersOnly1']").hide().text(currPercentage);
                        onlyThisGroup.find("input[type='text'][id*='numbersOnly']").val(currPercentage);
                        calculateRiskValue();
                    });
                    
                    allRowChildren.find("input[type='text'][id*='numbersOnly']").on("keyup", function(){
                        var currPercentage = ($(this).val() !== "") ? parseInt($(this).val(), 10) : 0;
                        var handleName = $(this).parent().parent().attr("aria-expand-parent");
                        var onlyThisGroup = $("tr[scope='expanded-content'][aria-expand-parent='"+handleName+"']");
                        $(this).val(currPercentage);
                        
                        calculatePlanPercentage(onlyThisGroup, $("td[data-label='"+handleName+"']").parent().find("input[type='text'][check-type='plan']"));
                        calculateRiskValue();
                    });
                }
                else{
                    $(".mfs_table_plus").removeClass("slds-hide");
                    $(".mfs_table_minus").addClass("slds-hide");
                    allRowChildren.addClass("slds-hide");   
                    
                    checkUncheckHelper(that.find("tbody > tr > td [id*='planCB']"), false);
                    checkUncheckHelper(allRowChildren.find("input[type='checkbox']"), false);
                    allRowChildren.find("input[type='checkbox']").removeAttr("disabled");
                    
                    $("[id*='numbersOnly'][check-type='plan']").val(0).show();
                    $("[id*='numbersOnly']:not([check-type='plan'])").val(0).show();
                    $("span[id*='numbersOnly1']").text("0").hide();
                    
                    $("tr[scope='expandable-row']").find("[id*='numbersOnly']").off("keyup");
                }
                
                calculateRiskValue();
            });
            
            if(isEditMode){
                $("input[type='text'][id*='numbersOnly']").on("keyup", function(){
                    var isPlan = $(this).attr("check-type") === "plan" ? true : false;
                    var currVal = ($(this).val() !== "") ? parseInt($(this).val(), 10) : 0;
                    
                    $(this).val(currVal);
                    
                    if(isPlan){
                        var handleName = $(this).parent().parent().find("td:first-child").data("label");
                        var allRowChildren = $("tr[scope='expanded-content'][aria-expand-parent='"+handleName+"']");
                        
                        allRowChildren.find("span[id*='numbersOnly']").hide().text(currVal);
                        allRowChildren.find("input[type='text'][id*='numbersOnly']").val(currVal);
                        allRowChildren.find("input[type='hidden'][id*='numbersOnly2']").val(currVal);
                    }
                    else{
                        var handleName = $(this).parent().parent().attr("aria-expand-parent");
                        var allRowChildren = $("tr[scope='expanded-content'][aria-expand-parent='"+handleName+"']");
                        
                        calculatePlanPercentage(allRowChildren, $("td[data-label='"+handleName+"']").parent().find("input[type='text'][check-type='plan']"));
                    }
                    
                    calculateRiskValueEdit();
                });
            }
        };
    };
    
    var invokePlugins = function(){
        $("table[scope='expandable-table']").expandableTables();
    };
    
    var checkUncheckHelper = function(checkboxes, checkOrUncheck){
        for(var i=0, iLen = checkboxes.length; i < iLen; i++){
            checkboxes[i].checked = checkOrUncheck;
            $(checkboxes[i]).prev().val(checkOrUncheck);
        }
    };
    
    var formatCurrency = function(n){
        return n.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');  
    };
    
    var extractNumbers = function(num){
        return parseInt(num.replace( /[^\d\.]*/g, ''));
    };
    
    var isPlanCheckbox = function(cb){
        var currID = cb.attr("id") ? cb.attr("id") : "";
        if(currID !== "" && currID.indexOf("planCB") !== -1){
            return true;
        }
        else{
            return false;
        }
    };
    
    var calculatePlanPercentage = function(allRows, planTB){
        var allRows = allRows.find("input[type='text'][check-type!='plan']");
        var totalPortfolioCount = allRows.length;
        var allPortFolioPerc = 0;
        
        for(var i=0, iLen = allRows.length; i < iLen; i++){
            allPortFolioPerc += $(allRows[i]).val() !== "" ? parseInt($(allRows[i]).val()) : 0;
        }
        
        planTB.val(parseInt(allPortFolioPerc / totalPortfolioCount));
    };
    
    var calculateRiskValue = function(){
        var table = $("table[scope='expandable-table'] tbody");
        var allCheckBoxes = table.find("input[type='checkbox']:checked");
        var totalValuesUser = 0;
        var totalValuesClient = 0;
        
        for(var i=0, iLen = allCheckBoxes.length; i < iLen; i++){
            if(!isPlanCheckbox($(allCheckBoxes[i])) ){
                var aumUser = extractNumbers($.trim($(allCheckBoxes[i]).parent().parent().find("td:nth-child(3)").text()));
                var aumClient = extractNumbers($.trim($(allCheckBoxes[i]).parent().parent().find("td:nth-child(4)").text()));
                var riskPercent = $(allCheckBoxes[i]).parent().parent().find("input[type='text'][id*='numbersOnly']:visible").val();
                
                totalValuesUser += (aumUser * riskPercent) / 100;
                totalValuesClient += (aumClient * riskPercent) / 100;
            }
        }
        
        $("span[id*='fields2:fields']").text(formatCurrency(totalValuesUser));
        $("span[id*='fields2:fields1']").text(formatCurrency(totalValuesClient));
    };
    
    var calculateRiskValueEdit = function(){
        var table = $("table[scope='expandable-table'] tbody");
        var allTextBoxes = table.find("input[type='text'][id*='numbersOnly']");
        var totalValuesUser = 0;
        var totalValuesClient = 0;
        
        for(var i=0, iLen = allTextBoxes.length; i < iLen; i++){
            var aumUser = extractNumbers($.trim($(allTextBoxes[i]).parent().parent().find("td:nth-child(3)").text()));
            var aumClient = extractNumbers($.trim($(allTextBoxes[i]).parent().parent().find("td:nth-child(4)").text()));
            var riskPercent = $(allTextBoxes[i]).val();
            
            totalValuesUser += (aumUser * riskPercent) / 100;
            totalValuesClient += (aumClient * riskPercent) / 100;
        }
        
        $("span[id*='fields']").text(formatCurrency(totalValuesUser));
        $("span[id*='fields1']").text(formatCurrency(totalValuesClient));
    };
    
    var _postRerenderActions = function(){
        $("table[scope='expandable-table']").expandableTables();
    };
    
    return {
        init : _init,
        postRerenderActions : _postRerenderActions
    };
}(jQuery);

j$(document).ready(function(){
    MFS_BAR_Table_Engine.init();
}); 

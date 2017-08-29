var MFS_BAR_Table_Engine_Retail = function($){
    var _init = function(){
        var isEditMode = ($("table[scope='expandable-table']").data("render-mode") && $("table[scope='expandable-table']").data("render-mode") === "edit") ? true : false;
        
        $("input[type='checkbox'][id*='planCB']").on("change", function(){
            if($(this).is(":checked")){
             	$(this).parent().parent().find("input[type='text'][id*='numbersOnly']").val(100);
                
                $("input[type='text'][id*='numbersOnly']").on("keyup", function(){
                    var currVal = ($(this).val() !== "") ? parseInt($(this).val(), 10) : 0;
                    $(this).val(currVal);
                    
                    calculateRiskValueRetail();
                });
            }
            else{
                $(this).parent().parent().find("input[type='text'][id*='numbersOnly']").val(0); 
                $("input[type='text'][id*='numbersOnly']").off("keyup");
            }
            
            calculateRiskValueRetail();
        });
        
        $(".sum-all").on("change", function(){
            if($(this).is(":checked")){
                checkUncheckHelper($("input[type='checkbox'][id*='planCB']"), true);
                $("input[type='text'][id*='numbersOnly']").val(100);
            }
            else{
                checkUncheckHelper($("input[type='checkbox'][id*='planCB']"), false);
                $("input[type='text'][id*='numbersOnly']").val(0);
            }
            
            calculateRiskValueRetail();
        });
        
        if(isEditMode){
            $("input[type='text'][id*='numbersOnly']").on("keyup", function(){
                var currVal = ($(this).val() !== "") ? parseInt($(this).val(), 10) : 0;
                $(this).val(currVal);
                
                calculateRiskValueRetail();
            });
        }
    };
    
    var calculateRiskValueRetail = function(){
        var table = $("table[scope='expandable-table'] tbody");
        var allTextBoxes = table.find("input[type='text'][id*='numbersOnly']");
        var totalValuesUser = 0;
        
        for(var i=0, iLen = allTextBoxes.length; i < iLen; i++){
            var aumUser = extractNumbers($.trim($(allTextBoxes[i]).parent().parent().find("td:nth-child(3)").text()));
            var riskPercent = $(allTextBoxes[i]).val();
            
            totalValuesUser += (aumUser * riskPercent) / 100;
        }
        
        $("span[id*='fields']").text(formatCurrency(totalValuesUser));
    };
    
    var checkUncheckHelper = function(checkboxes, checkOrUncheck){
        for(var i=0, iLen = checkboxes.length; i < iLen; i++){
            checkboxes[i].checked = checkOrUncheck;
            //$(checkboxes[i]).prev().val(checkOrUncheck);
        }
    };
    
    var formatCurrency = function(n){
        return n.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');  
    };
    
    var extractNumbers = function(num){
        return parseInt(num.replace( /[^\d\.]*/g, ''));
    };
    
    return {
        init : _init  
    };
}(jQuery);

j$(document).ready(function(){
    MFS_BAR_Table_Engine_Retail.init();
}); 
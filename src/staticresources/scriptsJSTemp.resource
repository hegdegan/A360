    $(document).ready(function(){
        initCustomPageBlockToggle();
    });
    
    var initCustomPageBlockToggle = function(){
    	$('.custom-page-block .custom-page-block-head img').on("click", function(){
            $(this).parents(".custom-page-block-head").next(".custom-page-block-body").find("table").toggle();
            
            if($(this).hasClass("showListButton")){
                $(this).removeClass("showListButton").addClass("hideListButton");
            }
            else{
                $(this).addClass("showListButton").removeClass("hideListButton");
            }
        });
    };
    
    function onlyOneEdit(){
        var inputCheckBox = document.getElementsByClassName("ChkBx");
        var count=0;
        for(var i=0; i<inputCheckBox.length; i++){
            if(inputCheckBox[i].type == "checkbox" && inputCheckBox[i].checked==true){
                count++;
            }
        }
        if(count>1){
            alert("Please select only one record. Only one record can be edited at a time");
            inputCheckBox.preventDefault();
        }
        if(count==0){
            alert("Select at least one record");
            inputCheckBox.preventDefault();
            
        }
        
    }
    function goToURL(flg , pgURL){
        var v = flg;
        var pgur = pgURL;
        if(v == false){
            window.open(pgur,"_self");
        }
    }
    
    function cursorWaiting(){
        console.log('---cursorWaiting');
        $('body').css('cursor', 'wait');
        }
    
    function cursorNormal(){
        console.log('---cursorLog');
        $('body').css('cursor', 'default');
        }
    
    
    function saveAndClose( returnId){
        if(sforce.console.isInConsole()){
            sforce.console.getEnclosingTabId(closeSubtab);
        }
         else{
                var url = '/' + returnId;
                window.open(url, "_self");
            }
    }
    
    var closeSubtab = function closeSubtab(result) {
            //Now that we have the tab ID, we can close it
            var tabId = result.id;
            sforce.console.closeTab(tabId, callback);
        };
    
    var callback = function () {
             if (result.error) {
		        alert("Error message is " + result.error);
             }
         };
    
    function openSendEmailTab(relatedTo, ContactName){
        var organizationId = relatedTo;
        var contact = ContactName;
        var emailURL = '/_ui/core/email/author/EmailAuthor?p3_lkid=' + organizationId + '&p2_lkid='+contact;
        window.open(emailURL);
        }
    
    function createSpeakerRequest(activityDetailId, startDate, endDate, parentWhoId, parentSubject ){
        var start = DateFormat.format.date(startDate,"MM/dd/yyyy hh:mm a");
        var end = DateFormat.format.date(endDate,"MM/dd/yyyy hh:mm a");
        var url = '/apex/MFS_RecordTypeSelectionPage?Id='+activityDetailId+'&start='+start+'&end='+end+'&contact='+parentWhoId
        +'&subject='+parentSubject;
        
        if(sforce.console.isInConsole()){
            OpenSpkrRequestPrimaryTab(url);
        }
        else{
            window.open(url);
        }
        }
    
    var setIndividualCellHeight = function(){
        var allRows = $(".custom-modal .modal-container .pbBody table tbody tr");
        console.log(allRows);
        
		for(var i=0, iLen = allRows.length ; i < iLen ; i++){
            /*if($(allRows[i]).find("select[multiple='multiple']").length > 0 ){
                var dataCol = $(allRows[i]).find("select[multiple='multiple']").parent();
                var labelCol = dataCol.prev();
                var rowHeight = $(allRows[i]).height();
                dataCol.height(rowHeight);
                labelCol.height(rowHeight);
            }
            else*/
            {
            	var dataCol = $(allRows[i]).find("td.dataCol");
                var labelCol = dataCol.prev();
                var rowHeight = $(allRows[i]).height();
                dataCol.height(rowHeight-30);
                labelCol.height(rowHeight-30);
            }
        }
    };
    
    var openModal = function(){
        $(".custom-modal .modal-container").slideDown("slow");
        $(".custom-modal .custom-modal-backdrop").show();
        
        var checkDatepickerAvailable = setInterval(function(){
            if($(".datePicker").length > 0){
            	$(".datePicker").css("position", "fixed");
                clearInterval(checkDatepickerAvailable);
            }
        }, 10);
    };
    
    var closeModal = function(){
        var isError = $(".errorMsg").length > 0 ? true : false;
        
        if(!isError){
            $(".custom-modal .modal-container").hide();
            $(".custom-modal .custom-modal-backdrop").hide();
        }
        
        $(".datePicker").css("position", "absolute");
    };
    
    var forceCloseModal = function(){
        $(".custom-modal .modal-container").hide();
        $(".custom-modal .custom-modal-backdrop").hide();
        $(".datePicker").css("position", "absolute");
    };
    
    var resizeModal = function(){
        var modalHeight = ($(window).height() * 80) / 100;
        var contentHeight = $(".popup_outputpanel").outerHeight(true) + 10;
        var maxHeight = (modalHeight > 750) ? 750 : modalHeight;
        
        if(contentHeight < maxHeight){
        	maxHeight = contentHeight;
        }
        
        setTimeout(function(){
            $(".modal-container").height(maxHeight);
        }, 500);
    };
    
    function speakerRequestEdit(Id){
        var url = '/'+Id;
        if(sforce.console.isInConsole()){
            OpenSpkrRequestPrimaryTab(url)
        }
        else{
         	window.open(url);   
        }
    }
    function OpenSpkrRequestPrimaryTab(url) {
        //Open a new primary tab with the salesforce.com home page in it
        sforce.console.openPrimaryTab(null, url, true, 'New Event Request:Select Event Request Record Type');
    }

    $(window).on("resize", function(){
    	resizeModal();
    });
    
    function checkMethodFieldValue(flag){
        var disableFields = flag;
        if(disableFields == "true"){
            $("select[data-lookup-name='event_loc']").attr('disabled',true);
            $("select[id*='activity_type']").attr("disabled", "disabled");
            $(".event-invitee-overlay").show();
        }
        else{
            $("select[data-lookup-name='event_loc']").removeAttr("disabled");
            $("select[id*='activity_type']").removeAttr("disabled");
            $(".event-invitee-overlay").hide(); 
        }
    }
var setScrollBarPosition = function(){
    var currElem    = $('.modal-container');
    var height = currElem[0].scrollHeight;
    currElem.scrollTop(height);
};
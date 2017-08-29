
        .secondaryPalette{
            border-top-color: #960032 !important;        
        }
		.tertiaryPalette{
       		background-color : #960032 !important;
       	}
        .textArea {
        width:90%;
        height:100px;
        }
        
        .custPopup{
        background-color: white;
        border-width: 2px;
        border-style: solid;
        left: 40%;
        padding:10px;
        position: relative;
        z-index:1;
        
        /* These are the 3 css properties you will need to change so the popup
        displays in the center of the screen. First set the width. Then set
        margin-left to negative half of what the width is. You can add
        the height property for a fixed size pop up if you want.*/
        
        width: 800px;
        margin-left: -250px;
        top:10px;
        }
        .popupBackground{
        background-color:black;
        opacity: 0.20;
        position: relative;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        }
        
        .custPopup2{
        background-color: white;
        border-width: 2px;
        border-style: solid;
        left: 40%;
        padding:10px;
        position: fixed;
        z-index:2;
        
        /* These are the 3 css properties you will need to change so the popup
        displays in the center of the screen. First set the width. Then set
        margin-left to negative half of what the width is. You can add
        the height property for a fixed size pop up if you want.*/
        
        width: 725px;
        margin-left: -215px;
        margin-top: 50px;
        top:10px;
        }
        .popupBackground2{
        background-color:black;
        opacity: 0.20;
        position: fixed;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        }
        
        .custom-page-block .custom-page-block-head{
            background:#960032;
            color:#FFF;
            padding:2px 5px;
        }
        .custom-page-block .custom-page-block-body{
            margin-bottom:16px;
        }
        
        .custom-page-block .custom-page-block-head img {
            margin-right: 4px;
            background-repeat: no-repeat;
            height: 11px;
            width: 11px;
            cursor:pointer;
        }
        .custom-page-block-body > table{width:100%;}
        .custom-page-block-body > table tbody tr > td{border-bottom: 1px solid #ececec;}
        .custom-page-block-body > table tbody tr > td:nth-child(2n+1){width:18%;text-align:right;padding:5px 0;font-weight:bold;font-size:91%;color:#4a4a56;}
        .custom-page-block-body > table tbody tr > td:nth-child(2n){width:32%;padding:5px 10px;}
        .custom-page-block-body .requiredInput{display:inline-block;height:auto;}
        .custom-page-block-body .requiredInput .dateOnlyInput .dateFormat{display:none;}
        .page-block-buttons-top input.btn:first-child{margin-left:328px !important;}
        .multi-select-container table.multiSelectPicklistTable{width:50%;}
        .multi-select-container table.multiSelectPicklistTable tbody .multiSelectPicklistRow td:nth-child(2n){width:auto;text-align:left;padding:0;}
        .multi-select-container table.multiSelectPicklistTable tbody .multiSelectPicklistRow td:nth-child(2n+1){width:auto;text-align:left;padding:0;}

        .custom-page-block-body select[multiple="multiple"] option{padding: 0;margin:0;text-indent:0;}
        .custom-page-block-body select[multiple="multiple"] option::before{display:none;} 
        
        .modal-container .bPageTitle{padding:0;}
        .modal-container .bPageTitle h1.pageType{margin-left:0;margin-top:0 !important;}
        .modal-container .bPageTitle .content{padding-left:0;}
        .modal-container .bPageTitle .content img.pageTitleIcon{display:none;}
        .inner-page-block div[id $= "pbCN"]{border-top:none;}
        div[id$="pbBtns"]{border-top:none;border-bottom:none !important;}
        div[id$="pbBtnsBtm"]{border-top:none !important;}
        select[multiple='multiple']{height:85px;}
        /* Pop Up */
        .custom-modal .modal-container{position:fixed;top:0;right:0;bottom:0;left:0;z-index:9001;display:none;margin:1% auto;width:70%;padding:30px;background:#FFF;border-radius:10px;height:405px;overflow:auto;}
        .custom-modal .custom-modal-backdrop{position:fixed;background:#333;opacity:0.6;z-index:9000;display:none;width:100%;height:100%;top:0;right:0;bottom:0;left:0;}
        
        .custom-modal .modal-container .responsive .pbBody table label{white-space: normal;overflow: hidden;text-overflow: ellipsis;}
        .custom-modal .modal-container .responsive .pbBody table .lookupInput{display:block;margin-top:5px;}
        .custom-modal .modal-container .responsive .pbBody table .multiSelectPicklistTable .multiSelectPicklistRow .multiSelectPicklistCell{vertical-align:top;}
        @media only screen and (min-width : 0px) and (max-width: 1580px){
        	.custom-modal .modal-container .responsive .pbBody table tbody,
        	.custom-modal .modal-container .responsive .pbBody table tbody tr{display:block;width:100%;text-align:left;overflow:hidden}
        	.custom-modal .modal-container .responsive .pbBody table tbody tr th.labelCol{display:block;width:30%;float:left;text-align:left;min-height:35px;}
        	.custom-modal .modal-container .responsive .pbBody table tbody tr td.dataCol{display:block;width:70%;float:left;text-align:left;min-height:35px;}
        	.custom-modal .modal-container .responsive .pbBody table label{display:inline;}
        	.custom-modal .modal-container .responsive .pbBody table .lookupInput{display:inline;}
        	.custom-modal .modal-container .responsive .pbBody table select{height:25px;}
        	.custom-modal .modal-container .responsive .pbBody table select[multiple="multiple"]{height:auto;}
        }
		
		.custom-modal .modal-container .not-responsive{width:1255px;}

        /* Pop Up Ends */
        
        .calendar-timings > span{display:inline-block;width:6.5%;}
        .disabled-output-field{display: inline-block;background: #FFF;border: 1px solid #aaa;opacity: 0.6;text-align: left;width: 85px;}
        .event-invitees-container{position:relative;}
        .event-invitees-container .event-invitee-overlay{position:absolute;top:0;left:0;width:100%;height:100%;background:#FFF;opacity:0.6;display:none;z-index:999;}
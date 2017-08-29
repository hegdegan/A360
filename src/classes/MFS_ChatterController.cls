/***************************************************************************************************
Apex Class Name    : MFS_ChatterController
Version            : 1.0 
Created Date       : 1 Nov 2016
Function           : This is a Controller showing chatter widget in A360 page
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Abhshek Tripathi            11/01/2016              Original Version
***************************************************************************************************/
public class MFS_ChatterController {
    public String recordId{get;set;}
    
    //Constructor
    public MFS_ChatterController()
    {
        recordId = Apexpages.currentPage().getParameters().get('id');
    }
}
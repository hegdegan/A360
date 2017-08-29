/***************************************************************************************************
Apex Class Name    : MFS_SalesAssetsWrapper 
Version            : 1.0 
Created Date       : 13 June 2016
Function           : Wrapper class to set the result set 
from the external objects/custom objects for Sales and assets data.
Modification Log   :
Interface used 	   : Comparable
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Manoj Parida              13/06/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_SalesAssetsWrapper implements Comparable{
    
    public String mdm_Id {get;set;}
    public String level {get;set;}
    public String productFamily {get;set;}
    public String productName {get;set;}
    public String shareClass {get;set;}
    public decimal ytd {get;set;}
    public decimal ytdRed {get;set;}
    public decimal ytdNet {get;set;}
    public decimal py {get;set;}
    public decimal pyRed {get;set;}
    public decimal aum {get;set;}
    public String externalId {get;set;}
    public String productId {get;set;}
    public String shareClassId {get;set;}
    public String planName {get;set;}
    public String portfolioName {get;set;}
    public String planId {get;set;}
    public String portfolioId {get;set;}
    public String strategyId {get;set;}
    public String strategyName {get;set;}
    public String vehicleId {get;set;}
    public String vehicleName {get;set;}
    public String orgId {get;set;}
    public String orgName {get;set;}
    public String productVehicle {get;set;}
    public String productVehicleId {get;set;}
    public String clientCurr {get;set;}
    public Integer row {get;set;}
    public String secondLevelGroup {get;set;}
    
    /**
* @Description : Method is used to sort MFS_SalesAssetsWrapper objects
* @Param : None
* @return: void
**/
    public Integer compareTo(Object obj) {
        Integer retVal = 0;
        try{
            MFS_SalesAssetsWrapper salesW = (MFS_SalesAssetsWrapper)obj;
            if(MFS_AllConstants.PageForSortSeq.equals(MFS_AllConstants.OrgInsSalesPage)){
                retVal = getYtdAndPYSorted(salesW);
                if(retval != 0){
                    return retval;
                }else{
                    Integer planComp = planName!=null?planName.compareTo(salesW.planName):''.compareTo(salesW.planName);        
                    if(planComp == 0){ 
                        Integer pfComp = portfolioName != null?portfolioName.compareTo(salesW.portfolioName):''.compareTo(salesW.portfolioName);            
                        return pfComp;   
                    } else return planComp; 
                }
                
            } else if(MFS_AllConstants.PageForSortSeq.equals(MFS_AllConstants.OrgConSalesPage)){
                retVal = getYtdAndPYSorted(salesW);
                if(retval != 0){
                    return retval;
                }else{
                    Integer strComp = productName!=null?productName.compareTo(salesW.productName):''.compareTo(salesW.productName);        
                    if(strComp == 0){ 
                        system.debug(productName+' '+salesW.productName+' '+salesW);
                        Integer vhComp = vehicleName != null?vehicleName.compareTo(salesW.vehicleName):''.compareTo(salesW.vehicleName);     
                        if(vhComp == 0){
                            Integer orgComp = orgName!=null?orgName.compareTo(salesW.orgName):''.compareTo(salesW.orgName);
                            return orgComp; 
                        } else return vhComp;       
                    } else return strComp; 
                }                    
            } else {
                retval = getYtdAndPYSorted(salesW);
                if(retval != 0){
                    return retval;
                }else {
                    Integer prVhComp = productVehicle!=null?productVehicle.compareTo(salesW.productVehicle):''.compareTo(salesW.productVehicle);        
                    if(prVhComp == 0){              
                        Integer prComp = productName!=null?productName.compareTo(salesW.productName):''.compareTo(salesW.productName);               
                        if(prComp == 0){                
                            Integer shClComp = shareClass!=null?shareClass.compareTo(salesW.shareClass):''.compareTo(salesW.shareClass);                  
                            return shClComp;                
                        } else return prComp;            
                    } else return prVhComp;  
                }
            }
        } catch(Exception e){
            system.debug('Exception in : '+e.getStackTraceString());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.Generic_Error);
            ApexPages.addMessage(myMsg);
            throw e;
        }
        return 0;
    } 
    
    private Integer getYtdAndPYSorted(MFS_SalesAssetsWrapper salesW){
        if(ytd > salesW.ytd) return -1;
        if(ytd < salesW.ytd) return 1;
        if(ytd == salesW.ytd){
            if(py > salesW.py) return -1;
            if(py < salesW.py) return 1;
            if(py == salesW.py) return 0;            
        }
        return 0;
    }
}
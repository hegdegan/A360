/***************************************************************************************************
Apex Class Name    : MFS_CaseSchedulerController 
Version            : 1.0 
Created Date       : 08 June 2016
Function           : Class is used to create recurring case on case object.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey               08/06/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_CaseSchedulerController {
    private Case cse;
    public boolean isNotRecurr{get;set;}
    public List<BusinessHours> allBusinessHoursHours;   
    public List<SelectOption> bhOptions{get;set;} 
    public static String userBhours{get;set;}
    public String selectedQuarter{get;set;}
    private Final String WEEKLY='Weekly';
    private Final String QUARTERLY='Quarterly';
    private Final String MONTHLY='Monthly';
    //Constructor
    public MFS_CaseSchedulerController(ApexPages.StandardController controller) 
    {
        
        try{
            Map<String, Integer> monthMap = New Map<String, Integer>{'January'=>1, 'February' => 2, 'March'=>3, 'April' =>4, 'May'=>5, 'June'=>6, 'July'=>7, 'August'=>8, 'September'=>9, 'October'=>10, 'November'=>11, 'December'=>12};
            cse = (Case)controller.getRecord();
            allBusinessHoursHours = new  List<BusinessHours>();
            Case saveCase = [select Parent_Case_Number__c, ownerId from Case where ID =:cse.id ];
            if(saveCase.Parent_Case_Number__c != null)
            {
                isNotRecurr = true;
            }
            //New Change - UAT
            cse.Excludes_Weekends__c = MFS_ALLConstants.Default_Days;
            allBusinessHoursHours = [select Id, Name, TimeZoneSidKey from BusinessHours where isActive = true];
            getBusinessHoursptions(allBusinessHoursHours);
            userBhours = returnUserAddress(saveCase.ownerId);
            
            if(cse.Repeats__c==QUARTERLY){
               // if(cse.start_date__c!=NULL){
                    if(cse.start_date__c.month()==1){
                        selectedQuarter='Beginning';
                    }
                    else{
                        selectedQuarter='End';
                        
                    }
               // }
            }
            DateTime dt=DateTime.now();
            Date day=Date.today();
        if(cse.start_month__c==null){
            cse.start_month__c=dt.format('MMMM');
        }
       
            
        }catch(Exception e)
        {
            System.debug('Exception:'+e.getStackTraceString());
        }
    }

    /**
    * @Description : Method is used to get all Business Hours
    * @Param : list<BusinessHours>
    * @return: void
    **/
    public void getBusinessHoursptions(List<BusinessHours> allBusinessHoursHours) {
        bhOptions=new list<SelectOption>();
        for(BusinessHours bh : allBusinessHoursHours){
            bhOptions.add(new SelectOption(bh.Name,bh.Name));
        }        
    }
    
    /**
    * @Description : Method is used to get the address of the logged in user
    * @Param : ID useriD
    * @return: sTRING
    **/
    public String returnUserAddress(Id OwnerId){
        String userAddress = '';
        try{
        User add = [select Country,City,MFS_Location__c from User where Id =:OwnerId];
        
        
        if(add.MFS_Location__c != null)
        {
            userAddress = add.Country + ' ' + '(' + add.MFS_Location__c+ ')'; 
        }else
        {
            userAddress = add.Country;
        }
        }
        catch(Exception e){
             System.debug('Exception:'+e.getStackTraceString());
        }
        return userAddress;
    }
    
 
    /**
* @Description : Method is used to start recurring case from Recurring Case button.
* @Param : N/A
* @return: PageReference
**/
    public Pagereference save()
    {
        PageReference pr;
        Map<String, Integer> monthMap = New Map<String, Integer>{'January'=>1, 'February' => 2, 'March'=>3, 'April' =>4, 'May'=>5, 'June'=>6, 'July'=>7, 'August'=>8, 'September'=>9, 'October'=>10, 'November'=>11, 'December'=>12};
        
        try
        {
            
            if(cse.Repeats__c!=WEEKLY && cse.Repeats__C!=QUARTERLY){
                Integer month;
                if(cse.start_Day__c!=NULL && cse.start_Month__c!=NULL){
                    if(monthMap.containsKey(cse.start_month__c)){
                        month=monthMap.get(cse.start_month__c);
                    }
                    
                    list<String>daylist=cse.start_day__c.split(';');
                    Integer day=Integer.valueOf(dayList[0]);
                    Date currentDate=date.today();
                    Integer year=currentDate.year();
                    cse.Start_Date__c=Date.newInstance(year,month,day);
                    
                }
                else if(cse.start_Day__c==NULL || cse.start_Month__c==NULL){
                    cse.start_date__C=NULL;
                }
            }
                if(cse.Repeats__c==QUARTERLY){
                    cse.start_date__c=getStartDateForQuarter(selectedQuarter);
                   
                }
            
           
             if(cse.Start_Month__c==null && (cse.Repeats__c!=WEEKLY && cse.repeats__c!=QUARTERLY)){
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Start Month should not be blank'));
                 return null;
            }
            if(cse.Start_Day__c==null && (cse.Repeats__c!=WEEKLY && cse.repeats__c!=QUARTERLY)){
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Start Day should not be blank'));
                 return null;
            }
           if(cse.Repeats__c!=WEEKLY && cse.repeats__c!=QUARTERLY ){
                if(cse.start_month__c!=NULL && cse.start_day__c!=NULL){
                    if((cse.start_month__c=='April' || cse.start_month__c=='February' || cse.start_month__c=='June' || cse.start_month__c=='September' || cse.start_month__c=='November') && cse.start_Day__c.contains('31')){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' 31 is not valid day in '+cse.start_month__c));
                        return null;
                    }
                    if(cse.start_month__c=='February' && cse.start_Day__c.contains('30')){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' 30 is not valid day in '+cse.start_month__c));
                        return null;
                    }
                    if(cse.start_month__c=='February' && cse.start_Day__c.contains('29') && !Date.isLeapYear(Date.today().year())){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' 29 is not valid day in '+cse.start_month__c));
                        return null;
                    }
                    
                }
           }
            if(cse.Start_Date__c < System.Today())
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Start_Date_Not_Past));
            }else if(cse.Repeats__c == MFS_AllConstants.RepeatsWeekly && cse.Repeat_On_Weekly__c == null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Repeat_Day_Not_Populated));
            }else if(cse.Ends__c == null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Rec_End_Blank));
            }else if((cse.Due_In__c != null && cse.Excludes_Weekends__c == null) || (cse.Due_In__c == null && cse.Excludes_Weekends__c != null))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Due_Not_Populated));
            }else if((cse.Ends__c == MFS_AllConstants.EndsOn && cse.Ends_On__c == null) || (cse.Ends__c == 'On' && cse.Ends_On__c < cse.Start_Date__c) )
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_End_Date_Blank));
            }else if(cse.Ends__c == MFS_AllConstants.EndsAfter && cse.Occurrence_Number__c == null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Occ_Num_Blank));
            }else if(cse.Repeats__c == MFS_AllConstants.RepeatsMonthly && cse.Ends__c == MFS_AllConstants.EndsOn && cse.Ends_On__c < cse.Start_Date__c.addMonths(MFS_AllConstants.Add_1_Month))
            {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Ends_On_after_a_month));
            }else if(cse.Repeats__c == MFS_AllConstants.RepeatsQuarterly && cse.Ends__c == MFS_AllConstants.EndsOn && cse.Ends_On__c < cse.Start_Date__c.addMonths(MFS_AllConstants.Add_3_Months))
            {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Ends_on_after_a_quarter));
            }else if(cse.Repeats__c == MFS_AllConstants.RepeatsSemiAnnual && cse.Ends__c == MFS_AllConstants.EndsOn && cse.Ends_On__c < cse.Start_Date__c.addMonths(MFS_AllConstants.Add_6_Months))
            {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Ends_on_after_a_SemiAnnual));
            }else if(cse.Repeats__c == MFS_AllConstants.RepeatsAnnual && cse.Ends__c == MFS_AllConstants.EndsOn && cse.Ends_On__c < cse.Start_Date__c.addMonths(MFS_AllConstants.Add_12_Months))
            {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Ends_on_after_a_Year));
            }else if(cse.Repeats__c == MFS_AllConstants.RepeatsWeekly && cse.Ends__c == MFS_AllConstants.EndsOn && cse.Ends_On__c < cse.Start_Date__c.addDays(MFS_AllConstants.Add_7_Days))
            {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Ends_on_after_a_week));
            }else
            {
                Case saveCase = [select OwnerId, Total_No_of_Occurrences__c from Case where ID =:cse.id ];
                saveCase.Repeats__c = cse.Repeats__c;
                saveCase.Ends__c = cse.Ends__c;
                saveCase.Repeat_On_Weekly__c = cse.Repeat_On_Weekly__c; 
                saveCase.Start_Date__c = cse.Start_Date__c;
                saveCase.Due_In__c = cse.Due_In__c;
                saveCase.Due_Date__c = populateDueDate(saveCase.OwnerId,cse.Start_Date__c,Integer.valueOf(cse.Due_In__c),cse.Excludes_Weekends__c);
                SaveCase.Excludes_Weekends__c = cse.Excludes_Weekends__c;
                saveCase.Occurrence_Number__c = cse.Occurrence_Number__c;
                saveCase.Ends_On__c = cse.Ends_On__c;
                saveCase.Start_month__c=cse.start_month__c;
                
                
                saveCase.start_day__c=cse.start_day__c;
                
                String isCalled = 'Controller';
                
                if(saveCase.Repeats__c != MFS_AllConstants.RepeatsWeekly && saveCase.Repeats_On__c==NULL)
                {
                    saveCase.Repeats_On__c = calculateNextCaseDate(cse.Repeats__c,cse.Start_Date__c,cse.start_month__c,cse.start_day__C,cse.repeats_on__c);   
                }else
                {
                    saveCase.Repeats_On__c = calculateNextCaseDateWeekly(cse.Start_Date__c,cse.Repeat_On_Weekly__c,isCalled); 
                }
                saveCase.Number_of_Occurrence__c = calculateOccurrence(Integer.valueOf(saveCase.Total_No_of_Occurrences__c),Integer.valueOf(cse.Occurrence_Number__c),cse.Ends__c,cse.Repeats__c,cse.Ends_On__c,cse.Start_Date__c,saveCase.Repeats_On__c);
                if(saveCase.Ends__c == MFS_AllConstants.EndsNever || saveCase.Ends__c == MFS_AllConstants.EndsAfter)
                {
                    saveCase.Ends_On__c = null;
                }
                if(saveCase.Ends__c == MFS_AllConstants.EndsNever || saveCase.Ends__c == MFS_AllConstants.EndsOn)
                {
                    saveCase.Occurrence_Number__c = null;
                }
                update saveCase;
                
                pr = new PageReference('/'+cse.id);
                
            } 
        }
        Catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Case_Controller_Error+e.getMessage()));
        }
        
        return pr;        
    }
    
        /**
* @Description : Method is used to get Start date based on Beginning/End of Quarter
* @Param : N/A
* @return: PageReference
**/
  public Date getStartDateForQuarter(String selectedQuarter){
      Date stDate;
    Date currentDate=date.today();
    try{
    
    if(selectedQuarter!=NULL){
     if(date.Today()<Date.newInstance(currentDate.year(),3,31)){
      if(selectedQuarter=='Beginning'){
        stDate=Date.NewInstance(currentDate.year(),4,1);
      }
      else{
        stDate=Date.NewInstance(currentDate.year(),3,31);
      }
    }
    else if(date.Today()>=Date.newInstance(currentDate.year(),3,31) && date.Today()<Date.newInstance(currentDate.year(),6,30)){
      if(selectedQuarter=='Beginning'){
        stDate=Date.NewInstance(currentDate.year(),7,1);
      }
      else{
        stDate=Date.NewInstance(currentDate.year(),6,30);
      }
    }
    else if(date.Today()>=Date.newInstance(currentDate.year(),6,30) && date.Today()<Date.newInstance(currentDate.year(),9,30)){
      if(selectedQuarter=='Beginning'){
        stDate=Date.NewInstance(currentDate.year(),10,1);
      }
      else{
        stDate=Date.NewInstance(currentDate.year(),9,30);
      }
    }
    else if(date.Today()>=Date.newInstance(currentDate.year(),9,30) && date.Today()<Date.newInstance(currentDate.year(),12,31)){
      if(selectedQuarter=='Beginning'){
        stDate=Date.NewInstance(currentDate.year()+1,1,1);
      }
      else{
        stDate=Date.NewInstance(currentDate.year(),12,31);
      }
    }
    }
    else{
      stDate=NULL;
    }
    }
    catch(Exception e){
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Case_Controller_Error+e.getMessage()));

    }
    return stDate;
  }
  
    /**
* @Description : Method is used to calculate number of occurence of child case.
* @Param : Total Number Of Occurence,Occurrence Number, Ends, Repeats,Ends On,Start Date
* @return: String
**/
    public Static String calculateOccurrence(Integer totNumOcc,Integer occNum,String Ends,String repeats,Date endsOn,Date startDate,Date repeatsOn)
    {
        String numOfOccurrence;
        Integer occCounter = 0;
        
        try
        {
            if(totNumOcc == null){
                totNumOcc = 0; 
            }
            if(Ends == MFS_AllConstants.EndsNever)
            {
                numOfOccurrence = totNumOcc + ' of Never Ends';
            }else
            {
                if(occNum != null && Ends == MFS_AllConstants.EndsAfter)
                {
                    numOfOccurrence = totNumOcc + ' of ' + occNum;
                }else
                {
                    if(repeats == MFS_AllConstants.RepeatsWeekly)
                    {
                       for(Date strtDate = repeatsOn.addDays(MFS_AllConstants.Add_0_Days); strtDate <= endsOn;strtDate=strtDate.addDays(MFS_AllConstants.Add_7_Days))
                        {
                            occCounter++;
                        } 
                       numOfOccurrence = totNumOcc + ' of ' + occCounter;
                    }
                    if(repeats == MFS_AllConstants.RepeatsMonthly)
                    {
                        for(Date strtDate = startDate.addMonths(MFS_AllConstants.Add_1_Month); strtDate <= endsOn;strtDate=strtDate.addMonths(MFS_AllConstants.Add_1_Month))
                        {
                            occCounter++;
                        } 
                        numOfOccurrence = totNumOcc + ' of ' + occCounter;
                    }
                    if(repeats == MFS_AllConstants.RepeatsQuarterly)
                    {
                        for(Date strtDate = startDate.addMonths(MFS_AllConstants.Add_3_Months); strtDate <= endsOn;strtDate=strtDate.addMonths(MFS_AllConstants.Add_3_Months))
                        {
                            occCounter++;
                        }
                        numOfOccurrence = totNumOcc + ' of ' + occCounter;
                    }
                    if(repeats == MFS_AllConstants.RepeatsSemiAnnual)
                    {
                        for(Date strtDate = startDate.addMonths(MFS_AllConstants.Add_6_Months); strtDate <= endsOn;strtDate=strtDate.addMonths(MFS_AllConstants.Add_6_Months))
                        {
                            occCounter++;
                        }
                        numOfOccurrence = totNumOcc + ' of ' + occCounter;
                    }
                    if(repeats == MFS_AllConstants.RepeatsAnnual)
                    {
                        for(Date strtDate = startDate.addMonths(MFS_AllConstants.Add_12_Months); strtDate <= endsOn;strtDate=strtDate.addMonths(MFS_AllConstants.Add_12_Months))
                        {
                            occCounter++;
                        }
                        numOfOccurrence = totNumOcc + ' of ' + occCounter;
                    }
                    
                }  
            }  
        }Catch(Exception e)
        {
            System.debug('Exception:'+e.getStackTraceString());  
        }
        
        return numOfOccurrence;
    }
    
    /**
* @Description : Method is used to end recurring case from End Now button.
* @Param : N/A
* @return: PageReference
**/
    Public PageReference endNow()
    {
        Pagereference pr;
        Case saveCase = [select Repeats__c,Recurring_Case__c,Start_Month__c,Start_Day__c,Number_of_Occurrence__c,Start_Date__c,Repeats_On__c,Ends__c,Ends_On__c,Due_In__c,Excludes_Weekends__c,Occurrence_Number__c,Total_No_of_Occurrences__c from Case where ID =:cse.id ];
        
        try
        {
            if(saveCase.Recurring_Case__c == false)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RC_Not_Rec_Case));
            }else
            {
                saveCase.Repeats__c = null;
                saveCase.Repeats_On__c = null;
                saveCase.Start_Date__c = System.today();
                saveCase.Ends__c = null;
                saveCase.Ends_On__c = null;
                saveCase.Due_In__c = null;
                saveCase.Excludes_Weekends__c = null;
                saveCase.Occurrence_Number__c = null;
                saveCase.Total_No_of_Occurrences__c = null;
                savecase.Number_of_Occurrence__c = null;
                saveCase.Start_month__c=NULL;
                saveCase.start_Day__c=NULL;
                update saveCase;
                pr = new PageReference('/'+cse.id);
            }  
        }Catch(Exception e)
        {
            System.debug('Exception:'+e.getStackTraceString());
        }
        
        return pr; 
    }
    
    /**
* @Description : Method is used to show summary on recurring page.
* @Param : N/A
* @return: String
**/
    public string getsummary()
    { 
        
        String summary;
        Map<String, Integer> monthMap = New Map<String, Integer>{'January'=>1, 'February' => 2, 'March'=>3, 'April' =>4, 'May'=>5, 'June'=>6, 'July'=>7, 'August'=>8, 'September'=>9, 'October'=>10, 'November'=>11, 'December'=>12};
        Map<String,String>dayMap=new map<String,String>{'1'=>'1st','2'=>'2nd','3'=>'3rd','4'=>'4th','5'=>'5th','6'=>'6th','7'=>'7th','8'=>'8th','9'=>'9th','10'=>'10th','11'=>'11th','12'=>'12th','13'=>'13th','14'=>'14th','15'=>'15th','16'=>'16th','17'=>'17th','18'=>'18th','19'=>'19th','20'=>'20th','21'=>'21st','22'=>'22nd','23'=>'23rd','24'=>'24th','25'=>'25th','27'=>'27th','28'=>'28th','29'=>'29th','30'=>'30th','31'=>'31st'};
        try
        {
            String daySelected;
           if(cse.Repeats__c!=WEEKLY && cse.Repeats__C!=QUARTERLY && cse.Repeats__c!=NULL){
                Integer month;
                
                if(monthMap.containsKey(cse.start_Month__c)){
                    month=monthMap.get(cse.start_month__c);
                }
                 list<String>dayList;
               if(cse.start_Day__c!=null && cse.start_day__c!=''){
                dayList=cse.start_day__c.split(';');
                if(dayList.size()>0){
                for(String day:dayList){
                    IF(String.isBlank(daySelected) ){
                        if(dayMap.containsKey(day)){
                            daySelected=dayMap.get(day);
                        }
                    }
                    else{
                        if(dayMap.containsKey(day)){
                            daySelected+=', '+dayMap.get(day);
                        }
                    }
                }
                Integer day=Integer.valueOf(daylist[0]);
                Date currentDate=date.today();
                Integer year=currentDate.year();
                cse.Start_Date__c=Date.newInstance(year,month,day);
                }
               }
            }   
            if(cse.Repeats__c==QUARTERLY){
        cse.start_date__c=getStartDateForQuarter(selectedQuarter);
                   
            }
            if(cse.Start_Date__c!=null)
            {
                DateTime dt = DateTime.newInstance(cse.Start_Date__c, time.newInstance(0,0,0,0));
                String month = dt.format('MMMM');
                if(cse.Repeats__c == null)
                {
                    summary = '';
                }else
                {
                    if(cse.Repeats__c == MFS_AllConstants.RepeatsWeekly && cse.Repeat_On_Weekly__c != null)
                    {
                        summary = cse.Repeats__c + ' on ' + cse.Repeat_On_Weekly__c + ', Starts from ' + dayMap.get(String.valueOf(cse.Start_Date__c.day())) + ' ' + month;
                    }else if(cse.Repeats__c==QUARTERLY)
                    {
                        summary = cse.Repeats__c + ' on ' + cse.Start_Date__c.day() + ', Starts from ' + dayMap.get(String.valueOf(cse.Start_Date__c.day())) + ' ' + month; 
                    }
                    else if(cse.Repeats__C!=WEEKLY  && cse.Repeats__c!=QUARTERLY){
                        
                        if(cse.start_month__c!=null && (cse.start_day__c==null || cse.start_day__c=='')){
                            summary=cse.Repeats__c +' on '+cse.Start_Month__c;
                        }
                        if((cse.start_month__c=='April' || cse.start_month__c=='February' || cse.start_month__c=='June' || cse.start_month__c=='September' || cse.start_month__c=='November') && cse.start_Day__c.contains('31')){
                       summary='31 is not a valid date for '+cse.start_month__c;
                    }
                    else if(cse.start_month__c=='February' && cse.start_Day__c.contains('30')){
                        summary='30 is not a valid date for February';
                    }
                    else if(cse.start_month__c=='February' && cse.start_Day__c.contains('29') && !Date.isLeapYear(Date.today().year())){
                        summary='29 is not a valid date for February';
                    }
                    else if(cse.start_month__c!=null && (cse.start_day__c!=null && cse.start_day__c!='')){
                        summary=cse.Repeats__c + ' on '+ daySelected + ' of '+ cse.start_Month__c;
                    }
                    }
                }
            }
        }Catch(Exception e)
        {
            System.debug('Exception:'+e.getStackTraceString()); 
        }
        
        return summary;
    }
    
    /**
* @Description : Method is used to calculate next date for creating child case.
* @Param : Repeats, Start Date
* @return: Date
**/
    public static Date calculateNextCaseDate(String repeats,Date repeatDate,String month,String day,Date repeatsOnDate)
    {
        Map<String, Integer> repeatsMap = New Map<String, Integer>{'Monthly'=>1, 'Quarterly' => 3, 'Semi Annual'=>6, 'Annual' =>12};
            Date newDate;
         Map<String, Integer> monthMap = New Map<String, Integer>{'January'=>1, 'February' => 2, 'March'=>3, 'April' =>4, 'May'=>5, 'June'=>6, 'July'=>7, 'August'=>8, 'September'=>9, 'October'=>10, 'November'=>11, 'December'=>12};  
            
            
        try
        {
            if(repeats=='Weekly' || repeats=='Quarterly'){
                Date dt = repeatDate;
                Integer startDay = dt.day();
                newDate = dt.addMonths(repeatsMap.get(repeats)); 
            }
            else{
                list<String>dayList=day.split(';');
                Date dt = repeatDate;
                list<Integer>tempList=new list<Integer>();
                Integer startDay = dt.day();
                if(repeatsOnDate==NULL){
                    for(String s:daylist){
                        if(Integer.valueOf(s)>startDay){
                            tempList.add(Integer.valueOf(s));
                        }
                    }
                    tempList.sort();
                    if(tempList.isEmpty()){
                        
                        newDate=dt.addMonths(repeatsMap.get(repeats));
                        Integer i=2;
                        while(newDate.day()!=startDay){
                            newDate=dt.addmonths(repeatsMap.get(repeats)*i);
                            i++;
                        }
                        
                    }
                    else{
                        newDate=Date.newInstance(repeatDate.year(),monthMap.get(Month),tempList[0]);
                        
                    }
                }
                else{
                    for(String s:dayList){
                        tempList.add(Integer.valueOf(s));
                    }
                    tempList.sort();
                    list<Integer>newList=new list<Integer>();
                    for(Integer i:tempList){
                        if(i>repeatsOnDate.Day()){
                            newList.add(i);
                            
                            
                        }
                        
                        
                    }
                    
                    if(!newList.isEmpty()){
                        newList.sort();
                        
                        for(Integer i:newList){
                            
                           // newDate=Date.newInstance(repeatsOnDate.year(),repeatsOnDate.Month(),i);
                            if(i>Date.DaysinMonth(repeatsOnDate.year(),repeatsOnDate.Month())){
                                Date tempdate=Date.newInstance(repeatsOnDate.year(),repeatsOnDate.Month(),tempList[0]);
                                newDate=tempDate.addMonths(repeatsMap.get(repeats));
                                break;
                            }
                            else{
                                newDate=Date.newInstance(repeatsOnDate.year(),repeatsOnDate.Month(),i);
                                break;
                            }
                            
                        }
                        
                    }
                    else{
                        Date tempDate=Date.newInstance(repeatsOnDate.year(),repeatsOnDate.Month(),repeatDate.day());
                        newDate=tempDate.addMonths(repeatsMap.get(repeats));
                        Integer i=2;
                        if(((repeatsOnDate.Month()==2 || repeatsOnDate.Month()==4 || repeatsOnDate.Month()==6 || repeatsOnDate.Month()==9 || repeatsOnDate.Month()==11)&& repeatDate.Day()==31) || (repeatsOnDate.Month()==2 && repeatDate.Day()==30) || (repeatsOnDate.Month()==2 && !Date.isLeapYear(repeatsOnDate.year()) && repeatDate.Day()==29) ){
                            while(newDate.day()!=repeatsOnDate.day()){
                                newDate=repeatsOnDate.addmonths(repeatsMap.get(repeats)*i);
                                i++;
                            }
                        }
                        
                    }
                
                }
            }
        
        }Catch(Exception e)
        {
            System.debug('Exception:'+e.getStackTraceString());
        }
        
        return newDate;
    }
    
    /**
* @Description : Method is used to calculate next date Weekly for creating child case.
* @Param : Start Date, Repeat on Weekly
* @return: Date
**/
    public static Date calculateNextCaseDateWeekly(Date startDate,String repeatsOn,String isCalled)
    {
        Map<String, Integer> repeatsMap = New Map<String, Integer>{'Sunday'=>1, 'Monday' => 2, 'Tuesday'=>3, 'Wednesday' =>4, 'Thursday'=>5, 'Friday'=>6, 'Saturday'=>7};
            DateTime dt = DateTime.newInstance(Date.Today(), time.newInstance(0,0,0,0));
        Date newDate = startDate;
        String dayOfWeek = dt.format('EEEE');
        
        try
        {
            if(dayOfWeek.equals(repeatsOn) || isCalled == 'Batch'){
                if(startDate == System.Today() || isCalled == 'Batch')
                    newDate = System.Today().addDays(MFS_AllConstants.Add_7_Days);
                else
                    newDate = newDate.addDays(MFS_AllConstants.Add_0_Days);
            }else if(repeatsMap.get(dayOfWeek) < repeatsMap.get(repeatsOn) )
            {
                newDate = newDate.addDays(repeatsMap.get(repeatsOn) - repeatsMap.get(dayOfWeek) );
            }
            else
            {
                newDate = newDate.addDays(MFS_AllConstants.Add_7_Days + (repeatsMap.get(repeatsOn) - repeatsMap.get(dayOfWeek)));
            } 
        }catch(Exception e)
        {
            System.debug('Exception:'+e.getStackTraceString());
        }
        return newDate;
    }
    
    /**
* @Description : Return days for Weekly picklist value
* @Param : N/A
* @return: List<Selectoption>
**/
    public List<SelectOption> getDays()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Sunday',Label.RC_Sunday));
        options.add(new SelectOption('Monday',Label.RC_Monday));
        options.add(new SelectOption('Tuesday',Label.RC_Tuesday));
        options.add(new SelectOption('Wednesday',Label.RC_Wednesday));
        options.add(new SelectOption('Thursday',Label.RC_Thursday));
        options.add(new SelectOption('Friday',Label.RC_Friday));
        options.add(new SelectOption('Saturday',Label.RC_Saturday));
        return options;
    }
    
    /**
* @Description : Method is used to populate due date on case object
* @Param : OwnerId, Start Date, Due In, Excude Weekends
* @return: Date
**/
    public Static Date populateDueDate(Id caseOwner,Date strtDate,Integer dueIn,String workDay)
    {
        User add = [select Country,City from User where Id =:caseOwner];
        String userAddress;
        Date newDueDate = strtDate;
        
        if(add.City != null)
        {
            userAddress = add.Country + ' ' + '(' + add.City + ')'; 
        }else
        {
            userAddress = add.Country;
        }
        
        try
        {
            if(dueIn != null && workDay == MFS_AllConstants.BusinessDays)
            {
                DateTime startDate = DateTime.newInstance(strtDate.Year(),strtDate.month(),strtDate.day());
                List<BusinessHours> bHours = new  List<BusinessHours>();
                bHours = [select Id,Name from BusinessHours where Name =: userBhours Limit 1];
                if(bHours.size()>0)
                {
                    DateTime dueDate = BusinessHours.addGMT(bHours[0].Id,startDate,Integer.valueOf(dueIn)*24*60*60*1000);
                    newDueDate = duedate.Date(); 
                }else
                {
                    BusinessHours defHours = [select Id,Name from BusinessHours where isDefault =: true];
                    DateTime dueDate = BusinessHours.addGMT(defHours.Id,startDate,Integer.valueOf(dueIn)*24*60*60*1000);
                    newDueDate = duedate.Date();
                }
            }else
            {
                newDueDate = newDueDate.addDays(dueIn);
            }
            return newDueDate;
        }catch(Exception e)
        {
            System.debug('Exception:'+e.getStackTraceString());
            return null;
        }
        
        
    }
    
    
       /**
* @Description : Method is used to get the left side values of Start Day Field in lightning
* @Param : None
* @return: String
**/
    public  String getStartDay(){
    
        String options = '';
        Set<String> valuesFromSchema = new Set<String>();
        Schema.DescribeFieldResult fieldResult;
        try{
                String values=cse.Start_Day__c;
                //fieldResult=Case.Start_Day__c.getDescribe();
            for(Integer i=1;i<=31;i++){
                if(cse.start_month__c=='February' && i>28){
                    break;
                }
                else if((cse.start_month__c=='April' || cse.start_month__c=='June' || cse.start_month__c=='September' || cse.start_month__c=='November') && i>30){
                    break;
                }
                valuesFromSchema.add(String.valueOf(i));
            }
           
            /*List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                valuesFromSchema.add(f.getLabel());
            }*/
            
            Set<String> valuesToDisplay = new Set<String>(valuesFromSchema);
            if(!String.isEmpty(values)){
                 List<String> tempList = new List<String>(values.split(';'));
                Set<String> selectedlang = new Set<String>(tempList);
                valuesToDisplay.clear();
                
                for(String schmaValue : valuesFromSchema){
                    if(!selectedLang.contains(schmaValue)) 
                        valuesToDisplay.add(schmaValue);
                }
               
            }
            
            for(String val : valuesToDisplay){
                
                    if(String.isEmpty(options))
                        options = val; 
                    else
                        options = options+','+val;
                
                
            }
        } catch(Exception ex){
            System.debug('Exception in getStartDay :'+ex.getStackTraceString());
            throw ex;
        }
        return options;
    }
       /**
* @Description : Method is used to get the right side values for Start Day Field in Lightning
* @Param : None
* @return: String
**/
    public  String getSelectedStartDay(){
        String options = '';
        Set<String> valuesToDisplay = new Set<String>();
        try{
            String values=cse.start_day__c;
            if(!String.isEmpty(values)){
                List<String> tempList = new List<String>(values.split(';'));
                Set<String> selectedlang = new Set<String>(tempList);
                
                for(String schmaValue : selectedlang){
                    valuesToDisplay.add(schmaValue);
                }
            }
            for(String val : valuesToDisplay){
                if(String.isEmpty(options))
                    options = val;
                else
                    options = options+','+val;
            }
        } catch(Exception ex){
            System.debug('Exception in getSelectedStartDay :'+ex.getStackTraceString());
            throw ex;
        }
        return options; 
    }
}
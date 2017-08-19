public with sharing class EE_UserTimeSheetExtension {

    public static final String SUCCESS_MSG = 'Success';     

	public final User_TimeSheet__c userTimeSheet {get;set;}

    public final ApexPages.StandardController standardController{get;set;}

    public TimeSheet__c timeSheet {get;set;}

    public Company_Project__c project {get;set;}

    public Set<Integer> vacationDays;    

    public Boolean mondayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.MONDAY)) || timeSheet != null && !timeSheet.MondayIncluded__c ? true:false;}}

    public Boolean tuesdayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.TUESDAY)) || timeSheet != null &&  !timeSheet.TuesdayIncluded__c ? true:false;}}

    public Boolean wednesdayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.WEDNESDAY)) || timeSheet != null &&  !timeSheet.WednesdayIncluded__c ? true:false;}}

    public Boolean thursdayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.THURSDAY)) || timeSheet != null &&  !timeSheet.ThursdayIncluded__c ? true:false;}}

    public Boolean fridayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.FRIDAY)) || timeSheet != null &&  !timeSheet.FridayIncluded__c ? true:false;}}

    public Boolean saturdayDisabled { get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.SATURDAY)) || timeSheet != null &&  !timeSheet.SaturdayIncluded__c ? true:false;}}

    public Boolean sundayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.SUNDAY)) || timeSheet != null &&  !timeSheet.SundayIncluded__c ? true:false;}}

    public Boolean redirectAfterOverdueCheck {get;set;}
    
    private final List<WeekDay> orderedDays = new List<WeekDay>{
        new WeekDay('Monday','Monday_Hours__c'),
        new WeekDay('Tuesday','Tuesday_Hours__c'),
        new WeekDay('Wednesday','Wednesday_Hours__c'),
        new WeekDay('Thursday','Thursday_Hours__c'),
        new WeekDay('Friday','Friday_Hours__c'),
        new WeekDay('Saturday','Saturday_Hours__c'),
        new WeekDay('Sunday','Sunday_Hours__c') 
    };
    
    public EE_UserTimeSheetExtension(ApexPages.StandardController stdController) {
        System.debug('Create');
        this.standardController = stdController;
        loadAllFieldsToController();
        this.userTimeSheet = (User_TimeSheet__c)stdController.getRecord(); 

        Id timeSheetId = ApexPages.currentPage().getParameters().get('tsId'); 
        Id projectId = ApexPages.currentPage().getParameters().get('projectId'); 

        if(String.isNotBlank(this.userTimeSheet.Project_Id__c)){
            project = getProject(this.userTimeSheet.Project_Id__c);
        }else{        
            findCurrentUserProject(projectId);
        }

        if(String.isBlank(this.userTimeSheet.TimeSheet__c )){
            this.userTimeSheet.TimeSheet__c = timeSheetId;         
        }

        timeSheet = EE_DAO_TimeSheetDao.getById(this.userTimeSheet.TimeSheet__c);  
        if(timeSheet == null || !EE_SRV_TimeSheetManager.isTimeSheetActive(timeSheet)){
           showCommunicat(ApexPages.Severity.INFO, 'Time Sheet is not active.'); 
        }    

        calculateVacationDays(); 

        redirectAfterOverdueCheck = false;  
        updateUserTimeSheetStatus();

        if(ApexPages.currentPage().getParameters().get('msg') == SUCCESS_MSG){
            showCommunicat(ApexPages.Severity.CONFIRM, 'Time Sheet saved.'); 
        }

    }   

    public List<WeekDay> getOrderedDays(){
        return orderedDays;
    }

    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        for(Integer hour= 0; hour <= 24; hour ++ ){
            String hourOption = String.valueOf(hour); 
            options.add(new SelectOption(hourOption,hourOption));
        }

        return options;
    }

    /*
    * Check if timesheet is active to avoid overdue previously approved user timesheets.
    */
    public void saveOverdueUserTimeSheet(){
        validateDays();
        this.userTimeSheet.Project_Id__c = project != null ? project.ID : null;
        this.userTimeSheet.Status__c = EE_SRV_TimeSheetManager.OVERDUE_STATUS;
        this.userTimeSheet.User__c = UserInfo.getUserId();
        if(String.isNotBlank(this.userTimeSheet.Project_Id__c) && !isTimeSheetDuplicated() && timeSheet != null){
            if(String.isBlank(this.userTimeSheet.Id)){
                insert this.userTimeSheet;   
                redirectAfterOverdueCheck = true;        
            }else{
                update this.userTimeSheet;
                redirectAfterOverdueCheck = false;
            }
        }
    }

    public PageReference sentForApproval(){
        String statusBeforeUpdate = this.userTimeSheet.Status__c;
        Boolean sentFlagBeforeUpdate = this.userTimeSheet.Previously_Sent__c;

        this.userTimeSheet.Status__c = EE_SRV_TimeSheetManager.SENT_STATUS;
        this.userTimeSheet.Previously_Sent__c = true;

        try{           
            update this.userTimeSheet;
            showCommunicat(ApexPages.Severity.INFO, 'Time Sheet sent for sentForApproval.');  
        }catch(DMLException ex){
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, ex.getDMLMessage(0)));
            this.userTimeSheet.Status__c = statusBeforeUpdate;
            this.userTimeSheet.Previously_Sent__c = sentFlagBeforeUpdate;
        }

        RETURN NULL;       
    }

    public PageReference saveUserTimeSheet(){
           // validateDays();

        String statusBeforeUpdate = String.isNotBlank(this.userTimeSheet.Status__c) ? this.userTimeSheet.Status__c : EE_SRV_TimeSheetManager.NEW_STATUS;      

        this.userTimeSheet.Status__c =  EE_SRV_TimeSheetManager.SUBMITTED_STATUS;
        this.userTimeSheet.Project_Id__c = project.ID;
        this.userTimeSheet.User__c = UserInfo.getUserId();      

        if(isTimeSheetDuplicated()){
            showCommunicat(ApexPages.Severity.ERROR,'Time Sheet has been already saved.');
            this.userTimeSheet.Status__c = statusBeforeUpdate; 
            return null;
        }
        
        try{
            upsert this.userTimeSheet;           
            PageReference pageRef = new PageReference('/apex/EE_UserTimeSheet?msg=success&id='+this.userTimeSheet.ID);
            pageRef.setRedirect(true);
            return pageRef;
        }catch(DMLException ex){
            showCommunicat(ApexPages.Severity.ERROR, ex.getDmlMessage(0));  
            this.userTimeSheet.Status__c = statusBeforeUpdate;                 
        }

        return null;
    }

    public Boolean getDisableSaveButton(){
        return this.userTimeSheet.Status__c == EE_SRV_TimeSheetManager.APPROVED_STATUS 
            || this.userTimeSheet.Status__c == EE_SRV_TimeSheetManager.OVERDUE_STATUS
            || this.userTimeSheet.Status__c == EE_SRV_TimeSheetManager.SENT_STATUS
            || this.project == null;
    }

    private void showCommunicat(ApexPages.Severity severity, String message){
         Apexpages.addMessage(new ApexPages.Message(severity,message));
    }

    private void findCurrentUserProject(Id projectId){      
        List<Company_Project__c> projects =  getProjectsForUser(UserInfo.getUserId());
        for(Company_Project__c p : projects){
            if(p.Id ==  projectId){
                project = p;
            }
        }

        if(project == null){
            showCommunicat(ApexPages.Severity.ERROR, 'You are not alligned to project.');  
        }
    }

    private void loadAllFieldsToController(){
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('User_TimeSheet__c').getDescribe().fields.getMap();
        List<String> fieldNames = new List<String>();
        fieldNames.addAll(objectFields.keySet());      

        this.standardController.addFields(fieldNames);
    }

    private void calculateVacationDays(){
        if(timeSheet == null){
            return;
        }

        vacationDays = new Set<Integer>();
        List<Vacation_Days__c> days = [SELECT Country__c,Vacation_Day__c FROM Vacation_Days__c WHERE  TimeSheet__c=:timeSheet.ID]; 

        for(Vacation_Days__c vacationDay:days){
            Integer startDateDayOfWeek = EE_UTL_DateUtils.getDayOfWeek(timeSheet.StartDay__c);
            Integer daysBetween = timeSheet.StartDay__c.daysBetween(vacationDay.Vacation_Day__c);
            vacationDays.add(startDateDayOfWeek + daysBetween);
        }

        System.debug(vacationDays);
    }

    private void validateDays(){
        sObject userTsObject = (sObject) this.userTimeSheet;

        for(WeekDay day:orderedDays){
            if(userTsObject.get(day.fieldName) == null){
                userTsObject.put(day.fieldName,0);
            }
        }
    }

    private Company_Project__c getProject(ID projectId){
        List<Company_Project__c> projects = [SELECT Id,Name FROM Company_Project__c WHERE Id = :projectId];
        if(projects != null && !projects.isEmpty()){
            return projects[0];
        }else{
            return null;
        }
    }
    
    private void updateUserTimeSheetStatus(){
        if(timesheet == null || EE_SRV_TimeSheetManager.shouldBeUserTimeSheetOverdue(this.userTimeSheet,this.timeSheet)){
            this.userTimeSheet.Status__c = EE_SRV_TimeSheetManager.OVERDUE_STATUS;            
        }
    }     

    private List<Company_Project__c> getProjectsForUser(Id userId){
       List<Company_Project_Assigment__c> assigments = [SELECT ID,Project__r.Name,Project__r.Id FROM Company_Project_Assigment__c WHERE User__c = :userId];
       List<Company_Project__c> projects = new List<Company_Project__c>();
       for(Company_Project_Assigment__c assigment:assigments){
            projects.add(assigment.Project__r);
       }

       return projects;
    }

    private User_TimeSheet__c getUserTimeSheet(Id timeSheetId,Id projectId,Id userId){
        List<User_TimeSheet__c> timeSheets = [SELECT Id FROM User_TimeSheet__c WHERE TimeSheet__c = :timeSheetId AND Project_ID__c = :projectId AND User__c = :userId];  
        return timeSheets != null && !timeSheets.isEmpty() ? timeSheets[0] : null;     
    }

    private Boolean isTimeSheetDuplicated(){
        User_TimeSheet__c duplicatedTimeSheet = getUserTimeSheet(this.userTimeSheet.TimeSheet__c,this.userTimeSheet.Project_Id__c,UserInfo.getUserId());
        return duplicatedTimeSheet != null && duplicatedTimeSheet.Id != this.userTimeSheet.Id;
    }

     private class WeekDay{
        public String label {get;set;}
        public String fieldName {get;set;}

        public WeekDay(String label,String fieldName){
            this.label = label;
            this.fieldName = fieldName;
        }
    } 
    
}
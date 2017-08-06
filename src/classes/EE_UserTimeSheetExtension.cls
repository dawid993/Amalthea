public with sharing class EE_UserTimeSheetExtension {

	public final User_TimeSheet__c userTimeSheet {get;set;}

    public final ApexPages.StandardController standardController{get;set;}

    public TimeSheet__c timeSheet {get;set;}

    public Company_Project__c project {get;set;}

    public Set<Integer> vacationDays;    

    public Boolean mondayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.MONDAY)) || !timeSheet.MondayIncluded__c ? true:false;}}

    public Boolean tuesdayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.THURSDAY)) || !timeSheet.TuesdayIncluded__c ? true:false;}}

    public Boolean wednesdayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.WEDNESDAY)) || !timeSheet.WednesdayIncluded__c ? true:false;}}

    public Boolean thursdayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.THURSDAY)) || !timeSheet.ThursdayIncluded__c ? true:false;}}

    public Boolean fridayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.FRIDAY)) || !timeSheet.FridayIncluded__c ? true:false;}}

    public Boolean saturdayDisabled { get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.SATURDAY)) || !timeSheet.SaturdayIncluded__c ? true:false;}}

    public Boolean sundayDisabled {get{ return (vacationDays != null && vacationDays.contains(EE_UTL_DateUtils.SUNDAY)) || !timeSheet.SundayIncluded__c ? true:false;}}
    
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
        this.standardController = stdController;
        loadAllFieldsToController();
        this.userTimeSheet = (User_TimeSheet__c)stdController.getRecord(); 

        Id timeSheetId = ApexPages.currentPage().getParameters().get('tsId'); 
        Id projectId = ApexPages.currentPage().getParameters().get('projectId'); 
        findCurrentUserProject(projectId);

        if(String.isBlank(this.userTimeSheet.TimeSheet__c )){
            this.userTimeSheet.TimeSheet__c = timeSheetId;         
        }

        timeSheet = EE_DAO_TimeSheetDao.getById(this.userTimeSheet.TimeSheet__c);  
        if(timeSheet == null || !EE_SRV_TimeSheetManager.isTimeSheetActive(timeSheet)){
           Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Time Sheet is not active.')); 
        }    

        calculateVacationDays();   
        updateUserTimeSheetStatus();

        if(ApexPages.currentPage().getParameters().get('msg') == 'success'){
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.CONFIRM, 'Time Sheet saved.')); 
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

    public void sentForApproval(){
        String statusBeforeUpdate = this.userTimeSheet.Status__c;
        Boolean sentFlagBeforeUpdate = this.userTimeSheet.Previously_Sent__c;

        this.userTimeSheet.Status__c = EE_SRV_TimeSheetManager.SENT_STATUS;
        this.userTimeSheet.Previously_Sent__c = true;

        try{           
            update this.userTimeSheet;
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.INFO, 'Time Sheet sent for sentForApproval.'));  
        }catch(DMLException ex){
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, ex.getDMLMessage(0)));
            this.userTimeSheet.Status__c = statusBeforeUpdate;
            this.userTimeSheet.Previously_Sent__c = sentFlagBeforeUpdate;
        }        
    }

    public PageReference saveUserTimeSheet(){
       // validateDays();

        String statusBeforeUpdate = String.isNotBlank(this.userTimeSheet.Status__c) ? this.userTimeSheet.Status__c : EE_SRV_TimeSheetManager.NEW_STATUS;
        Boolean sentFlagBeforeUpdate = this.userTimeSheet.Previously_Sent__c;

        this.userTimeSheet.Status__c =  EE_SRV_TimeSheetManager.SUBMITTED_STATUS;
        this.userTimeSheet.Project_Id__c = project.ID;
        
        try{
            upsert this.userTimeSheet;           
            PageReference pageRef = new PageReference('/apex/EE_UserTimeSheet?msg=success&id='+this.userTimeSheet.ID);
            pageRef.setRedirect(true);
            return pageRef;
        }catch(DMLException ex){
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, ex.getDmlMessage(0)));  
            this.userTimeSheet.Status__c = statusBeforeUpdate;
            this.userTimeSheet.Previously_Sent__c = sentFlagBeforeUpdate;       
        }

        return null;
    }

    public Boolean getDisableSaveButton(){
        return this.userTimeSheet.Status__c == EE_SRV_TimeSheetManager.APPROVED_STATUS 
            || this.userTimeSheet.Status__c == EE_SRV_TimeSheetManager.OVERDUE_STATUS
            || this.userTimeSheet.Status__c == EE_SRV_TimeSheetManager.SENT_STATUS
            || this.project == null;
    }

    private void findCurrentUserProject(Id projectId){
        if(String.isNotBlank(this.userTimeSheet.Project_Id__c)){
            projectId = this.userTimeSheet.Project_Id__c;
        }
        List<Company_Project__c> projects =  getProjectsForUser(UserInfo.getUserId());
        for(Company_Project__c p : projects){
            if(p.Id ==  projectId){
                project = p;
            }
        }
    }

    private void loadAllFieldsToController(){
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('User_TimeSheet__c').getDescribe().fields.getMap();
        List<String> fieldNames = new List<String>();
        fieldNames.addAll(objectFields.keySet());      

        this.standardController.addFields(fieldNames);
    }

    private void calculateVacationDays(){
        vacationDays = new Set<Integer>();
        List<Vacation_Days__c> days = [SELECT Country__c,Vacation_Day__c FROM Vacation_Days__c WHERE  TimeSheet__c=:timeSheet.ID]; 

        for(Vacation_Days__c vacationDay:days){
            Integer startDateDayOfWeek = EE_UTL_DateUtils.getDayOfWeek(timeSheet.StartDay__c);
            Integer daysBetween = timeSheet.StartDay__c.daysBetween(vacationDay.Vacation_Day__c);
            vacationDays.add(startDateDayOfWeek + daysBetween);
        }
    }

    private void validateDays(){
        sObject userTsObject = (sObject) this.userTimeSheet;

        for(WeekDay day:orderedDays){
            if(userTsObject.get(day.fieldName) == null){
                userTsObject.put(day.fieldName,0);
            }
        }
    }

    /*
    * Check if timesheet is active to avoid overdue previously approved user timesheets.
    */
    public void saveOverdueUserTimeSheet(){
        validateDays();
        this.userTimeSheet.Project_Id__c = project.ID;
        this.userTimeSheet.Status__c = EE_SRV_TimeSheetManager.OVERDUE_STATUS;
        if(EE_SRV_TimeSheetManager.isTimeSheetActive(timeSheet)){
            upsert this.userTimeSheet;
        }
        
    }

    private void updateUserTimeSheetStatus(){
        if(EE_SRV_TimeSheetManager.shouldBeUserTimeSheetOverdue(this.userTimeSheet,this.timeSheet)){
            this.userTimeSheet.Status__c = EE_SRV_TimeSheetManager.OVERDUE_STATUS;            
        }
    }   

    private class WeekDay{
        public String label {get;set;}
        public String fieldName {get;set;}

        public WeekDay(String label,String fieldName){
            this.label = label;
            this.fieldName = fieldName;
        }
    }

    public List<Company_Project__c> getProjectsForUser(Id userId){
       List<Company_Project_Assigment__c> assigments = [SELECT ID,Project__r.Name,Project__r.Id FROM Company_Project_Assigment__c WHERE User__c = :userId];
       List<Company_Project__c> projects = new List<Company_Project__c>();
       for(Company_Project_Assigment__c assigment:assigments){
            projects.add(assigment.Project__r);
       }

       return projects;
    } 
    
}
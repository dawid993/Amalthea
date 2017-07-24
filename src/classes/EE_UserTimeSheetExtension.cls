public with sharing class EE_UserTimeSheetExtension {

	public final User_TimeSheet__c userTimeSheet {get;set;}

    public final ApexPages.StandardController standardController{get;set;}

    public TimeSheet__c timeSheet {get;set;}

    public Set<Integer> vacationDays;

    public List<Company_Project__c> userProjects {get;set;}

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
        this.standardController.addFields(new String[]{
            'Friday_Hours__c',
            'Monday_Hours__c',
            'Overhours_Allowed__c',
            'Project_Id__c',
            'Saturday_Hours__c',
            'Sunday_Hours__c',
            'Thursday_Hours__c',
            'TimeSheet__c',
            'Tuesday_Hours__c',
            'User__c',
            'User_Comment__c',
            'Wednesday_Hours__c'  

        });


        this.userTimeSheet = (User_TimeSheet__c)stdController.getRecord(); 
        Id timeSheetId = ApexPages.currentPage().getParameters().get('tsId'); 

        if(String.isBlank(this.userTimeSheet.TimeSheet__c )){
            this.userTimeSheet.TimeSheet__c = timeSheetId;         
        }

        timeSheet = EE_DAO_TimeSheetDao.getById(this.userTimeSheet.TimeSheet__c);        
        calculateVacationDays();
        userProjects = getProjectsForUser(UserInfo.getUserId());
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

    public List<SelectOption> getProjectItems(){
        List<SelectOption> options = new List<SelectOption>();
        for(Company_Project__c project:userProjects){
            options.add(new SelectOption(project.Id,project.Name));
        }

        return options;
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

    public PageReference saveUserTimeSheet(){
        validateDays();
        this.standardController.save();

        return null;
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
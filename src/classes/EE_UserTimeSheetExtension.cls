public with sharing class EE_UserTimeSheetExtension {

	public final User_TimeSheet__c userTimeSheet {get;set;}

    public TimeSheet__c timeSheet {get;set;}

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
        this.userTimeSheet = (User_TimeSheet__c)stdController.getRecord(); 
        Id timeSheetId = ApexPages.currentPage().getParameters().get('tsId'); 
        timeSheet = EE_DAO_TimeSheetDao.getById(timeSheetId);
        calculateVacationDays();
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

    private void calculateVacationDays(){
        vacationDays = new Set<Integer>();
        List<Vacation_Days__c> days = [SELECT Country__c,Vacation_Day__c FROM Vacation_Days__c WHERE  TimeSheet__c=:timeSheet.ID]; 

        for(Vacation_Days__c vacationDay:days){
            Integer startDateDayOfWeek = EE_UTL_DateUtils.getDayOfWeek(timeSheet.StartDay__c);
            Integer daysBetween = timeSheet.StartDay__c.daysBetween(vacationDay.Vacation_Day__c);
            vacationDays.add(startDateDayOfWeek + daysBetween);
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

    public PageReference ac(){
        return null;
    }
    
}
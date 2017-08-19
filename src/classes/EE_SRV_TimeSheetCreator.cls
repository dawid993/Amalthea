public class EE_SRV_TimeSheetCreator {

	private static Integer LAST_DAY_OF_WEEK = 6;

	public TimeSheet__c timeSheet {get;set;}

	public TimeSheet__c connectedTimeSheet {get;set;}

	private TimeSheetConfiguration__c timeConfig;

	private Map<Integer,String> includeDays = new Map<Integer,String>{
		0 => 'MondayIncluded__c',
		1 => 'TuesdayIncluded__c',
		2 => 'WednesdayIncluded__c',
		3 => 'ThursdayIncluded__c',
		4 => 'FridayIncluded__c',
		5 => 'SaturdayIncluded__c',
		6 => 'SundayIncluded__c'
	};

	public EE_SRV_TimeSheetCreator(){
		timeSheet = new TimeSheet__c();
		timeConfig = TimeSheetConfiguration__c.getInstance('Confing');
	}

	public static Boolean isFullWeekTimeSheet(TimeSheet__c timeSheet){
		if(timeSheet.StartDay__c == null || timeSheet.EndDate__c == null){
			return false;
		}else{			
			return timeSheet.StartDay__c.daysBetween(timeSheet.EndDate__c) == EE_UTL_DateUtils.FULL_WEEK_LENGTH - 1;
		}
	}

	private Date getEndDate(Date startDate){
		Integer dayOfWeek = EE_UTL_DateUtils.getDayOfWeek(startDate);
		Date endDate = startDate.addDays(EE_UTL_DateUtils.SUNDAY - dayOfWeek);		
		if(endDate.month() != startDate.month()){
			endDate = EE_UTL_DateUtils.getLastDayOfPreviousMonth(endDate);
		}

		return endDate;
	}

	private void setCorrectDate(TimeSheet__c masterDateTimeSheet,TimeSheet__c dependentDateTimeSheet){
		dependentDateTimeSheet.ReportTime__c = masterDateTimeSheet.ReportTime__c;
		dependentDateTimeSheet.Communicat_Date__c = masterDateTimeSheet.Communicat_Date__c;
	}

	private void includeDays(Date startDate){
		Date endDate = getEndDate(startDate);
		Integer dayOfWeek = EE_UTL_DateUtils.getDayOfWeek(startDate);
		sObject timeSheetObject = timeSheet;

		for(Integer i=0;i<dayOfWeek;i++){
			timeSheetObject.put(includeDays.get(i),false);
		}

		for(Integer i=dayOfWeek;i<=EE_UTL_DateUtils.SUNDAY;i++){
			Date currentDate = startDate.addDays(i-dayOfWeek);
			if(currentDate > endDate){
				timeSheetObject.put(includeDays.get(i),false);
			}else{
				timeSheetObject.put(includeDays.get(i),true);
			}
		}

	}

	private DateTime calculateReportTime(){
		Time confTime = getTimeFromConfing();
		if(this.timeSheet.EndDate__c == null || confTime == null){
			return null;
		}

		Integer addDays = Integer.valueOf(timeConfig.Report_Time_Days__c);
		return DateTime.newInstance(this.timeSheet.EndDate__c.addDays(addDays),confTime);
	}

	private Date calculateCommunicatDate(){
		if(timeConfig == null || this.timeSheet.EndDate__c == null){
			return null;
		}

		Integer addDays = Integer.valueOf(timeConfig.Communicat_Date_Days__c);
		return this.timesheet.EndDate__c.addDays(addDays);
	}

	private Time getTimeFromConfing(){
		if(timeConfig == null){
			return null;
		}

		Integer hour = Integer.valueOf(timeConfig.Hour__c);
		Integer minute = Integer.valueOf(timeConfig.Minute__c);
		Integer second = Integer.valueOf(timeConfig.Second__c);
		Integer milisecond = Integer.valueOf(timeConfig.Millisecond__c);

		return Time.newInstance(hour,minute,second,milisecond);
	}

	private void createConnectedTimeSheet(Date startDate){
		EE_SRV_TimeSheetCreator timeSheetCreator = new EE_SRV_TimeSheetCreator();
		timeSheetCreator.createTimeSheet(startDate);		
		this.connectedTimeSheet = timeSheetCreator.timeSheet;
	}

	public void createTimeSheet(Date startDate){
		if(startDate == null){
			System.debug('Date is null');
			return;
		}

		Date endDate = getEndDate(startDate);
		timeSheet.StartDay__c = startDate;
		timeSheet.EndDate__c = endDate;
		timeSheet.ReportTime__c = calculateReportTime();
		timeSheet.Communicat_Date__c = calculateCommunicatDate();
		timesheet.isActive__c = true;
		includeDays(startDate);
		
		if(isFullWeekTimeSheet(timeSheet) && startDate.day() != EE_UTL_DateUtils.FIRST_MONTH_DAY){
			Date nextWeekStartDate = EE_UTL_DateUtils.getFirstDayOfNextWeek(timeSheet.StartDay__c);			
			if(EE_UTL_DateUtils.isLastWeekInMonth(nextWeekStartDate)){
				createConnectedTimeSheet(nextWeekStartDate);
				setCorrectDate(this.timeSheet,this.connectedTimeSheet);				
			}
		}else{
			if(startDate.day() == EE_UTL_DateUtils.FIRST_MONTH_DAY){
				Date nextWeekStartDate = EE_UTL_DateUtils.getFirstDayOfNextWeek(timeSheet.StartDay__c);
				createConnectedTimeSheet(nextWeekStartDate);
				setCorrectDate(this.connectedTimeSheet,this.timeSheet);
			}
		}
	}

	public Boolean isTimeSheetCreated(){
		return this.timeSheet != null;
	}

	public Boolean isConnectedTimeSheetCreated(){
		return this.connectedTimeSheet != null;
	}
}
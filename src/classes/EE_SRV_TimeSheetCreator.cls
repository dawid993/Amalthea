public class EE_SRV_TimeSheetCreator {

	private static Integer LAST_DAY_OF_WEEK = 6;

	public TimeSheet__c timeSheet {get;set;}

	public TimeSheet__c connectedTimeSheet {get;set;}

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
	}

	public static Boolean isFullWeekTimeSheet(TimeSheet__c timeSheet){
		if(timeSheet.StartDay__c == null || timeSheet.EndDate__c == null){
			return false;
		}else{			
			return timeSheet.StartDay__c.daysBetween(timeSheet.EndDate__c) == EE_UTL_DateUtils.FULL_WEEK_LENGTH;
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

	private void includeDays(Date startDate){
		Date endDate = getEndDate(startDate);
		Integer dayOfWeek = EE_UTL_DateUtils.getDayOfWeek(startDate);
		sObject timeSheetObject = timeSheet;

		for(Integer i=0;i<dayOfWeek;i++){
			timeSheetObject.put(includeDays.get(i),false);
		}

		for(Integer i=dayOfWeek;i<=EE_UTL_DateUtils.SUNDAY;i++){
			Date currentDate = startDate.addDays(i-dayOfWeek);
			if(currentDate > endDate || EE_UTL_DateUtils.isWeekendDay(currentDate)){
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
		
		return DateTime.newInstance(this.timeSheet.EndDate__c.addDays(-2),confTime);
	}

	private Time getTimeFromConfing(){
		TimeSheetConfiguration__c conf = TimeSheetConfiguration__c.getInstance('Confing');

		if(conf == null){
			return null;
		}

		Integer hour = Integer.valueOf(conf.Hour__c);
		Integer minute = Integer.valueOf(conf.Minute__c);
		Integer second = Integer.valueOf(conf.Second__c);
		Integer milisecond = Integer.valueOf(conf.Millisecond__c);

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
		includeDays(startDate);
		
		if(isFullWeekTimeSheet(timeSheet)){
			Date nextWeekStartDate = EE_UTL_DateUtils.getFirstDayOfNextWeek(timeSheet.StartDay__c);			
			if(EE_UTL_DateUtils.isNewMonthInWeek(nextWeekStartDate)){
				createConnectedTimeSheet(nextWeekStartDate);
				this.connectedTimeSheet.ReportTime__c = this.timeSheet.ReportTime__c;
			}
		}else{
			if(startDate.day() == EE_UTL_DateUtils.FIRST_MONTH_DAY){
				Date nextWeekStartDate = EE_UTL_DateUtils.getFirstDayOfNextWeek(timeSheet.StartDay__c);
				createConnectedTimeSheet(nextWeekStartDate);
				this.timeSheet.ReportTime__c = this.connectedTimeSheet.ReportTime__c;
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
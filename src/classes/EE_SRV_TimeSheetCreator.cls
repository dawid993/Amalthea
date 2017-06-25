public class EE_SRV_TimeSheetCreator {

	private static Integer LAST_DAY_OF_WEEK = 6;

	private sObject timeSheet;

	private Map<String,Integer> daysOfWeeks = new Map<String,Integer>{
		'Monday' => 0,
		'Tuesday' => 1,
		'Wednesday' => 2,
		'Thursday' => 3,
		'Friday' => 4,
		'Saturday' => 5,
		'Sunday' => 6
	};

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

	private Integer getDayOfWeek(Date startDate){
		DateTime startTime = (DateTime) startDate;
		return daysOfWeeks.get(startTime.format('EEEE'));
	}

	private Date getEndDate(Date startDate){
		Integer dayOfWeek = getDayOfWeek(startDate);
		Date endDate = startDate.addDays(LAST_DAY_OF_WEEK - dayOfWeek);
		if(endDate.month() != startDate.month()){
			endDate = getLastDayOfPreviousMonth(endDate);
		}

		return endDate;
	}

	private void includeDays(Date startDate){
		Date endDate = getEndDate(startDate);
		Integer dayOfWeek = getDayOfWeek(startDate);

		for(Integer i=0;i<dayOfWeek;i++){
			timeSheet.put(includeDays.get(i),false);
		}

		for(Integer i=dayOfWeek;i<=LAST_DAY_OF_WEEK;i++){
			Date currentDate = startDate.addDays(i-dayOfWeek);
			if(currentDate > endDate || isWeekendDay(currentDate)){
				timeSheet.put(includeDays.get(i),false);
			}else{
				timeSheet.put(includeDays.get(i),true);
			}
		}

	}

	private Boolean isWeekendDay(Date currentDate){
		return  getDayOfWeek(currentDate) == 5 || getDayOfWeek(currentDate) == 6;
	}

	private Date getLastDayOfPreviousMonth(Date currentDate){
		Date firstMonthDay = Date.newInstance(currentDate.year(), currentDate.month(), 1);
		return firstMonthDay.addDays(-1);
	}

	public sObject createTimeSheet(Date startDate){
		if(startDate == null){
			return null;
		}

		Date endDate = getEndDate(startDate);
		timeSheet.put('EndDate__c',endDate);
		includeDays(startDate);

		return timeSheet;
	}
}
public with sharing class EE_UTL_DateUtils {

	public static Integer MONDAY = 0;

	public static Integer TUESDAY = 1;	

	public static Integer WEDNESDAY = 2;	

	public static Integer THURSDAY = 3;
	
	public static Integer FRIDAY = 4;
	
	public static Integer SATURDAY = 5;
	
	public static Integer SUNDAY = 6;

	public static Integer FIRST_MONTH_DAY = 1;

	public static Integer FULL_WEEK_LENGTH = 6;
	
	
	public static Map<String,Integer> daysOfWeeks = new Map<String,Integer>{
		'Monday' => 0,
		'Tuesday' => 1,
		'Wednesday' => 2,
		'Thursday' => 3,
		'Friday' => 4,
		'Saturday' => 5,
		'Sunday' => 6
	};

	public static Integer getDayOfWeek(Date startDate){
		DateTime startTime = (DateTime) startDate;
		return daysOfWeeks.get(startTime.format('EEEE'));
	}

	public static Boolean isWeekendDay(Date currentDate){
		return  getDayOfWeek(currentDate) == SATURDAY || getDayOfWeek(currentDate) == SUNDAY;
	}

	public static Date getLastDayOfPreviousMonth(Date currentDate){
		Date firstMonthDay = Date.newInstance(currentDate.year(), currentDate.month(), FIRST_MONTH_DAY);
		return firstMonthDay.addDays(-1);
	}

	public static Date getFirstDayOfNextWeek(Date startDate){
		Integer dayOfWeek = getDayOfWeek(startDate);
		return startDate.addDays(SUNDAY - dayOfWeek+1);
	}

	public static Boolean isNewMonthInWeek(Date startDate){
		Integer dayOfWeek = getDayOfWeek(startDate);
		Date endDate = startDate.addDays(SUNDAY - dayOfWeek);
		return endDate.month() != startDate.month();
	}
}
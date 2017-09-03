public class EE_DAO_TimeSheetDao {

	public static Database.SaveResult save(TimeSheet__c timeSheet){	
		Database.SaveResult result; 
		if(String.isNotBlank(timeSheet.ID)){
			result = Database.update(timeSheet);
		}else{
			result = Database.insert(timeSheet);
		}

		return result;
	}

	public static TimeSheet__c getById(Id timeSheetId){
		List<TimeSheet__c> timeSheet = 
			[SELECT
				IsActive__c,
				DaysInPeriod__c,
				EndDate__c,
				FridayIncluded__c,
				MondayIncluded__c,
				ProcessId__c,
				ReportTime__c,
				SaturdayIncluded__c,
				StartDay__c,
				SundayIncluded__c,
				ThursdayIncluded__c,
				ConnectedTimeSheet__c,
				TuesdayIncluded__c,
				WednesdayIncluded__c
			FROM 
				TimeSheet__c
			WHERE
				Id = :timeSheetId
			];

		return timeSheet != null && !timeSheet.isEmpty() ? timeSheet[0] : null;
	}

	public static TimeSheet__c getByDate(Date currentDate){
		List<TimeSheet__c> timeSheet = 
			[SELECT
				IsActive__c,
				DaysInPeriod__c,
				EndDate__c,
				FridayIncluded__c,
				MondayIncluded__c,
				ProcessId__c,
				ReportTime__c,
				SaturdayIncluded__c,
				StartDay__c,
				SundayIncluded__c,
				ThursdayIncluded__c,
				ConnectedTimeSheet__c,
				TuesdayIncluded__c,
				WednesdayIncluded__c
			FROM 
				TimeSheet__c
			WHERE
				StartDay__c >= :currentDate AND EndDate__c <= :currentDate
			];

		return timeSheet != null && !timeSheet.isEmpty() ? timeSheet[0] : null;	
	}

	public static TimeSheet__c getWithChildrenById(Id timeSheetId){
		List<TimeSheet__c> timeSheet = 
			[SELECT
				IsActive__c,
				DaysInPeriod__c,
				EndDate__c,
				FridayIncluded__c,
				MondayIncluded__c,
				ProcessId__c,
				ReportTime__c,
				SaturdayIncluded__c,
				StartDay__c,
				SundayIncluded__c,
				ThursdayIncluded__c,
				ConnectedTimeSheet__c,
				TuesdayIncluded__c,
				WednesdayIncluded__c,
					(SELECT
					IsActive__c,
					DaysInPeriod__c,
					EndDate__c,
					FridayIncluded__c,
					MondayIncluded__c,
					ProcessId__c,
					ReportTime__c,
					SaturdayIncluded__c,
					StartDay__c,
					SundayIncluded__c,
					ThursdayIncluded__c,
					ConnectedTimeSheet__c,
					TuesdayIncluded__c,
					WednesdayIncluded__c FROM TimeSheet__r)
			FROM 
				TimeSheet__c
			WHERE
				Id = :timeSheetId
			];

		return timeSheet != null && !timeSheet.isEmpty() ? timeSheet[0] : null;
	}

	public static User_TimeSheet__c getUserTimeSheetById(ID userTimeSheetId){
		List<User_TimeSheet__c> userTimeSheets =
			[SELECT
					Friday_Hours__c,
					Monday_Hours__c,
					Overhours_Allowed__c,
					Previously_Rejected__c,
					Previously_Sent__c,
					Project_Id__c,
					Saturday_Hours__c,
					Status__c,
					Sunday_Hours__c,
					Thursday_Hours__c,
					TimeSheet__c,
					Tuesday_Hours__c,
					User__c,
					User_Comment__c,
					Wednesday_Hours__c
			FROM
				User_TimeSheet__c
			WHERE
				Id = :userTimeSheetId
			];
		return userTimeSheets != null && !userTimeSheets.isEmpty() ? userTimeSheets[0] : null;
	}
}
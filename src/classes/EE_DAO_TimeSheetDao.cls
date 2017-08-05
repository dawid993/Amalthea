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
		return 
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
	}

	public static TimeSheet__c getByDate(Date currentDate){
		return 
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
	}
}
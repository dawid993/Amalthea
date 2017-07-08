public class EE_SRV_TimeSheetManager {	

	public static final String TS_PROCCESS_PREFIX = 'TimeSheetPostProcess:';
	
	public static TimeSheet__c createTimeSheetProccess(Date startDate){
		EE_SRV_TimeSheetCreator timeSheetCreator = new EE_SRV_TimeSheetCreator();
		timeSheetCreator.createTimeSheet(startDate);	

		Database.SaveResult result;	

		if(timeSheetCreator.isTimeSheetCreated()){
			if(timeSheetCreator.isConnectedTimeSheetCreated()){
				result = insertTimeSheets(timeSheetCreator.timeSheet,timeSheetCreator.connectedTimeSheet);			
			}else{
				result = insertSingleTimeSheet(timeSheetCreator.timeSheet);
			}
		}

		if(result.isSuccess()){
			ID jobId = schedulePostCreationProcesses(timeSheetCreator.isConnectedTimeSheetCreated() 
				? timeSheetCreator.connectedTimeSheet : timeSheetCreator.timeSheet);
			timeSheetCreator.timeSheet.ProcessId__c = jobId;
			EE_DAO_TimeSheetDao.save(timeSheetCreator.timeSheet);
		}

		return timeSheetCreator.timeSheet;		
		
	}

	public static Database.SaveResult insertSingleTimeSheet(TimeSheet__c timeSheet){		
		return EE_DAO_TimeSheetDao.save(timeSheet);
	}

	public static Database.SaveResult insertTimeSheets(TimeSheet__c timeSheet,TimeSheet__c connectedTimeSheet){
		Database.SaveResult result = EE_DAO_TimeSheetDao.save(connectedTimeSheet);
		if(result.isSuccess()){
			timeSheet.ConnectedTimeSheet__c = connectedTimeSheet.ID;
			return EE_DAO_TimeSheetDao.save(timeSheet);
		}

		return result;
	}

	public static ID schedulePostCreationProcesses(TimeSheet__c timeSheet){
		if(String.isBlank(timeSheet.ID)){
			return null;
		}

		String cronStartDate = EE_UTL_JobsUtils.generateCronExp(timeSheet.ReportTime__c);
		EE_JOB_NewTimeSheetCreator scheduleCreator = new EE_JOB_NewTimeSheetCreator(timeSheet.ID);
		return System.schedule(TS_PROCCESS_PREFIX+timeSheet.ID, cronStartDate, scheduleCreator);
	}

	public static void abortTimeSheetProcess(TimeSheet__c timeSheet){
		if(String.isBlank(timeSheet.ID)){
			return;
		}

		CronTrigger ct = [SELECT id FROM CronTrigger WHERE  CronJobDetail.Name = :TS_PROCCESS_PREFIX+timeSheet.ID];
		EE_UTL_JobsUtils.abortTimeSheetProcess(ct.ID);
	}
	
}
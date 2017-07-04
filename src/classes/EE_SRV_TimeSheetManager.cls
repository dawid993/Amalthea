public class EE_SRV_TimeSheetManager {	

	public static final String TS_PROCCESS_PREFIX = 'TimeSheetPostProcess:';
	
	public TimeSheet__c createTimeSheetProccess(Date startDate){
		EE_SRV_TimeSheetCreator timeSheetCreator = new EE_SRV_TimeSheetCreator();
		timeSheetCreator.createTimeSheet(startDate);		

		if(timeSheetCreator.isTimeSheetCreated()){
			if(timeSheetCreator.isConnectedTimeSheetCreated()){
				Database.SaveResult result = insertTimeSheets(timeSheetCreator.timeSheet,timeSheetCreator.connectedTimeSheet);
				return result.isSuccess() ? timeSheetCreator.timeSheet : null;
			}else{
				return insertSingleTimeSheet(timeSheetCreator.timeSheet).isSuccess() ? timeSheetCreator.timeSheet : null;
			}
		}else{			
			return null;
		}

		/*if(result.isSuccess()){
			return schedulePostCreationProcesses(timeSheetCreator.timeSheet);
		}
			
		*/
		
	}

	public Database.SaveResult insertSingleTimeSheet(TimeSheet__c timeSheet){
		Database.SaveResult result = Database.insert(timeSheet);
		return result;
	}

	public Database.SaveResult insertTimeSheets(TimeSheet__c timeSheet,TimeSheet__c connectedTimeSheet){
		Database.SaveResult result = Database.insert(connectedTimeSheet);
		if(result.isSuccess()){
			timeSheet.ConnectedTimeSheet__c = connectedTimeSheet.ID;
			return Database.insert(timeSheet);
		}

		return result;
	}

	public ID schedulePostCreationProccesses(TimeSheet__c timeSheet){
		return null;
	}

	public void abortTimeSheetProcess(ID jobId){
		System.abortJob(jobId);
	}
}
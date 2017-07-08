global class EE_JOB_NewTimeSheetCreator implements Schedulable {

	private Date newTimeSheetStartDate;

	global EE_JOB_NewTimeSheetCreator(Id timeSheetId){
		TimeSheet__c timeSheet = EE_DAO_TimeSheetDao.getById(timeSheetId);
		if(timeSheet.EndDate__c != null){
			this.newTimeSheetStartDate = timeSheet.EndDate__c.addDays(1);
		}
	}	

	global void execute(SchedulableContext sc) {
		if(this.newTimeSheetStartDate != null){
			EE_SRV_TimeSheetManager.createTimeSheetProccess(this.newTimeSheetStartDate);
		}
	}
}
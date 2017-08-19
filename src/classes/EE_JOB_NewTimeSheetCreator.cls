global class EE_JOB_NewTimeSheetCreator implements Schedulable {

	private Date newTimeSheetStartDate;

	private TimeSheet__c timeSheet;

	global EE_JOB_NewTimeSheetCreator(Id timeSheetId){
		timeSheet = EE_DAO_TimeSheetDao.getWithChildrenById(timeSheetId);
		if(timesheet != null && timeSheet.EndDate__c != null){
			this.newTimeSheetStartDate = timeSheet.EndDate__c.addDays(1);
		}
	}	

	global void execute(SchedulableContext sc) {
		if(this.newTimeSheetStartDate != null){
			EE_SRV_TimeSheetManager.createTimeSheetProccess(this.newTimeSheetStartDate);
		}
		EE_SRV_TimeSheetManager.deactivateTimeSheets(timeSheet);
	}
}
@isTest
public class EE_Test_UserTimeSheetUnit {

	public Company_Project__c unitProject {get;set;}

	public TimeSheet__c unitTimeSheet {get;set;}

	public PageReference currentPage {get;set;}

	public EE_CTRL_UserTimeSheetExtension extension {get;set;}

	public EE_Test_UserTimeSheetUnit(){
		unitProject = EE_UTL_TestUtils.initTestUserAndProjectAssociation('Test Project');
		unitTimeSheet = EE_UTL_TestUtils.initDefaultTimeSheet();

		setCurrentTestPage(getPageReference());
	}

	private void recreatePage(){
		setCurrentTestPage(getPageReference());
		addParameterToPage('id',extension.userTimeSheet.ID);
		recreateExtension(extension.userTimeSheet);
	}

	public PageReference getPageReference(){
		return Page.EE_UserTimeSheet;
	}

	public void addParameterToPage(String key,String value){
		ApexPages.currentPage().getParameters().put(key,value);
	}

	public void setCurrentTestPage(PageReference testPage){
		currentPage = testPage;
		Test.setCurrentPageReference(currentPage);
	}

	public EE_CTRL_UserTimeSheetExtension recreateExtension(User_TimeSheet__c record){
		ApexPages.StandardController stdController = new ApexPages.StandardController(record);
		EE_CTRL_UserTimeSheetExtension extension = new EE_CTRL_UserTimeSheetExtension(stdController);
		return extension;
	}

	public void initNewExtension(){
		extension = recreateExtension(new User_TimeSheet__c());
	}

	public PageReference save(){
		PageReference saveReference = extension.saveUserTimeSheet();
		System.debug(saveReference);
		if(saveReference != null) {
			setCurrentTestPage(saveReference);
			User_TimeSheet__c userTimeSheet = EE_DAO_TimeSheetDao.getUserTimeSheetById(extension.userTimeSheet.ID);
			extension = recreateExtension(userTimeSheet);
		}

		return saveReference;
	}

	public void sentForApproval(){
		extension.sentForApproval();
	}

	public void saveOverdue(){
		extension.saveOverdueUserTimeSheet();
	}

	public Boolean isRedirectAfterOverdueCheck(){
		return extension.redirectAfterOverdueCheck;
	}

	public void approveUserTimeSheet(){
		extension.userTimeSheet.Status__c =  EE_SRV_TimeSheetManager.APPROVED_STATUS;
		upsert extension.userTimeSheet;
		recreatePage();
	}

	public void rejectUserTimeSheet(){
		extension.userTimeSheet.Status__c =  EE_SRV_TimeSheetManager.REJECTED_STATUS;
		upsert extension.userTimeSheet;
		recreatePage();
	}

	public String getCurrentUserTimeSheetStatus(){
		return extension.userTimeSheet.Status__c;
	}

	public List<Vacation_Days__c> initVacationDays(){
		List<Vacation_Days__c> vacationDays = EE_UTL_TestUtils.initDefaultVacationDaysForTimeSheet(unitTimeSheet);
		insert vacationDays;

		return vacationDays;
	}

	public Vacation_Days__c createVacationDay(Date vacationDay){
		Vacation_Days__c vacation = new Vacation_Days__c(TimeSheet__c = unitTimeSheet.ID,Country__c = 'PL'
				,Vacation_Day__c = vacationDay);

		return vacation;
	}
}
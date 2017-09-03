@isTest
public class EE_TEST_CTRL_UserTimeSheetExtension {

	private static final String SUCCESS = 'success';

	@testSetup
	static void init(){
		insert EE_UTL_TestUtils.getTimeSheetConfiguration();
	}

	private static EE_CTRL_UserTimeSheetExtension getExtension(User_TimeSheet__c record){
		ApexPages.StandardController stdController = new ApexPages.StandardController(record);
		EE_CTRL_UserTimeSheetExtension extension = new EE_CTRL_UserTimeSheetExtension(stdController);
		return extension;
	}

	@isTest
	static void userTimeSheetCreatedTest(){
		Company_Project__c project = EE_UTL_TestUtils.initTestUserAndProjectAssociation('Test Project');
		TimeSheet__c timeSheet = EE_UTL_TestUtils.initDefaultTimeSheet();

		Test.startTest();

		PageReference tsPage = Page.EE_UserTimeSheet;
		Test.setCurrentPageReference(tsPage);
		ApexPages.currentPage().getParameters().put('tsId',timeSheet.ID);
		ApexPages.currentPage().getParameters().put('projectId',project.ID);

		EE_CTRL_UserTimeSheetExtension extension = getExtension(new User_TimeSheet__c());
		PageReference pageRef = extension.saveUserTimeSheet();

		System.assertEquals(SUCCESS,pageRef.getParameters().get('msg'));
		System.assertEquals(extension.userTimeSheet.ID,pageRef.getParameters().get('id'));

		Test.stopTest();
	}

	@isTest
	static void userTimeSheetCreatedAndSendTest(){
		Company_Project__c project = EE_UTL_TestUtils.initTestUserAndProjectAssociation('Test Project');
		TimeSheet__c timeSheet = EE_UTL_TestUtils.initDefaultTimeSheet();

		Test.startTest();

		PageReference tsPage = Page.EE_UserTimeSheet;
		Test.setCurrentPageReference(tsPage);
		ApexPages.currentPage().getParameters().put('tsId',timeSheet.ID);
		ApexPages.currentPage().getParameters().put('projectId',project.ID);

		EE_CTRL_UserTimeSheetExtension extension = getExtension(new User_TimeSheet__c());
		PageReference pageRef = extension.saveUserTimeSheet();
		Test.setCurrentPageReference(pageRef);
		extension.sentForApproval();

		System.assertEquals(EE_SRV_TimeSheetManager.SENT_STATUS,extension.userTimeSheet.Status__c);

		Test.stopTest();
	}

	@isTest
	static void userTimeSheetOverdueTest(){
		Company_Project__c project = EE_UTL_TestUtils.initTestUserAndProjectAssociation('Test Project');
		TimeSheet__c timeSheet = EE_UTL_TestUtils.initDefaultTimeSheet();
		timeSheet.ReportTime__c = Datetime.newInstance(1970,1,14);
		update timeSheet;

		Test.startTest();

		PageReference tsPage = Page.EE_UserTimeSheet;
		Test.setCurrentPageReference(tsPage);
		ApexPages.currentPage().getParameters().put('tsId',timeSheet.ID);
		ApexPages.currentPage().getParameters().put('projectId',project.ID);

		EE_CTRL_UserTimeSheetExtension extension = getExtension(new User_TimeSheet__c());
		System.assert(extension.getDisableSaveButton());
		System.assertEquals(EE_SRV_TimeSheetManager.OVERDUE_STATUS,extension.userTimeSheet.Status__c);

		PageReference pageRef = extension.saveUserTimeSheet();
		System.assertEquals(null,pageRef);

		extension.saveOverdueUserTimeSheet();
		System.assert(extension.redirectAfterOverdueCheck);

		Test.stopTest();
	}

	@isTest
	static void sentForApprovalAndApprovedTest(){
		Company_Project__c project = EE_UTL_TestUtils.initTestUserAndProjectAssociation('Test Project');
		TimeSheet__c timeSheet = EE_UTL_TestUtils.initDefaultTimeSheet();

		Test.startTest();

		PageReference tsPage = Page.EE_UserTimeSheet;
		Test.setCurrentPageReference(tsPage);
		ApexPages.currentPage().getParameters().put('tsId',timeSheet.ID);
		ApexPages.currentPage().getParameters().put('projectId',project.ID);

		EE_CTRL_UserTimeSheetExtension extension = getExtension(new User_TimeSheet__c());

		PageReference pageRef = extension.saveUserTimeSheet();
		System.assertNotEquals(null,pageRef);

		Test.setCurrentPageReference(pageRef);
		Id savedTsId = ApexPages.currentPage().getParameters().get('id');
		User_TimeSheet__c savedTs = EE_DAO_TimeSheetDao.getUserTimeSheetById(savedTsId);
		extension = getExtension(savedTs);
		extension.sentForApproval();

		System.assertEquals(EE_SRV_TimeSheetManager.SENT_STATUS,extension.userTimeSheet.Status__c);
		System.assert(extension.userTimeSheet.Previously_Sent__c);

		extension.userTimeSheet.Status__c = EE_SRV_TimeSheetManager.APPROVED_STATUS;
		update extension.userTimeSheet;

		savedTS = EE_DAO_TimeSheetDao.getUserTimeSheetById(extension.userTimeSheet.ID);
		extension = getExtension(savedTs);
		System.assert(extension.getDisableSaveButton());
		extension.saveUserTimeSheet();
		System.assertEquals(EE_SRV_TimeSheetManager.APPROVED_STATUS,extension.userTimeSheet.Status__c);
		System.assert(extension.userTimeSheet.Previously_Sent__c);

		Test.stopTest();
	}

	@isTest
	static void rejectedAndApprovedTest(){
		Company_Project__c project = EE_UTL_TestUtils.initTestUserAndProjectAssociation('Test Project');
		TimeSheet__c timeSheet = EE_UTL_TestUtils.initDefaultTimeSheet();

		Test.startTest();

		PageReference tsPage = Page.EE_UserTimeSheet;
		Test.setCurrentPageReference(tsPage);
		ApexPages.currentPage().getParameters().put('tsId',timeSheet.ID);
		ApexPages.currentPage().getParameters().put('projectId',project.ID);

		EE_CTRL_UserTimeSheetExtension extension = getExtension(new User_TimeSheet__c());

		PageReference pageRef = extension.saveUserTimeSheet();
		System.assertNotEquals(null,pageRef);

		Test.setCurrentPageReference(pageRef);
		Id savedTsId = ApexPages.currentPage().getParameters().get('id');
		User_TimeSheet__c savedTs = EE_DAO_TimeSheetDao.getUserTimeSheetById(savedTsId);

		extension = getExtension(savedTs);
		extension.sentForApproval();
		System.assertEquals(EE_SRV_TimeSheetManager.SENT_STATUS,extension.userTimeSheet.Status__c);

		extension.userTimeSheet.Status__c = EE_SRV_TimeSheetManager.REJECTED_STATUS;
		update extension.userTimeSheet;

		savedTS = EE_DAO_TimeSheetDao.getUserTimeSheetById(extension.userTimeSheet.ID);
		extension = getExtension(savedTs);
		System.assert(!extension.getDisableSaveButton());
		pageRef = extension.saveUserTimeSheet();
		System.assertEquals(EE_SRV_TimeSheetManager.SUBMITTED_STATUS,extension.userTimeSheet.Status__c);

		Test.setCurrentPageReference(pageRef);
		savedTsId = ApexPages.currentPage().getParameters().get('id');
		savedTS = EE_DAO_TimeSheetDao.getUserTimeSheetById(savedTsId);
		extension = getExtension(savedTs);
		extension.sentForApproval();
		System.assertEquals(EE_SRV_TimeSheetManager.SENT_STATUS,extension.userTimeSheet.Status__c);

		extension.userTimeSheet.Status__c = EE_SRV_TimeSheetManager.APPROVED_STATUS;
		update extension.userTimeSheet;

		savedTS = EE_DAO_TimeSheetDao.getUserTimeSheetById(extension.userTimeSheet.ID);
		extension = getExtension(savedTs);
		extension.saveUserTimeSheet();
		System.assertEquals(EE_SRV_TimeSheetManager.APPROVED_STATUS,extension.userTimeSheet.Status__c);
		Test.stopTest();
	}

	@isTest
	static void vacationDaysTest(){
		Company_Project__c project = EE_UTL_TestUtils.initTestUserAndProjectAssociation('Test Project');
		TimeSheet__c timeSheet = EE_UTL_TestUtils.initDefaultTimeSheet();
		List<Vacation_Days__c> vacationDays = EE_UTL_TestUtils.initDefaultVacationDaysForTimeSheet(timeSheet);
		insert vacationDays;

		Test.startTest();
		PageReference tsPage = Page.EE_UserTimeSheet;
		Test.setCurrentPageReference(tsPage);
		ApexPages.currentPage().getParameters().put('tsId',timeSheet.ID);
		ApexPages.currentPage().getParameters().put('projectId',project.ID);

		EE_CTRL_UserTimeSheetExtension extension = getExtension(new User_TimeSheet__c());

		for(Vacation_Days__c vacationDay:vacationDays){
			Integer vacationWeekDay = EE_UTL_DateUtils.getWeekDayOfVacationDay(extension.timeSheet.StartDay__c,vacationDay.Vacation_Day__c);
			System.assert(extension.vacationDays.contains(vacationWeekDay));
		}

		System.assertEquals(25,extension.getItems().size());

		Test.stopTest();
	}

}
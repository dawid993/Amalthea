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
		EE_Test_UserTimeSheetUnit testUnit = new EE_Test_UserTimeSheetUnit();

		Test.startTest();

		testUnit.addParameterToPage('tsId',testUnit.unitTimeSheet.ID);
		testUnit.addParameterToPage('projectId',testUnit.unitProject.ID);
		testUnit.initNewExtension();
		testUnit.save();

		System.assertEquals(SUCCESS,testUnit.currentPage.getParameters().get('msg'));
		System.assertEquals(testUnit.extension.userTimeSheet.ID,testUnit.currentPage.getParameters().get('id'));

		Test.stopTest();
	}

	@isTest
	static void userTimeSheetCreatedAndSendTest(){
		EE_Test_UserTimeSheetUnit testUnit = new EE_Test_UserTimeSheetUnit();

		Test.startTest();

		testUnit.addParameterToPage('tsId',testUnit.unitTimeSheet.ID);
		testUnit.addParameterToPage('projectId',testUnit.unitProject.ID);
		testUnit.initNewExtension();
		testUnit.save();
		System.assertEquals(SUCCESS,testUnit.currentPage.getParameters().get('msg'));

		testUnit.sentForApproval();
		System.assertEquals(EE_SRV_TimeSheetManager.SENT_STATUS,testUnit.getCurrentUserTimeSheetStatus());

		Test.stopTest();
	}

	@isTest
	static void userTimeSheetOverdueTest(){
		EE_Test_UserTimeSheetUnit testUnit = new EE_Test_UserTimeSheetUnit();
		testUnit.unitTimeSheet.ReportTime__c = Datetime.newInstance(1970,1,14);
		update testUnit.unitTimeSheet;

		Test.startTest();

		testUnit.addParameterToPage('tsId',testUnit.unitTimeSheet.ID);
		testUnit.addParameterToPage('projectId',testUnit.unitProject.ID);
		testUnit.initNewExtension();

		System.assert(testUnit.extension.getDisableSaveButton());
		System.assertEquals(EE_SRV_TimeSheetManager.OVERDUE_STATUS,testUnit.getCurrentUserTimeSheetStatus());

		PageReference pageRef = testUnit.save();
		System.assertEquals(null,pageRef);

		testUnit.saveOverdue();
		System.assert(testUnit.isRedirectAfterOverdueCheck());

		Test.stopTest();
	}

	@isTest
	static void sentForApprovalAndApprovedTest(){
		EE_Test_UserTimeSheetUnit testUnit = new EE_Test_UserTimeSheetUnit();

		Test.startTest();

		testUnit.addParameterToPage('tsId',testUnit.unitTimeSheet.ID);
		testUnit.addParameterToPage('projectId',testUnit.unitProject.ID);
		testUnit.initNewExtension();

		PageReference pageRef = testUnit.save();
		System.assertNotEquals(null,pageRef);

		testUnit.sentForApproval();

		System.assertEquals(EE_SRV_TimeSheetManager.SENT_STATUS,testUnit.getCurrentUserTimeSheetStatus());
		System.assert(testUnit.extension.userTimeSheet.Previously_Sent__c);

		testUnit.approveUserTimeSheet();

		System.assert(testUnit.extension.getDisableSaveButton());

		testUnit.save();
		System.assertEquals(EE_SRV_TimeSheetManager.APPROVED_STATUS,testUnit.getCurrentUserTimeSheetStatus());
		System.assert(testUnit.extension.userTimeSheet.Previously_Sent__c);

		Test.stopTest();
	}

	@isTest
	static void rejectedAndApprovedTest(){
		EE_Test_UserTimeSheetUnit testUnit = new EE_Test_UserTimeSheetUnit();

		Test.startTest();

		testUnit.addParameterToPage('tsId',testUnit.unitTimeSheet.ID);
		testUnit.addParameterToPage('projectId',testUnit.unitProject.ID);
		testUnit.initNewExtension();

		PageReference pageRef = testUnit.save();
		System.assertNotEquals(null,pageRef);

		testUnit.rejectUserTimeSheet();

		testUnit.save();
		System.assertEquals(EE_SRV_TimeSheetManager.SUBMITTED_STATUS,testUnit.getCurrentUserTimeSheetStatus());

		testUnit.sentForApproval();
		System.assertEquals(EE_SRV_TimeSheetManager.SENT_STATUS,testUnit.getCurrentUserTimeSheetStatus());

		testUnit.approveUserTimeSheet();
		System.assertEquals(EE_SRV_TimeSheetManager.APPROVED_STATUS,testUnit.getCurrentUserTimeSheetStatus());
		Test.stopTest();
	}

	@isTest
	static void timeSheetAlreadySaved(){
		EE_Test_UserTimeSheetUnit testUnit = new EE_Test_UserTimeSheetUnit();

		Test.startTest();

		testUnit.addParameterToPage('tsId',testUnit.unitTimeSheet.ID);
		testUnit.addParameterToPage('projectId',testUnit.unitProject.ID);
		testUnit.initNewExtension();

		PageReference pageRef = testUnit.save();
		System.assertNotEquals(null,pageRef);

		testUnit.setCurrentTestPage(testUnit.getPageReference());
		testUnit.addParameterToPage('tsId',testUnit.unitTimeSheet.ID);
		testUnit.addParameterToPage('projectId',testUnit.unitProject.ID);
		testUnit.initNewExtension();
		testUnit.save();

		List<User_TimeSheet__c> userTimeSheets = [SELECT ID FROM User_TimeSheet__c];
		System.assertEquals(1,userTimeSheets.size());
		Test.stopTest();
	}

	@isTest
	static void notAlignedTest(){
		EE_Test_UserTimeSheetUnit testUnit = new EE_Test_UserTimeSheetUnit();

		Test.startTest();
		testUnit.initNewExtension();
		System.assert(ApexPages.hasMessages());
		Test.stopTest();
	}

	@isTest
	static void vacationDaysTest(){
		EE_Test_UserTimeSheetUnit testUnit = new EE_Test_UserTimeSheetUnit();
		List<Vacation_Days__c> vacationDays = testUnit.initVacationDays();

		Test.startTest();
		PageReference tsPage = Page.EE_UserTimeSheet;
		testUnit.addParameterToPage('tsId',testUnit.unitTimeSheet.ID);
		testUnit.addParameterToPage('projectId',testUnit.unitProject.ID);
		testUnit.initNewExtension();

		for(Vacation_Days__c vacationDay:vacationDays){
			Integer vacationWeekDay = EE_UTL_DateUtils.getWeekDayOfVacationDay(testUnit.extension.timeSheet.StartDay__c,vacationDay.Vacation_Day__c);
			System.assert(testUnit.extension.vacationDays.contains(vacationWeekDay));
		}

		System.assertEquals(25,testUnit.extension.getItems().size());

		Test.stopTest();
	}

}
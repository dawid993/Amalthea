@isTest
public class EE_TEST_CTRL_UserTimeSheetExtension {

	private static final String SUCCESS = 'success';

	@testSetup
	static void init(){
		insert EE_UTL_TestUtils.getTimeSheetConfiguration();
	}

	private static EE_CTRL_UserTimeSheetExtension getExtension(User_TimeSheet__c record){
		ApexPages.StandardController stdController = new ApexPages.StandardController(new User_TimeSheet__c());
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
}
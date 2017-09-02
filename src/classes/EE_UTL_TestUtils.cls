@isTest
public class EE_UTL_TestUtils {

	public static TimeSheet__c  getTimeSheet(Date startDate){
		return EE_SRV_TimeSheetManager.createTimeSheetProccess(startDate);
	}

	public static Company_Project__c getCompanyProject(String name,Boolean doInsert){
		Company_Project__c project = new Company_Project__c();
		project.Name = name;

		if(doInsert){
			insert project;
		}

		return project;
	}

	public static Company_Project_Assigment__c assignUserToProject(User projectUser,Company_Project__c project){
		Company_Project_Assigment__c assignment = new Company_Project_Assigment__c(User__c =projectUser.ID,Project__c =project.ID);
		insert assignment;

		return assignment;
	}

	public static User getCurrentUser(Id userId){
		return [SELECT Id FROM User Where id = :userId];
	}

	public static TimeSheetConfiguration__c getTimeSheetConfiguration(){
		TimeSheetConfiguration__c conf = new TimeSheetConfiguration__c(Name='Confing');
		conf.Hour__c = 14;
		conf.Minute__c = 0;
		conf.Second__c = 0;
		conf.Millisecond__c = 0;

		conf.Communicat_Date_Days__c = -2;
		conf.Report_Time_Days__c = 1;

		return conf;
	}

	public static Company_Project__c initTestUserAndProjectAssociation(String projectName){
		Company_Project__c project = EE_UTL_TestUtils.getCompanyProject(projectName,true);
		EE_UTL_TestUtils.assignUserToProject(EE_UTL_TestUtils.getCurrentUser(UserInfo.getUserId()),project);

		return project;
	}

	public static TimeSheet__c initDefaultTimeSheet(){
		Date startDate = Date.newInstance(2099,1,14);
		TimeSheet__c timeSheet = EE_UTL_TestUtils.getTimeSheet(startDate);

		return timeSheet;
	}
}
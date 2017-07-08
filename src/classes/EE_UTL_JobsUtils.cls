public class EE_UTL_JobsUtils {

	public static String generateCronExp(DateTime baseDate){	
		if(baseDate == null){
			return null;
		}	
		
		Integer seconds = baseDate.second();
		Integer minutes = baseDate.minute();
		Integer hour = baseDate.hour();
		Integer dayOfMonth = baseDate.day();
		Integer month = baseDate.month();
		Integer year = baseDate.year();

		return seconds +' '+ minutes +' '+ hour +' '+ dayOfMonth +' '+ month +' ? '+ year;
	}

	public static void abortTimeSheetProcess(ID jobId){
		System.abortJob(jobId);
	}
}
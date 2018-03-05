global with sharing class AMT_DAO_DateFunction {
	private DateFunctions dateFunction;
	private String fieldName;

	global AMT_DAO_DateFunction(DateFunctions dateFunction,String fieldName) {
		this.dateFunction =	dateFunction;
		this.fieldName = fieldName;
	}

	public String evaluate(){
		return dateFunction.name() +'('+fieldName+')';
	}

	global enum DateFunctions{
		CALENDAR_MONTH,
		CALENDAR_QUARTER,
		CALENDAR_YEAR,
		DAY_IN_MONTH,
		DAY_IN_WEEK,
		DAY_IN_YEAR,
		DAY_ONLY,
		FISCAL_MONTH,
		FISCAL_QUARTER,
		FISCAL_YEAR,
		HOUR_IN_DAY,
		WEEK_IN_MONTH,
		WEEK_IN_YEAR
	}
}
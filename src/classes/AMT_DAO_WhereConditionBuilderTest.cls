@isTest
public class AMT_DAO_WhereConditionBuilderTest {

	/*
	* Syntaxt testing
	*
	*/

//	private static AMT_DAO_ConditionBuilder getConditionBuilder(){
//		return new AMT_DAO_WhereConditionBuilderImp();
//	}
//
//	@isTest
//	public static void andSyntaxtTest(){
//		String expectedOut = '((Name = \'TestName\') AND (IsInactive = false))';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeAnd();
//		conditionBuilder.makeEq('Name','TestName');
//		conditionBuilder.makeEq('IsInactive',false);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void orSyntaxtTest(){
//		String expectedOut = '((Name = \'TestName\') OR (IsInactive = false))';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeOr();
//		conditionBuilder.makeEq('Name','TestName');
//		conditionBuilder.makeEq('IsInactive',false);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void notSyntaxtTest(){
//		String expectedOut = '( NOT (Name = \'TestName\'))';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNot();
//		conditionBuilder.makeEq('Name','TestName');
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void complexAndLogicSyntaxtTest(){
//		String expectedOut = '((( NOT (Name = \'TestName\')) OR (Name = \'NameTest\')) AND ((IsDeleted != true) AND (AnnualRevenue = 12)))';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeAnd();
//		conditionBuilder.makeOr();
//		conditionBuilder.makeNot();
//		conditionBuilder.makeEq('Name','TestName');
//		conditionBuilder.makeEq('Name','NameTest');
//		conditionBuilder.makeAnd();
//		conditionBuilder.makeNotEq('IsDeleted',true);
//		conditionBuilder.makeEq('AnnualRevenue',12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//
//	}
//
//	@isTest
//	public static void complexNotLogicSyntaxtTest(){
//		String expectedOut = '( NOT (((Name = \'TestName\') OR (Name = \'NameTest\')) AND ( NOT (AnnualRevenue > 12))))';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNot();
//		conditionBuilder.makeAnd();
//		conditionBuilder.makeOr();
//		conditionBuilder.makeEq('Name','TestName');
//		conditionBuilder.makeEq('Name','NameTest');
//		conditionBuilder.makeNot();
//		conditionBuilder.makeGt('AnnualRevenue',12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//
//	}
//
//	@isTest
//	public static void complexNotOrLogicSyntaxtTest(){
//		String expectedOut = '( NOT ((Name = \'TestName\') OR (Name = \'NameTest\')))';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNot();
//		conditionBuilder.makeOr();
//		conditionBuilder.makeEq('Name','TestName');
//		conditionBuilder.makeEq('Name','NameTest');
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//
//	}
//
//	@isTest
//	public static void complexNotAndLogicSyntaxtTest(){
//		String expectedOut = '(( NOT (Name = \'TestName\')) AND (AnnualRevenue > 12))';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeAnd();
//		conditionBuilder.makeNot();
//		conditionBuilder.makeEq('Name','TestName');
//		conditionBuilder.makeGt('AnnualRevenue',12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//
//	}
//
//	@isTest
//	public static void eqStringSyntaxtTest(){
//		String expectedOut = '(Name = \'Test Name\')';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('Name','Test Name');
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void eqNullSyntaxtTest(){
//		String expectedOut = '(Name = null)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('Name',AMT_DAO_UTL_DaoUtils.NULL_VALUE);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void eqIntegerSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue = 12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('AnnualRevenue',12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void eqLongSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue = 1212121212)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('AnnualRevenue',1212121212l);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void eqDecimalSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue = 121.12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('AnnualRevenue',121.12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void eqTrueBooleanSyntaxtTest(){
//		String expectedOut = '(IsDeleted = true)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('IsDeleted',true);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void eqFalseBooleanSyntaxtTest(){
//		String expectedOut = '(IsDeleted = false)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('IsDeleted',false);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void TodaySyntaxTest(){
//		String expectedOut = '(CreatedDate = TODAY)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TODAY,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void TodayWithParamSyntaxTest(){
//		String expectedOut = '(CreatedDate = TODAY)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TODAY,12);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void TomorrowSyntaxTest(){
//		String expectedOut = '(CreatedDate = TOMORROW)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TOMORROW,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void YesterdaySyntaxTest(){
//		String expectedOut = '(CreatedDate = YESTERDAY)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.YESTERDAY,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void ThisWeekSyntaxTest(){
//		String expectedOut = '(CreatedDate = THIS_WEEK)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_WEEK,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NextWeekSyntaxTest(){
//		String expectedOut = '(CreatedDate = NEXT_WEEK)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_WEEK,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LastMonthSyntaxTest(){
//		String expectedOut = '(CreatedDate = LAST_MONTH)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_MONTH,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void ThisMonthSyntaxTest(){
//		String expectedOut = '(CreatedDate = THIS_MONTH)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_MONTH,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NextMonthSyntaxTest(){
//		String expectedOut = '(CreatedDate = NEXT_MONTH)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_MONTH,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void Last90DaysSyntaxTest(){
//		String expectedOut = '(CreatedDate = LAST_90_DAYS)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_90_DAYS,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void Next90DaysWeekSyntaxTest(){
//		String expectedOut = '(CreatedDate = NEXT_90_DAYS)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_90_DAYS,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LastQuarterSyntaxTest(){
//		String expectedOut = '(CreatedDate = LAST_QUARTER)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_QUARTER,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void ThisQuarterWeekSyntaxTest(){
//		String expectedOut = '(CreatedDate = THIS_QUARTER)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_QUARTER,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void ThisYearWeekSyntaxTest(){
//		String expectedOut = '(CreatedDate = THIS_YEAR)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_YEAR,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LastYearWeekSyntaxTest(){
//		String expectedOut = '(CreatedDate = LAST_YEAR)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_YEAR,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NextYearWeekSyntaxTest(){
//		String expectedOut = '(CreatedDate = NEXT_YEAR)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_YEAR,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void ThisFiscalQuarterSyntaxTest(){
//		String expectedOut = '(CreatedDate = THIS_FISCAL_QUARTER)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_FISCAL_QUARTER,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LastFiscalQuarterSyntaxTest(){
//		String expectedOut = '(CreatedDate = LAST_FISCAL_QUARTER)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_FISCAL_QUARTER,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NextFiscalQuarterSyntaxTest(){
//		String expectedOut = '(CreatedDate = NEXT_FISCAL_QUARTER)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_FISCAL_QUARTER,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void ThisFiscalYearSyntaxTest(){
//		String expectedOut = '(CreatedDate = THIS_FISCAL_YEAR)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_FISCAL_YEAR,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NextFiscalYearSyntaxTest(){
//		String expectedOut = '(CreatedDate = NEXT_FISCAL_YEAR)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_FISCAL_YEAR,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LastFiscalYearSyntaxTest(){
//		String expectedOut = '(CreatedDate = LAST_FISCAL_YEAR)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_FISCAL_YEAR,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LastNdaysSyntaxTest(){
//		String expectedOut = '(CreatedDate = LAST_N_DAYS:12)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_N_DAYS_n,12);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NextNmonthsSyntaxTest(){
//		String expectedOut = '(CreatedDate = NEXT_N_MONTHS:2)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_N_MONTHS_n,2);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LastNYearsSyntaxTest(){
//		String expectedOut = '(CreatedDate = LAST_N_YEARS:2)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_N_YEARS_n,2);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LastNquartesSyntaxTest(){
//		String expectedOut = '(CreatedDate = LAST_N_QUARTERS:2)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_N_QUARTERS_n,2);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NextNquartesSyntaxTest(){
//		String expectedOut = '(CreatedDate = NEXT_N_QUARTERS:2)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_N_QUARTERS_n,2);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void CalendarMonthSyntaxTest(){
//		String expectedOut = '(CALENDAR_MONTH(CreatedDate) = 12)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.CALENDAR_MONTH,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void CalendarQuarterSyntaxTest(){
//		String expectedOut = '(CALENDAR_QUARTER(CreatedDate) = 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.CALENDAR_QUARTER,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void CalendarYearSyntaxTest(){
//		String expectedOut = '(CALENDAR_YEAR(CreatedDate) = 2017)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.CALENDAR_YEAR,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,2017);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void DayInMonthSyntaxTest(){
//		String expectedOut = '(DAY_IN_MONTH(CreatedDate) = 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_IN_MONTH,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void DayInWeekSyntaxTest(){
//		String expectedOut = '(DAY_IN_WEEK(CreatedDate) = 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_IN_WEEK,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void DayInSyntaxTest(){
//		String expectedOut = '(DAY_IN_YEAR(CreatedDate) = 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_IN_YEAR,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void FiscalMonthSyntaxTest(){
//		String expectedOut = '(FISCAL_MONTH(CreatedDate) = 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.FISCAL_MONTH,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void FiscalQuarterSyntaxTest(){
//		String expectedOut = '(FISCAL_QUARTER(CreatedDate) = 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.FISCAL_QUARTER,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void FiscalYearSyntaxTest(){
//		String expectedOut = '(FISCAL_YEAR(CreatedDate) = 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.FISCAL_YEAR,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void HourInDaySyntaxTest(){
//		String expectedOut = '(HOUR_IN_DAY(CreatedDate) = 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.HOUR_IN_DAY,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void WeakInMonthSyntaxTest(){
//		String expectedOut = '(WEEK_IN_MONTH(CreatedDate) = 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_MONTH,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void WeekInYearSyntaxTest(){
//		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) = 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NotEqStringSyntaxtTest(){
//		String expectedOut = '(Name != \'Test Name\')';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNotEq('Name','Test Name');
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NotEqNullSyntaxtTest(){
//		String expectedOut = '(Name != null)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNotEq('Name',AMT_DAO_UTL_DaoUtils.NULL_VALUE);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NotEqIntegerSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue != 12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNotEq('AnnualRevenue',12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NotEqLongSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue != 1212121212)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNotEq('AnnualRevenue',1212121212l);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NotEqDecimalSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue != 121.12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNotEq('AnnualRevenue',121.12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NotEqTrueBooleanSyntaxtTest(){
//		String expectedOut = '(IsDeleted != true)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNotEq('IsDeleted',true);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NotEqFalseBooleanSyntaxtTest(){
//		String expectedOut = '(IsDeleted != false)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNotEq('IsDeleted',false);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NotTodaySyntaxTest(){
//		String expectedOut = '(CreatedDate != TODAY)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TODAY,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNotEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void NotWeekInYearSyntaxTest(){
//		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) != 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeNotEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LtStringSyntaxtTest(){
//		String expectedOut = '(Name < \'Test Name\')';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLt('Name','Test Name');
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LtIntegerSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue < 12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLt('AnnualRevenue',12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LtLongSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue < 1212121212)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLt('AnnualRevenue',1212121212l);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LtDecimalSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue < 121.12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLt('AnnualRevenue',121.12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//
//	@isTest
//	public static void LtTodaySyntaxTest(){
//		String expectedOut = '(CreatedDate < TODAY)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TODAY,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLt('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LtWeekInYearSyntaxTest(){
//		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) < 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLt(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LtorEqStringSyntaxtTest(){
//		String expectedOut = '(Name <= \'Test Name\')';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLtOrEq('Name','Test Name');
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LtorEqIntegerSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue <= 12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLtOrEq('AnnualRevenue',12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LtorEqLongSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue <= 1212121212)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLtOrEq('AnnualRevenue',1212121212l);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LtorEqDecimalSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue <= 121.12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLtOrEq('AnnualRevenue',121.12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//
//	@isTest
//	public static void LtorEqTodaySyntaxTest(){
//		String expectedOut = '(CreatedDate <= TODAY)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TODAY,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLtOrEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void LtorEqeekInYearSyntaxTest(){
//		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) <= 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeLtOrEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtStringSyntaxtTest(){
//		String expectedOut = '(Name > \'Test Name\')';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGt('Name','Test Name');
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtIntegerSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue > 12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGt('AnnualRevenue',12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtLongSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue > 1212121212)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGt('AnnualRevenue',1212121212l);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtDecimalSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue > 121.12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGt('AnnualRevenue',121.12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//
//	@isTest
//	public static void GtTodaySyntaxTest(){
//		String expectedOut = '(CreatedDate > TODAY)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TODAY,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGt('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtWeekInYearSyntaxTest(){
//		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) > 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGt(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtorEqStringSyntaxtTest(){
//		String expectedOut = '(Name >= \'Test Name\')';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGtorEq('Name','Test Name');
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtorEqIntegerSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue >= 12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGtorEq('AnnualRevenue',12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtorEqLongSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue >= 1212121212)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGtorEq('AnnualRevenue',1212121212l);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtorEqDecimalSyntaxtTest(){
//		String expectedOut = '(AnnualRevenue >= 121.12)';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGtorEq('AnnualRevenue',121.12);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtorEqTodaySyntaxTest(){
//		String expectedOut = '(CreatedDate >= TODAY)';
//		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TODAY,null);
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGtorEq('CreatedDate',dateLiteral);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void GtorEqWeekInYearSyntaxTest(){
//		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) >= 4)';
//		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeGtorEq(dateFunction,4);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void eqDateSyntaxTest(){
//		Date dateInstance = Date.newInstance(2012, 2, 1);
//		String expectedOut = '(DateField = '+String.valueOf(dateInstance)+')';
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('DateField',dateInstance);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}
//
//	@isTest
//	public static void eqDateTimeSyntaxTest(){
//		DateTime dateTimeInstance = DateTime.newInstance(2012, 2, 1,12,0,0);
//		String expectedOut = '(CreatedDate = '+dateTimeInstance.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''+')');
//		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
//		conditionBuilder.makeEq('CreatedDate',dateTimeInstance,null);
//
//		System.assertEquals(expectedOut,conditionBuilder.evaluate());
//	}




}

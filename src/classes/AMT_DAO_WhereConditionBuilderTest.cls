@isTest
public class AMT_DAO_WhereConditionBuilderTest {

	/*
	* Syntaxt testing
	*
	*/

	private static AMT_DAO_ConditionBuilder getConditionBuilder(){
		return new AMT_DAO_WhereConditionBuilderImp();
	}

	@isTest 
	public static void andSyntaxtTest(){
		String expectedOut = '((Name = \'TestName\') AND (IsInactive = false))';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeAnd();
		conditionBuilder.makeEq('Name','TestName');
		conditionBuilder.makeEq('IsInactive',false);

		System.assertEquals(expectedOut,conditionBuilder.evaluate());
	}

	@isTest 
	public static void orSyntaxtTest(){
		String expectedOut = '((Name = \'TestName\') OR (IsInactive = false))';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeOr();
		conditionBuilder.makeEq('Name','TestName');
		conditionBuilder.makeEq('IsInactive',false);

		System.assertEquals(expectedOut,conditionBuilder.evaluate());
	}

	@isTest 
	public static void notSyntaxtTest(){
		String expectedOut = '( NOT (Name = \'TestName\'))';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeNot();
		conditionBuilder.makeEq('Name','TestName');		
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());
	}

	@isTest 
	public static void complexAndLogicSyntaxtTest(){
		String expectedOut = '((( NOT (Name = \'TestName\')) OR (Name = \'NameTest\')) AND ((IsDeleted != true) AND (AnnualRevenue = 12)))';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeAnd();
		conditionBuilder.makeOr();
		conditionBuilder.makeNot();
		conditionBuilder.makeEq('Name','TestName');
		conditionBuilder.makeEq('Name','NameTest');	
		conditionBuilder.makeAnd();
		conditionBuilder.makeNotEq('IsDeleted',true);
		conditionBuilder.makeEq('AnnualRevenue',12);	
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());
		
	}

	@isTest 
	public static void complexNotLogicSyntaxtTest(){
		String expectedOut = '( NOT (((Name = \'TestName\') OR (Name = \'NameTest\')) AND ( NOT (AnnualRevenue > 12))))';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeNot();
		conditionBuilder.makeAnd();
		conditionBuilder.makeOr();
		conditionBuilder.makeEq('Name','TestName');
		conditionBuilder.makeEq('Name','NameTest');	
		conditionBuilder.makeNot();
		conditionBuilder.makeGt('AnnualRevenue',12);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());
		
	}

	@isTest 
	public static void complexNotOrLogicSyntaxtTest(){
		String expectedOut = '( NOT ((Name = \'TestName\') OR (Name = \'NameTest\')))';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeNot();
		conditionBuilder.makeOr();
		conditionBuilder.makeEq('Name','TestName');
		conditionBuilder.makeEq('Name','NameTest');	
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());
		
	}

	@isTest 
	public static void complexNotAndLogicSyntaxtTest(){
		String expectedOut = '(( NOT (Name = \'TestName\')) AND (AnnualRevenue > 12))';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeAnd();
		conditionBuilder.makeNot();
		conditionBuilder.makeEq('Name','TestName');
		conditionBuilder.makeGt('AnnualRevenue',12);	
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());
		
	}

	@isTest 
	public static void eqStringSyntaxtTest(){
		String expectedOut = '(Name = \'Test Name\')';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('Name','Test Name');
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void eqNullSyntaxtTest(){
		String expectedOut = '(Name = null)';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('Name',AMT_DAO_UTL_DaoUtils.NULL_VALUE);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void eqIntegerSyntaxtTest(){
		String expectedOut = '(AnnualRevenue = 12)';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('AnnualRevenue',12);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void eqLongSyntaxtTest(){
		String expectedOut = '(AnnualRevenue = 1212121212)';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('AnnualRevenue',1212121212l);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void eqDecimalSyntaxtTest(){
		String expectedOut = '(AnnualRevenue = 121.12)';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('AnnualRevenue',121.12);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void eqTrueBooleanSyntaxtTest(){
		String expectedOut = '(IsDeleted = true)';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('IsDeleted',true);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void eqFalseBooleanSyntaxtTest(){
		String expectedOut = '(IsDeleted = false)';
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('IsDeleted',false);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void TodaySyntaxTest(){
		String expectedOut = '(CreatedDate = TODAY)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TODAY,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void TodayWithParamSyntaxTest(){
		String expectedOut = '(CreatedDate = TODAY)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TODAY,12);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void TomorrowSyntaxTest(){
		String expectedOut = '(CreatedDate = TOMORROW)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.TOMORROW,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void YesterdaySyntaxTest(){
		String expectedOut = '(CreatedDate = YESTERDAY)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.YESTERDAY,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void ThisWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_WEEK)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_WEEK,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void NextWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_WEEK)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_WEEK,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void LastMonthSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_MONTH)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_MONTH,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void ThisMonthSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_MONTH)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_MONTH,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void NextMonthSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_MONTH)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_MONTH,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void Last90DaysSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_90_DAYS)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_90_DAYS,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void Next90DaysWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_90_DAYS)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_90_DAYS,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void LastQuarterSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_QUARTER)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_QUARTER,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void ThisQuarterWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_QUARTER)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_QUARTER,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void ThisYearWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_YEAR)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_YEAR,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void LastYearWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_YEAR)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_YEAR,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void NextYearWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_YEAR)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_YEAR,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void ThisFiscalQuarterSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_FISCAL_QUARTER)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_FISCAL_QUARTER,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void LastFiscalQuarterSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_FISCAL_QUARTER)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_FISCAL_QUARTER,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void NextFiscalQuarterSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_FISCAL_QUARTER)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_FISCAL_QUARTER,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void ThisFiscalYearSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_FISCAL_YEAR)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.THIS_FISCAL_YEAR,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void NextFiscalYearSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_FISCAL_YEAR)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_FISCAL_YEAR,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void LastFiscalYearSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_FISCAL_YEAR)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_FISCAL_YEAR,null);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void LastNdaysSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_N_DAYS:12)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_N_DAYS_n,12);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}	

	@isTest 
	public static void NextNmonthsSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_N_MONTHS:2)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_N_MONTHS_n,2);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void LastNYearsSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_N_YEARS:2)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_N_YEARS_n,2);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void LastNquartesSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_N_QUARTERS:2)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.LAST_N_QUARTERS_n,2);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}

	@isTest 
	public static void NextNquartesSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_N_QUARTERS:2)';
		AMT_DAO_DateLiterals dateLiteral = new AMT_DAO_DateLiterals(AMT_DAO_DateLiterals.DateLiterals.NEXT_N_QUARTERS_n,2);
		AMT_DAO_ConditionBuilder conditionBuilder = getConditionBuilder();
		conditionBuilder.makeEq('CreatedDate',dateLiteral);
		
		System.assertEquals(expectedOut,conditionBuilder.evaluate());		
	}


}

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
	@TestSetup
	public static void setupServicesSetting(){
		AMT_ServiceConfiguration__c conditionBuilderImplementation = new AMT_ServiceConfiguration__c(Name =
				AMT_DAO_ServiceProvider.CONDITION_BUILDER_SETTING,ServiceName__c = 'AMT_DAO_WhereConditionBuilderImp');
		AMT_ServiceConfiguration__c conditionNodeImplementation = new AMT_ServiceConfiguration__c(Name =
				AMT_DAO_ServiceProvider.CONDITION_NODE_SETTING, ServiceName__c = 'AMT_DAO_ConditionNode');
		AMT_ServiceConfiguration__c conditionStructureImplementation = new AMT_ServiceConfiguration__c(Name =
				AMT_DAO_ServiceProvider.CONDITION_BUILDER_STRUCTURE_SETTING,ServiceName__c = 'AMT_DAO_ConditionBuilderStructureImp');
		AMT_ServiceConfiguration__c logicalNodeImplementation = new AMT_ServiceConfiguration__c(Name =
				AMT_DAO_ServiceProvider.LOGICAL_NODE_SETTING, ServiceName__c = 'AMT_DAO_LogicalNode');

		insert new List<AMT_ServiceConfiguration__c>{conditionBuilderImplementation,
			 conditionNodeImplementation,
			 conditionStructureImplementation,
			 logicalNodeImplementation
		};

	}

	@isTest
	public static void andSyntaxtTest(){
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		String expectedOut = '((Name = \'TestName\') AND (IsInactive = false))';
		queryBuilder.makeAnd();
		queryBuilder.makeEq('Name','TestName');
		queryBuilder.makeEq('IsInactive',false);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void orSyntaxtTest(){
		String expectedOut = '((Name = \'TestName\') OR (IsInactive = false))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeOr();
		queryBuilder.makeEq('Name','TestName');
		queryBuilder.makeEq('IsInactive',false);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void notSyntaxtTest(){
		String expectedOut = '( NOT (Name = \'TestName\'))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNot();
		queryBuilder.makeEq('Name','TestName');

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void complexAndLogicSyntaxtTest(){
		String expectedOut = '((( NOT (Name = \'TestName\')) OR (Name = \'NameTest\')) AND ((IsDeleted != true) AND (AnnualRevenue = 12)))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeAnd();
		queryBuilder.makeOr();
		queryBuilder.makeNot();
		queryBuilder.makeEq('Name','TestName');
		queryBuilder.makeEq('Name','NameTest');
		queryBuilder.makeAnd();
		queryBuilder.makeNotEq('IsDeleted',true);
		queryBuilder.makeEq('AnnualRevenue',12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());

	}

	@isTest
	public static void complexNotLogicSyntaxtTest(){
		String expectedOut = '( NOT (((Name = \'TestName\') OR (Name = \'NameTest\')) AND ( NOT (AnnualRevenue > 12))))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNot();
		queryBuilder.makeAnd();
		queryBuilder.makeOr();
		queryBuilder.makeEq('Name','TestName');
		queryBuilder.makeEq('Name','NameTest');
		queryBuilder.makeNot();
		queryBuilder.makeGt('AnnualRevenue',12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());

	}

	@isTest
	public static void complexNotOrLogicSyntaxtTest(){
		String expectedOut = '( NOT ((Name = \'TestName\') OR (Name = \'NameTest\')))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNot();
		queryBuilder.makeOr();
		queryBuilder.makeEq('Name','TestName');
		queryBuilder.makeEq('Name','NameTest');

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());

	}

	@isTest
	public static void complexNotAndLogicSyntaxtTest(){
		String expectedOut = '(( NOT (Name = \'TestName\')) AND (AnnualRevenue > 12))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeAnd();
		queryBuilder.makeNot();
		queryBuilder.makeEq('Name','TestName');
		queryBuilder.makeGt('AnnualRevenue',12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void eqStringSyntaxtTest(){
		String expectedOut = '(Name = \'Test Name\')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('Name','Test Name');

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void eqNullSyntaxtTest(){
		String expectedOut = '(Name = null)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('Name',AMT_DAO_UTL_DaoUtils.NULL_VALUE);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void eqIntegerSyntaxtTest(){
		String expectedOut = '(AnnualRevenue = 12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('AnnualRevenue',12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void eqLongSyntaxtTest(){
		String expectedOut = '(AnnualRevenue = 1212121212)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('AnnualRevenue',1212121212l);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void eqDoubleSyntaxtTest(){
		String expectedOut = '(AnnualRevenue = 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('AnnualRevenue',Double.valueOf(121.12));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void eqDecimalSyntaxtTest(){
		String expectedOut = '(AnnualRevenue = 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('AnnualRevenue',Decimal.valueOf(Double.valueOf(121.12)));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void eqTrueBooleanSyntaxtTest(){
		String expectedOut = '(IsDeleted = true)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('IsDeleted',true);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void eqFalseBooleanSyntaxtTest(){
		String expectedOut = '(IsDeleted = false)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('IsDeleted',false);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void TodaySyntaxTest(){
		String expectedOut = '(CreatedDate = TODAY)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.TODAY,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void TodayWithParamSyntaxTest(){
		String expectedOut = '(CreatedDate = TODAY)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.TODAY,12);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void TomorrowSyntaxTest(){
		String expectedOut = '(CreatedDate = TOMORROW)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.TOMORROW,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void YesterdaySyntaxTest(){
		String expectedOut = '(CreatedDate = YESTERDAY)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.YESTERDAY,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ThisWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_WEEK)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.THIS_WEEK,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NextWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_WEEK)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.NEXT_WEEK,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LastMonthSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_MONTH)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.LAST_MONTH,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ThisMonthSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_MONTH)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.THIS_MONTH,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NextMonthSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_MONTH)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.NEXT_MONTH,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void Last90DaysSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_90_DAYS)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.LAST_90_DAYS,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void Next90DaysWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_90_DAYS)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.NEXT_90_DAYS,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LastQuarterSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_QUARTER)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.LAST_QUARTER,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ThisQuarterWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_QUARTER)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.THIS_QUARTER,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ThisYearWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_YEAR)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.THIS_YEAR,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LastYearWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_YEAR)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.LAST_YEAR,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NextYearWeekSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_YEAR)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.NEXT_YEAR,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ThisFiscalQuarterSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_FISCAL_QUARTER)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.THIS_FISCAL_QUARTER,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LastFiscalQuarterSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_FISCAL_QUARTER)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.LAST_FISCAL_QUARTER,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NextFiscalQuarterSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_FISCAL_QUARTER)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.NEXT_FISCAL_QUARTER,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ThisFiscalYearSyntaxTest(){
		String expectedOut = '(CreatedDate = THIS_FISCAL_YEAR)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.THIS_FISCAL_YEAR,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NextFiscalYearSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_FISCAL_YEAR)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.NEXT_FISCAL_YEAR,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LastFiscalYearSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_FISCAL_YEAR)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.LAST_FISCAL_YEAR,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LastNdaysSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_N_DAYS:12)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.LAST_N_DAYS_n,12);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NextNmonthsSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_N_MONTHS:2)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.NEXT_N_MONTHS_n,2);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LastNYearsSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_N_YEARS:2)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.LAST_N_YEARS_n,2);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LastNquartesSyntaxTest(){
		String expectedOut = '(CreatedDate = LAST_N_QUARTERS:2)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.LAST_N_QUARTERS_n,2);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NextNquartesSyntaxTest(){
		String expectedOut = '(CreatedDate = NEXT_N_QUARTERS:2)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.NEXT_N_QUARTERS_n,2);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void CalendarMonthSyntaxTest(){
		String expectedOut = '(CALENDAR_QUARTER(CreatedDate) = 12)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.CALENDAR_QUARTER,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void CalendarQuarterSyntaxTest(){
		String expectedOut = '(CALENDAR_QUARTER(CreatedDate) = 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.CALENDAR_QUARTER,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void dayOnlySyntaxTest(){
		String expectedOut = '(DAY_ONLY(CreatedDate) = 2012-09-09)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_ONLY,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,Date.newInstance(2012,9,9));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void CalendarYearSyntaxTest(){
		String expectedOut = '(CALENDAR_YEAR(CreatedDate) = 2017)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.CALENDAR_YEAR,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,2017);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void DayInMonthSyntaxTest(){
		String expectedOut = '(DAY_IN_MONTH(CreatedDate) = 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_IN_MONTH,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void DayInWeekSyntaxTest(){
		String expectedOut = '(DAY_IN_WEEK(CreatedDate) = 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_IN_WEEK,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void DayInSyntaxTest(){
		String expectedOut = '(DAY_IN_YEAR(CreatedDate) = 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_IN_YEAR,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void FiscalMonthSyntaxTest(){
		String expectedOut = '(FISCAL_MONTH(CreatedDate) = 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.FISCAL_MONTH,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void FiscalQuarterSyntaxTest(){
		String expectedOut = '(FISCAL_QUARTER(CreatedDate) = 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.FISCAL_QUARTER,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void FiscalYearSyntaxTest(){
		String expectedOut = '(FISCAL_YEAR(CreatedDate) = 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.FISCAL_YEAR,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void HourInDaySyntaxTest(){
		String expectedOut = '(HOUR_IN_DAY(CreatedDate) = 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.HOUR_IN_DAY,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void WeakInMonthSyntaxTest(){
		String expectedOut = '(WEEK_IN_MONTH(CreatedDate) = 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_MONTH,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void WeekInYearSyntaxTest(){
		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) = 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NotEqStringSyntaxtTest(){
		String expectedOut = '(Name != \'Test Name\')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('Name','Test Name');

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NotEqNullSyntaxtTest(){
		String expectedOut = '(Name != null)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('Name',AMT_DAO_UTL_DaoUtils.NULL_VALUE);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NotEqIntegerSyntaxtTest(){
		String expectedOut = '(AnnualRevenue != 12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('AnnualRevenue',12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NotEqLongSyntaxtTest(){
		String expectedOut = '(AnnualRevenue != 1212121212)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('AnnualRevenue',1212121212l);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NotEqDecimalSyntaxtTest(){
		String expectedOut = '(AnnualRevenue != 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('AnnualRevenue',121.12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NotEqTrueBooleanSyntaxtTest(){
		String expectedOut = '(IsDeleted != true)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('IsDeleted',true);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NotEqFalseBooleanSyntaxtTest(){
		String expectedOut = '(IsDeleted != false)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('IsDeleted',false);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NotTodaySyntaxTest(){
		String expectedOut = '(CreatedDate != TODAY)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.TODAY,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void NotWeekInYearSyntaxTest(){
		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) != 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LtStringSyntaxtTest(){
		String expectedOut = '(Name < \'Test Name\')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLt('Name','Test Name');

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LtIntegerSyntaxtTest(){
		String expectedOut = '(AnnualRevenue < 12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLt('AnnualRevenue',12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LtLongSyntaxtTest(){
		String expectedOut = '(AnnualRevenue < 1212121212)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLt('AnnualRevenue',1212121212l);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LtDecimalSyntaxtTest(){
		String expectedOut = '(AnnualRevenue < 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLt('AnnualRevenue',121.12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}


	@isTest
	public static void LtTodaySyntaxTest(){
		String expectedOut = '(CreatedDate < TODAY)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.TODAY,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLt('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LtWeekInYearSyntaxTest(){
		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) < 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLt(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LtorEqStringSyntaxtTest(){
		String expectedOut = '(Name <= \'Test Name\')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLtOrEq('Name','Test Name');

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LtorEqIntegerSyntaxtTest(){
		String expectedOut = '(AnnualRevenue <= 12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLtOrEq('AnnualRevenue',12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LtorEqLongSyntaxtTest(){
		String expectedOut = '(AnnualRevenue <= 1212121212)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLtOrEq('AnnualRevenue',1212121212l);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LtorEqDecimalSyntaxtTest(){
		String expectedOut = '(AnnualRevenue <= 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLtOrEq('AnnualRevenue',121.12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}


	@isTest
	public static void LtorEqTodaySyntaxTest(){
		String expectedOut = '(CreatedDate <= TODAY)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.TODAY,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLtOrEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void LtorEqeekInYearSyntaxTest(){
		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) <= 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLtOrEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtStringSyntaxtTest(){
		String expectedOut = '(Name > \'Test Name\')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGt('Name','Test Name');

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtIntegerSyntaxtTest(){
		String expectedOut = '(AnnualRevenue > 12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGt('AnnualRevenue',12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtLongSyntaxtTest(){
		String expectedOut = '(AnnualRevenue > 1212121212)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGt('AnnualRevenue',1212121212l);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtDecimalSyntaxtTest(){
		String expectedOut = '(AnnualRevenue > 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGt('AnnualRevenue',121.12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}


	@isTest
	public static void GtTodaySyntaxTest(){
		String expectedOut = '(CreatedDate > TODAY)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.TODAY,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGt('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtWeekInYearSyntaxTest(){
		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) > 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGt(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtorEqStringSyntaxtTest(){
		String expectedOut = '(Name >= \'Test Name\')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGtorEq('Name','Test Name');

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtorEqIntegerSyntaxtTest(){
		String expectedOut = '(AnnualRevenue >= 12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGtorEq('AnnualRevenue',12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtorEqLongSyntaxtTest(){
		String expectedOut = '(AnnualRevenue >= 1212121212)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGtorEq('AnnualRevenue',1212121212l);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtorEqDecimalSyntaxtTest(){
		String expectedOut = '(AnnualRevenue >= 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGtorEq('AnnualRevenue',121.12);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtorEqTodaySyntaxTest(){
		String expectedOut = '(CreatedDate >= TODAY)';
		AMT_DAO_DateLiteralEvaluator dateLiteral = new AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral.TODAY,null);
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGtorEq('CreatedDate',dateLiteral);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void GtorEqWeekInYearSyntaxTest(){
		String expectedOut = '(WEEK_IN_YEAR(CreatedDate) >= 4)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.WEEK_IN_YEAR,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGtorEq(dateFunction,4);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void eqDateSyntaxTest(){
		Date dateInstance = Date.newInstance(2012, 2, 1);
		String expectedOut = '(DateField = '+String.valueOf(dateInstance)+')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('DateField',dateInstance);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void eqDateTimeSyntaxTest(){
		DateTime dateTimeInstance = DateTime.newInstance(2012, 2, 1,12,0,0);
		String expectedOut = '(CreatedDate = '+dateTimeInstance.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''+')');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeEq('CreatedDate',dateTimeInstance,null);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void notEqDoubleSyntaxtTest(){
		String expectedOut = '(AnnualRevenue != 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('AnnualRevenue',Double.valueOf(121.12));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void notEqDateSyntaxTest(){
		Date dateInstance = Date.newInstance(2012, 2, 1);
		String expectedOut = '(DateField != '+String.valueOf(dateInstance)+')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('DateField',dateInstance);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void notEqDateTimeSyntaxTest(){
		DateTime dateTimeInstance = DateTime.newInstance(2012, 2, 1,12,0,0);
		String expectedOut = '(CreatedDate != '+dateTimeInstance.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''+')');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq('CreatedDate',dateTimeInstance,null);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void notEqDayOnlySyntaxTest(){
		String expectedOut = '(DAY_ONLY(CreatedDate) != 2012-09-09)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_ONLY,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotEq(dateFunction,Date.newInstance(2012,9,9));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ltEqDoubleSyntaxtTest(){
		String expectedOut = '(AnnualRevenue < 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLt('AnnualRevenue',Double.valueOf(121.12));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ltDateSyntaxTest(){
		Date dateInstance = Date.newInstance(2012, 2, 1);
		String expectedOut = '(DateField < '+String.valueOf(dateInstance)+')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLt('DateField',dateInstance);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ltDateTimeSyntaxTest(){
		DateTime dateTimeInstance = DateTime.newInstance(2012, 2, 1,12,0,0);
		String expectedOut = '(CreatedDate < '+dateTimeInstance.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''+')');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLt('CreatedDate',dateTimeInstance,null);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ltDayOnlySyntaxTest(){
		String expectedOut = '(DAY_ONLY(CreatedDate) < 2012-09-09)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_ONLY,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLt(dateFunction,Date.newInstance(2012,9,9));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ltOrEqEqDoubleSyntaxtTest(){
		String expectedOut = '(AnnualRevenue <= 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLtOrEq('AnnualRevenue',Double.valueOf(121.12));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ltOrEqDateSyntaxTest(){
		Date dateInstance = Date.newInstance(2012, 2, 1);
		String expectedOut = '(DateField <= '+String.valueOf(dateInstance)+')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLtOrEq('DateField',dateInstance);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ltOrEqDateTimeSyntaxTest(){
		DateTime dateTimeInstance = DateTime.newInstance(2012, 2, 1,12,0,0);
		String expectedOut = '(CreatedDate <= '+dateTimeInstance.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''+')');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLtOrEq('CreatedDate',dateTimeInstance,null);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void ltOrEqDayOnlySyntaxTest(){
		String expectedOut = '(DAY_ONLY(CreatedDate) <= 2012-09-09)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_ONLY,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLtOrEq(dateFunction,Date.newInstance(2012,9,9));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void gtOrEqEqDoubleSyntaxtTest(){
		String expectedOut = '(AnnualRevenue >= 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGtOrEq('AnnualRevenue',Double.valueOf(121.12));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void gtOrEqDateSyntaxTest(){
		Date dateInstance = Date.newInstance(2012, 2, 1);
		String expectedOut = '(DateField >= '+String.valueOf(dateInstance)+')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGtOrEq('DateField',dateInstance);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void gtOrEqDateTimeSyntaxTest(){
		DateTime dateTimeInstance = DateTime.newInstance(2012, 2, 1,12,0,0);
		String expectedOut = '(CreatedDate >= '+dateTimeInstance.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''+')');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGtOrEq('CreatedDate',dateTimeInstance,null);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void gtOrEqDayOnlySyntaxTest(){
		String expectedOut = '(DAY_ONLY(CreatedDate) >= 2012-09-09)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_ONLY,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGtOrEq(dateFunction,Date.newInstance(2012,9,9));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void gtEqDoubleSyntaxtTest(){
		String expectedOut = '(AnnualRevenue > 121.12)';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGt('AnnualRevenue',Double.valueOf(121.12));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void gtDateSyntaxTest(){
		Date dateInstance = Date.newInstance(2012, 2, 1);
		String expectedOut = '(DateField > '+String.valueOf(dateInstance)+')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGt('DateField',dateInstance);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void gtDateTimeSyntaxTest(){
		DateTime dateTimeInstance = DateTime.newInstance(2012, 2, 1,12,0,0);
		String expectedOut = '(CreatedDate > '+dateTimeInstance.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''+')');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGt('CreatedDate',dateTimeInstance,null);

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void gtDayOnlySyntaxTest(){
		String expectedOut = '(DAY_ONLY(CreatedDate) > 2012-09-09)';
		AMT_DAO_DateFunction dateFunction = new AMT_DAO_DateFunction(AMT_DAO_DateFunction.DateFunctions.DAY_ONLY,'CreatedDate');
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeGt(dateFunction,Date.newInstance(2012,9,9));

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void likeSyntaxTest(){
		String expectedOut = '(Name LIKE \'%Test%\')';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeLike('Name','%Test%');

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void inStringSyntaxTest(){
		String expectedOut = '(Name IN (\'Test\',\'Test2\'))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeIn('Name',new List<String>{'Test','Test2'});

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void inIntegerSyntaxTest(){
		String expectedOut = '(Field__c IN (1,2,3,4,5))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeIn('Field__c',new List<Integer>{1,2,3,4,5});

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void inDoubleSyntaxTest(){
		String expectedOut = '(Field__c IN (1.5,2.0,3.0,4.0,5.1))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeIn('Field__c',new List<Double>{1.5,2.0,3.0,4.0,5.1});

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void inDecimalSyntaxTest(){
		String expectedOut = '(Field__c IN (1.5,2.0,3.0,4.0,5.1))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeIn('Field__c',new List<Decimal>{1.5,2.0,3.0,4.0,5.1});

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void notInDecimalSyntaxTest(){
		String expectedOut = '(Field__c NOT IN (1.5,2.0,3.0,4.0,5.1))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeNotIn('Field__c',new List<Decimal>{1.5,2.0,3.0,4.0,5.1});

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void includesSyntaxTest(){
		String expectedOut = '(Field__c INCLUDES (\'AAAA\',\'BBBBB\'))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeIncludes('Field__c',new List<sTRING>{'AAAA','BBBBB'});

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void excludesSyntaxTest(){
		String expectedOut = '(Field__c EXCLUDES (\'AAAA\',\'BBBBB\'))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeExcludes('Field__c',new List<sTRING>{'AAAA','BBBBB'});

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}

	@isTest
	public static void inLongSyntaxTest(){
		String expectedOut = '(Field__c IN (123123123,12345345))';
		AMT_DAO_QueryBuilder queryBuilder = new AMT_DAO_QueryBuilder(Account.getSObjectType());
		queryBuilder.makeIn('Field__c',new List<Long>{123123123l,12345345l});

		System.assertEquals(expectedOut,queryBuilder.getWhereCondition());
	}
}
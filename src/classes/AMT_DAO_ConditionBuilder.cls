public interface AMT_DAO_ConditionBuilder {	

	String evaluate();

	Boolean andCondition();

	Boolean orCondition();

	Boolean notCondition();

	Boolean condition(AMT_DAO_Operator operator,String fieldName,String value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,Integer value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,Boolean value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,Decimal value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,Double value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,Long value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,Date value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,List<String> value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Integer> value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Decimal> value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Double> value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Long> value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Date> value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,List<DateTime> value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,DateTime value,String timeZone);

	Boolean condition(AMT_DAO_Operator operator, String fieldName, AMT_DAO_DateLiteralEvaluator value);

	Boolean condition(AMT_DAO_Operator operator,AMT_DAO_DateFunction value,Integer additionalValue);

	Boolean condition(AMT_DAO_Operator operator,AMT_DAO_DateFunction value,Date additionalValue);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Object> value);

	Boolean condition(AMT_DAO_Operator operator,String fieldName,Object value);
	
	Boolean condition(AMT_DAO_Operator operator,String fieldName,AMT_DAO_QueryBuilder subQuery);
}
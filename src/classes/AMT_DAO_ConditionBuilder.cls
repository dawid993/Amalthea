public interface AMT_DAO_ConditionBuilder {	

	String evaluate();

	Boolean preapreAndInsertAndNode();

	Boolean preapreAndInsertOrNode();

	Boolean preapreAndInsertNotNode();

	Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,String value);

	Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Object value);

	Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Date value);

	Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,List<String> value);

	Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,List<Object> value);

	Boolean preapreAndInsertNode(
			AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,DateTime value,String timeZone);

	Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,
								 String fieldName,AMT_DAO_DateLiterals value);

	Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,
								 AMT_DAO_DateFunction value,Object additionalValue);

}
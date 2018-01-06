/**
 * Created by Dawid on 2017-10-22.
 */
public class AMT_DAO_QueryBuilder {
	public final Schema.sObjectType sObjectType;

	public final Schema.DescribeSObjectResult sObjectDescribe;

	private final AMT_DAO_ConditionBuilder conditionBuilder;

	public Map<String,Schema.SObjectField> queryFields{
		private set;
		public get {
			return queryFields.clone();
		}
	}

	public AMT_DAO_QueryBuilder(Schema.sObjectType sObjectType) {
		this.sObjectType = sObjectType;
		this.sObjectDescribe = this.sObjectType.getDescribe();
		this.queryFields = initializeQueryFields(this.sObjectDescribe);
		this.conditionBuilder = new AMT_DAO_WhereConditionBuilderImp();
	}

	public AMT_DAO_QueryBuilder(Schema.sObjectType sObjectType, List<String> fieldsNames) {
		this(sObjectType);
		this.queryFields = initializeQueryFields(this.sObjectDescribe,fieldsNames);
	}

	private Map<String,Schema.SObjectField> initializeQueryFields(Schema.DescribeSObjectResult objectDescribe){
		return objectDescribe.fields.getMap();
	}

	private Map<String,Schema.SObjectField> initializeQueryFields(Schema.DescribeSObjectResult objectDescribe,List<String> fieldsNames){
		Map<String,Schema.SObjectField> fields = initializeQueryFields(objectDescribe);
		Map<String,Schema.SObjectField> filteredFields = new Map<String,Schema.SObjectField>();
		for(String fieldName:fieldsNames){
			if(fields.containsKey(fieldName)){
				filteredFields.put(fieldName,fields.get(fieldName));
			}else{
				throw new AMT_DAO_QueryException(fieldName+' not presented in sObject. ');
			}
		}
		return filteredFields;
	}

	public String getWhereCondition(){
		return this.conditionBuilder.evaluate();
	}

	public AMT_DAO_QueryBuilder makeAnd(){
		this.conditionBuilder.preapreAndInsertAndNode();
		return this;
	}

	public AMT_DAO_QueryBuilder makeOr(){
		this.conditionBuilder.preapreAndInsertOrNode();
		return this;
	}

	public AMT_DAO_QueryBuilder makeNot(){
		this.conditionBuilder.preapreAndInsertNotNode();
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,String value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.preapreAndInsertNode
				(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value,timeZone);
		return this;

	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Date value){
		sYSTEM.DEBUG('DSAD');
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Object value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeEq(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,
				dateFunction,additionalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName, AMT_DAO_DateLiterals literalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,
				fieldName,literalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,String value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Object value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,
				fieldName,value,timeZone);
		return this;

	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName, AMT_DAO_DateLiterals literalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,
				fieldName,literalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeNotEq(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,
				dateFunction,additionalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,String value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Object value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,
				fieldName,value,timeZone);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName, AMT_DAO_DateLiterals literalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,
				fieldName,literalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLt(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,
				dateFunction,additionalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,String value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Object value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value,timeZone);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName, AMT_DAO_DateLiterals literalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,
				fieldName,literalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLtOrEq(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,
				dateFunction,additionalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,String value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Object value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,
				fieldName,value,timeZone);
		return this;

	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName, AMT_DAO_DateLiterals literalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,
				fieldName,literalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeGt(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,
				dateFunction,additionalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,String value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Object value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value,timeZone);
		return this;

	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName, AMT_DAO_DateLiterals literalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,
				fieldName,literalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeGtOrEq(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,
				dateFunction,additionalValue);
		return this;

	}

	public AMT_DAO_QueryBuilder makeLike(String fieldName,String value){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LIKE_EXP,
				fieldName,value);
		return this;

	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<String> values){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		return this;

	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Object> values){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		return this;

	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<String> values){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		return this;

	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Object> values){
		this.conditionBuilder.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		return this;

	}

	public AMT_DAO_QueryBuilder makeIncludes(String fieldName,List<String> values){
		this.conditionBuilder.preapreAndInsertNode(
				AMT_DAO_OperatorUtils.AMT_DAO_Operator.INCLUDES_EXP,fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeExcludes(String fieldName,List<String> values){
		this.conditionBuilder.preapreAndInsertNode(
				AMT_DAO_OperatorUtils.AMT_DAO_Operator.EXCLUDES_EXP,fieldName,values);
		return this;
	}
}
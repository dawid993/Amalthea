public class AMT_DAO_QueryBuilder {
	public final Schema.sObjectType sObjectType;

	private final AMT_DAO_ConditionBuilder conditionBuilder;

	public Map<String,Schema.SObjectField> queryFields{
		private set;
		public get {
			return queryFields.clone();
		}
	}

	private List<String> orderByFields;

	public Boolean nullsFirst {get;set;}

	public Integer recordsLimit {get; private set;}

	public Integer recordsOffset {get;private set;}

	public AMT_DAO_QueryBuilder(Schema.sObjectType sObjectType) {
		this.sObjectType = sObjectType;
		this.queryFields = initializeQueryFields(this.sObjectType.getDescribe());
		this.conditionBuilder = AMT_DAO_ServiceProvider.getConditionBuilder();
		this.orderByFields = new List<String>();
		this.nullsFirst = true;		
	}

	public AMT_DAO_QueryBuilder(Schema.sObjectType sObjectType, List<String> fieldsNames) {
		this(sObjectType);
		this.queryFields = initializeQueryFields(this.sObjectType.getDescribe(),fieldsNames);
	}

	private Map<String,Schema.SObjectField> initializeQueryFields(Schema.DescribeSObjectResult objectDescribe){
		return objectDescribe.fields.getMap();
	}

	/*
	* Need to check correctness of solution. We are trying to process every field to check if it is
	* relation field and if yes return direct field name. Ex. Account.Name => AccountID, example__r.Name => example__c.
	* It's means that if we query two fields from this same relation we have two pairs of 
	* <Account.Name,AccountId> <Account.CreatedDate,AccountId> where AccountId is reference on this same object. 
	*/
	private Map<String,Schema.SObjectField> initializeQueryFields(Schema.DescribeSObjectResult objectDescribe,List<String> fieldsNames){
		Map<String,Schema.SObjectField> fields = initializeQueryFields(objectDescribe);
		Map<String,Schema.SObjectField> filteredFields = new Map<String,Schema.SObjectField>();			
		for(String fieldName:fieldsNames){
			String processedField = getFieldByRelationName(fieldName);
			if(fields.containsKey(processedField)){
				filteredFields.put(fieldName,fields.get(processedField));
			}else{
				throw new AMT_DAO_QueryException(fieldName+' not presented in sObject. ');
			}
		}
		return filteredFields;
	}

	private String getFieldByRelationName(String field){
		if(field.contains('.')){
			System.debug(field);
			String[] fields = field.split('\\.');
			System.debug(fields);
			return fields[0].contains('__r') ? fields[0].replace('__r','__c') : fields[0]+'Id';
		}else{
			return field;
		}
	}

	public String getWhereCondition(){
		return ' WHERE '+this.conditionBuilder.evaluate();
	}

	public String getOrderBy(){
		return (orderByFields.isEmpty() ? '' : 
			' ORDER BY ' +String.join(orderByFields,',')+ ' NULLS'+ (nullsFirst ? ' FIRST' : 'LAST'));
	}

	public String getSelectedFields(){	
		return 'SELECT '+String.join(new List<String>(queryFields.keySet()),',');
	}

	public String getQuery(){
		String selectedFields = getSelectedFields();
		String whereCondition = getWhereCondition();
		String orderByClause = getOrderBy();
	
		String finalQuery = selectedFields +' FROM '+sObjectType.getDescribe().getName();
		finalQuery += (String.isNotBlank(whereCondition) ? whereCondition : '');
		finalQuery += (String.isNotBlank(orderByClause) ? orderByClause : '');				
		finalQuery += (recordsLimit != null ? ' LIMIT '+String.valueOf(recordsLimit) : '');	
		finalQuery += (recordsoFFSET != null ? ' OFFSET '+String.valueOf(recordsOffset) : '');	
		return finalQuery.trim(); 
	}

	public AMT_DAO_QueryBuilder orderBy(String fieldName,AMT_DAO_Order order){
		if(queryFields.containsKey(fieldName)){
			orderByFields.add(fieldName+(order != null ? ' '+ order.name().remove('_ORDER') :''));
		}
		return this;		
	}

	public AMT_DAO_QueryBuilder makeLimit(Integer limitValue){
		recordsLimit = limitValue;
		return this;
	}

	public AMT_DAO_QueryBuilder makeOffset(Integer offsetValue){
		recordsOffset = offsetValue;
		return this;
	}

	public AMT_DAO_QueryBuilder makeAnd(){
		this.conditionBuilder.andCondition();
		return this;
	}

	public AMT_DAO_QueryBuilder makeOr(){
		this.conditionBuilder.orCondition();
		return this;
	}

	public AMT_DAO_QueryBuilder makeNot(){
		this.conditionBuilder.notCondition();
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,String value){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Integer value){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Boolean value){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Decimal value){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Double value){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Long value){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.condition
				(AMT_DAO_Operator.EQ,fieldName,value,timeZone);
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Date value){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Object value){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,
				dateFunction,additionalValue);
		return this;
	}


	public AMT_DAO_QueryBuilder makeEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,literalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,String value){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Integer value){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Boolean value){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Decimal value){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Double value){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Long value){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Date value){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Object value){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value,timeZone);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,literalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,String value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Integer value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Decimal value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Double value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Long value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Date value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Object value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value,timeZone);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,literalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,String value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Integer value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Decimal value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Double value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Long value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Date value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Object value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value,timeZone);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,literalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,String value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Integer value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Decimal value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Double value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Long value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Date value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Object value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value,timeZone);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,literalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,String value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Integer value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Decimal value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Double value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Long value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Date value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Object value){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,DateTime value,String timeZone){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value,timeZone);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,literalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		this.conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				dateFunction,additionalValue);
		return this;
	}

	public AMT_DAO_QueryBuilder makeLike(String fieldName,String value){
		this.conditionBuilder.condition(AMT_DAO_Operator.LIKE_EXP,
				fieldName,value);
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<String> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Integer> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Decimal> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Double> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Long> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Date> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Object> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<String> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Integer> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Decimal> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Double> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Long> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Date> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Object> values){
		this.conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeIncludes(String fieldName,List<String> values){
		this.conditionBuilder.condition(
				AMT_DAO_Operator.INCLUDES_EXP,fieldName,values);
		return this;
	}

	public AMT_DAO_QueryBuilder makeExcludes(String fieldName,List<String> values){
		this.conditionBuilder.condition(
				AMT_DAO_Operator.EXCLUDES_EXP,fieldName,values);
		return this;
	}
}
public virtual class AMT_DAO_QueryBuilder {
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

	public List<AMT_DAO_SubQueryBuilder> subQueries{get;set;}

	public AMT_DAO_QueryBuilder(Schema.sObjectType sObjectType) {
		this.subQueries = new List<AMT_DAO_SubQueryBuilder>();
		this.sObjectType = sObjectType;
		this.queryFields = initializeQueryFields(this.sObjectType.getDescribe());
		this.conditionBuilder = AMT_DAO_ServiceProvider.getConditionBuilder();
		this.orderByFields = new List<String>();
		this.nullsFirst = true;		
	}

	public AMT_DAO_QueryBuilder(Schema.sObjectType sObjectType, List<String> fieldsNames) {
		this(sObjectType);
		if(fieldsNames == null || fieldsNames.isEmpty()){
			fieldsNames = new List<String>{'ID'};
		}
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
			String[] fields = field.split('\\.');			
			return fields[0].contains('__r') ? fields[0].replace('__r','__c') : fields[0]+'Id';
		}else{
			return field;
		}
	}

	private String getSubQueries(){		
		if(subQueries.size() == 0){
			return '';
		}

		String joinedSubQueries = ',';
		for(AMT_DAO_SubQueryBuilder subQuery : subQueries){
			joinedSubQueries+='('+subQuery.getQuery()+'),';
		}
		joinedSubQueries = joinedSubQueries.removeEnd(',');
		return joinedSubQueries;
	}

	public String getWhereCondition(){
		if(conditionBuilder == null){
			return null;
		}
		return this.conditionBuilder.evaluate();
	}

	public String getOrderBy(){
		if(orderByFields == null){
			return null;
		}
		return (orderByFields.isEmpty() ? '' : 
			String.join(orderByFields,',')+ ' NULLS'+ (nullsFirst ? ' FIRST' : 'LAST'));
	}

	public String getSelectedFields(){	
		return 'SELECT '+String.join(new List<String>(queryFields.keySet()),',');
	}

	public virtual String getQuery(){
		String selectedFields = getSelectedFields();
		String whereCondition = getWhereCondition();
		String orderByClause = getOrderBy();
	
		String finalQuery = selectedFields+getSubQueries()+' FROM '+sObjectType.getDescribe().getName();
		finalQuery += (String.isNotBlank(whereCondition) ? ' WHERE '+whereCondition : '');
		finalQuery += (String.isNotBlank(orderByClause) ? ' ORDER BY '+orderByClause : '');				
		finalQuery += (recordsLimit != null ? ' LIMIT '+String.valueOf(recordsLimit) : '');	
		finalQuery += (recordsOffset != null ? ' OFFSET '+String.valueOf(recordsOffset) : '');	
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
		if(conditionBuilder != null){
			this.conditionBuilder.andCondition();
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeOr(){
		if(conditionBuilder != null){
			conditionBuilder.orCondition();	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNot(){
		if(conditionBuilder != null){
			conditionBuilder.notCondition();	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Boolean value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition
				(AMT_DAO_Operator.EQ,fieldName,value,timeZone);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				dateFunction,additionalValue);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				dateFunction,additionalValue);	
		}
		return this;
	}


	public AMT_DAO_QueryBuilder makeEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,literalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Boolean value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value,timeZone);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,literalValue);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				dateFunction,additionalValue);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				dateFunction,additionalValue);
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value,timeZone);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,literalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				dateFunction,additionalValue);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLt(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				dateFunction,additionalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value,timeZone);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,literalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				dateFunction,additionalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLtOrEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				dateFunction,additionalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value,timeZone);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,literalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				dateFunction,additionalValue);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGt(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				dateFunction,additionalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);	
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value,timeZone);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,literalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				dateFunction,additionalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeGtOrEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				dateFunction,additionalValue);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeLike(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LIKE_EXP,
				fieldName,value);
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<String> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Integer> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Decimal> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Double> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);	
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Long> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Date> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}				
		return this;
	}

	public AMT_DAO_QueryBuilder makeIn(String fieldName,List<Object> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<String> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Integer> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		}	
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Decimal> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Double> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Long> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);	
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Date> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);	
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeNotIn(String fieldName,List<Object> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);	
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeIncludes(String fieldName,List<String> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(
				AMT_DAO_Operator.INCLUDES_EXP,fieldName,values);
		}		
		return this;
	}

	public AMT_DAO_QueryBuilder makeExcludes(String fieldName,List<String> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(
				AMT_DAO_Operator.EXCLUDES_EXP,fieldName,values);
		}		
		return this;
	}
}
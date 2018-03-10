global virtual class AMT_DAO_QueryImp implements AMT_DAO_Query{		

	public Schema.sObjectType sObjectType{public get; private set;}

	private AMT_DAO_ConditionBuilder conditionBuilder;

	global Map<String,Schema.SObjectField> queryFields{
		private set;
		global get {
			return queryFields.clone();
		}
	}

	private List<String> orderByFields;

	global Boolean nullsFirst {get;set;}

	global Integer recordsLimit {get; private set;}

	global Integer recordsOffset {get;private set;}	

	global List<AMT_DAO_Query> subQueries{get;set;}

	public AMT_DAO_QueryImp(){

	}
 
	public AMT_DAO_QueryImp(Schema.sObjectType sObjectType) {
		init(SObjectType);
	}

	public AMT_DAO_QueryImp(Schema.sObjectType sObjectType, List<String> fieldsNames) {
		this(sObjectType);
		setSelectFields(fieldsNames);		
	}	

	protected void init(SObjectType type){
		this.subQueries = new List<AMT_DAO_Query>();
		this.sObjectType = type;
		this.queryFields = initializeQueryFields(this.sObjectType.getDescribe());
		this.conditionBuilder = AMT_DAO_ServiceProvider.getConditionBuilder();
		this.orderByFields = new List<String>();
		this.nullsFirst = true;		
	}

	protected void setSelectFields(List<String> fieldNames){
		if(fieldNames == null || fieldNames.isEmpty()){
			fieldNames = new List<String>{'ID'};
		}

		if(sObjectType == null){
			return;
		}

		this.queryFields = initializeQueryFields(this.sObjectType.getDescribe(),fieldNames);
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
		for(AMT_DAO_Query subQuery : subQueries){
			joinedSubQueries+='('+subQuery.getQuery()+'),';
		}
		joinedSubQueries = joinedSubQueries.removeEnd(',');
		return joinedSubQueries;
	}

	global String getWhereCondition(){
		if(conditionBuilder == null){
			return null;
		}
		return this.conditionBuilder.evaluate();
	}

	global String getOrderBy(){
		if(orderByFields == null){
			return null;
		}
		return (orderByFields.isEmpty() ? '' : 
			String.join(orderByFields,',')+ ' NULLS'+ (nullsFirst ? ' FIRST' : 'LAST'));
	}

	global String getSelectedFields(){	
		System.debug(queryFields);
		return 'SELECT '+String.join(new List<String>(queryFields.keySet()),',');
	}

	global virtual String getQuery(){
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

	global AMT_DAO_Query orderBy(String fieldName,AMT_DAO_Order order){
		if(queryFields.containsKey(fieldName)){
			orderByFields.add(fieldName+(order != null ? ' '+ order.name().remove('_ORDER') :''));
		}
		return this;		
	}

	global AMT_DAO_Query makeLimit(Integer limitValue){
		recordsLimit = limitValue;
		return this;
	}

	global AMT_DAO_Query makeOffset(Integer offsetValue){
		recordsOffset = offsetValue;
		return this;
	}

	global AMT_DAO_Query makeAnd(){
		if(conditionBuilder != null){
			this.conditionBuilder.andCondition();
		}
		return this;
	}

	global AMT_DAO_Query makeOr(){
		if(conditionBuilder != null){
			conditionBuilder.orCondition();	
		}
		return this;
	}

	global AMT_DAO_Query makeNot(){
		if(conditionBuilder != null){
			conditionBuilder.notCondition();	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(String fieldName,Boolean value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition
				(AMT_DAO_Operator.EQ,fieldName,value,timeZone);	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				dateFunction,additionalValue);	
		}
		return this;
	}

	global AMT_DAO_Query makeEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				dateFunction,additionalValue);	
		}
		return this;
	}


	global AMT_DAO_Query makeEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.EQ,
				fieldName,literalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(String fieldName,Boolean value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,value,timeZone);
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				fieldName,literalValue);	
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				dateFunction,additionalValue);	
		}
		return this;
	}

	global AMT_DAO_Query makeNotEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_EQ,
				dateFunction,additionalValue);
		}		
		return this;
	}

	global AMT_DAO_Query makeLt(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLt(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLt(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLt(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLt(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLt(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLt(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeLt(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,value,timeZone);
		}
		return this;
	}

	global AMT_DAO_Query makeLt(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				fieldName,literalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeLt(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				dateFunction,additionalValue);	
		}
		return this;
	}

	global AMT_DAO_Query makeLt(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT,
				dateFunction,additionalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}		
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}		
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,value,timeZone);
		}
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				fieldName,literalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				dateFunction,additionalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeLtOrEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LT_OR_EQ,
				dateFunction,additionalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeGt(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGt(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGt(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGt(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGt(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGt(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGt(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGt(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,value,timeZone);
		}
		return this;
	}

	global AMT_DAO_Query makeGt(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				fieldName,literalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeGt(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				dateFunction,additionalValue);	
		}
		return this;
	}

	global AMT_DAO_Query makeGt(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT,
				dateFunction,additionalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(String fieldName,Integer value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(String fieldName,Decimal value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(String fieldName,Double value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(String fieldName,Long value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(String fieldName,Date value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);	
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(String fieldName,Object value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value);
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(String fieldName,DateTime value,String timeZone){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,value,timeZone);
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(String fieldName, AMT_DAO_DateLiteralEvaluator literalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				fieldName,literalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(AMT_DAO_DateFunction dateFunction,Integer additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				dateFunction,additionalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeGtOrEq(AMT_DAO_DateFunction dateFunction,Date additionalValue){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.GT_OR_EQ,
				dateFunction,additionalValue);
		}
		return this;
	}

	global AMT_DAO_Query makeLike(String fieldName,String value){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.LIKE_EXP,
				fieldName,value);
		}		
		return this;
	}

	global AMT_DAO_Query makeIn(String fieldName,List<String> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}
		return this;
	}

	global AMT_DAO_Query makeIn(String fieldName,List<Integer> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}
		return this;
	}

	global AMT_DAO_Query makeIn(String fieldName,List<Decimal> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}
		return this;
	}

	global AMT_DAO_Query makeIn(String fieldName,List<Double> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);	
		}		
		return this;
	}

	global AMT_DAO_Query makeIn(String fieldName,List<Long> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}		
		return this;
	}

	global AMT_DAO_Query makeIn(String fieldName,List<Date> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}				
		return this;
	}

	global AMT_DAO_Query makeIn(String fieldName,List<Object> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,values);
		}		
		return this;
	}

	global AMT_DAO_Query makeIn(String fieldName,AMT_DAO_Query subQuery){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.IN_EXP,
				fieldName,subQuery);
		}
		return this;
	}

	global AMT_DAO_Query makeNotIn(String fieldName,List<String> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		}		
		return this;
	}

	global AMT_DAO_Query makeNotIn(String fieldName,List<Integer> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		}	
		return this;
	}

	global AMT_DAO_Query makeNotIn(String fieldName,List<Decimal> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		}		
		return this;
	}

	global AMT_DAO_Query makeNotIn(String fieldName,List<Double> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);
		}		
		return this;
	}

	global AMT_DAO_Query makeNotIn(String fieldName,List<Long> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);	
		}		
		return this;
	}

	global AMT_DAO_Query makeNotIn(String fieldName,List<Date> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);	
		}		
		return this;
	}

	global AMT_DAO_Query makeNotIn(String fieldName,List<Object> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(AMT_DAO_Operator.NOT_IN,
				fieldName,values);	
		}		
		return this;
	}

	global AMT_DAO_Query makeIncludes(String fieldName,List<String> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(
				AMT_DAO_Operator.INCLUDES_EXP,fieldName,values);
		}		
		return this;
	}

	global AMT_DAO_Query makeExcludes(String fieldName,List<String> values){
		if(conditionBuilder != null){
			conditionBuilder.condition(
				AMT_DAO_Operator.EXCLUDES_EXP,fieldName,values);
		}		
		return this;
	}
}
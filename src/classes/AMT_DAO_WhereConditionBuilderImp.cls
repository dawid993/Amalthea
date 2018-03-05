public class AMT_DAO_WhereConditionBuilderImp implements AMT_DAO_ConditionBuilder{

	/*
	* I have tried to make AMT_DAO_ConditionBuilder independent of condition storage implementation.
	* There are only methods which take operator,field name and value.
	* This class implementation is dependent and need to use tree structure because of
	* AMT_DAO_ConditionBuilderTreeStructure which works thanks to AMT_DAO_Node.
	*/
	
	private AMT_DAO_ConditionBuilderTreeStructure structureManager;

	public AMT_DAO_WhereConditionBuilderImp(){
		structureManager = AMT_DAO_ServiceProvider.getConditionBuilderStructure();
	}

	public String evaluate(){
		if(structureManager != null && structureManager.getRootNode() != null){
			return structureManager.getRootNode().evaluate();
		}else{
			return null;
		}
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,String value){
		value = String.escapeSingleQuotes(value);
		return this.insertNode(getConditionNode(operator,fieldName,
			value == AMT_DAO_UTL_DaoUtils.NULL_VALUE ? value : AMT_DAO_UTL_DaoUtils.insertApostrophes(value)));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,Integer value){
		return this.insertNode(getConditionNode(operator,fieldName,value));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,Boolean value){
		return this.insertNode(getConditionNode(operator,fieldName,value));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,Decimal value){
		return this.insertNode(getConditionNode(operator,fieldName,value));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,Double value){
		return this.insertNode(getConditionNode(operator,fieldName,value));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,Long value){
		return this.insertNode(getConditionNode(operator,fieldName,value));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,Date value){
		return this.insertNode(getConditionNode(operator,fieldName,value));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,Object value){
		throw new AMT_DAO_QueryException('Method not implemented because of security reasons.');
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,List<String> value){
		AMT_DAO_UTL_DaoUtils.escapeSingleQuotes(value);
		return this.insertNode(getConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Integer> value){
		return this.insertNode(getConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Decimal> value){
		return this.insertNode(getConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Double> value){
		return this.insertNode(getConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Long> value){
		return this.insertNode(getConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Date> value){
		return this.insertNode(getConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,List<DateTime> value){
		return this.insertNode(getConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,List<Object> value){
		throw new AMT_DAO_QueryException('Method not implemented because of security reasons.');
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,DateTime value,String timeZone){
		timeZone = timeZone == null ? AMT_DAO_UTL_DaoUtils.DEFAULT_TIME_ZONE : timeZone;
		String dateTimeLiteral = value.format(AMT_DAO_UTL_DaoUtils.DATE_TIME_FORMAT,timeZone);
		return this.insertNode(getConditionNode(operator,fieldName,dateTimeLiteral));
	}

	public Boolean condition(AMT_DAO_Operator operator, String fieldName, AMT_DAO_DateLiteralEvaluator value){
		String literal = value.evaluate();
		return this.insertNode(getConditionNode(operator,fieldName,literal));
	}

	public Boolean condition(AMT_DAO_Operator operator,AMT_DAO_DateFunction value,Integer additionalValue){
		String dateFunction = value.evaluate();
		return this.insertNode(getConditionNode(operator,dateFunction,additionalValue));
	}

	public Boolean condition(AMT_DAO_Operator operator,AMT_DAO_DateFunction value,Date additionalValue){
		String dateFunction = value.evaluate();
		return this.insertNode(getConditionNode(operator,dateFunction,additionalValue));
	}

	public Boolean condition(AMT_DAO_Operator operator,String fieldName,AMT_DAO_QueryBuilder subQuery){	
		return this.insertNode(getConditionNode(operator,fieldName,'('+subQuery.getQuery()+')'));
	}

	public Boolean andCondition(){
		return this.insertNode(getLogicalNode(AMT_DAO_Operator.AND_EXP));
	}

	public Boolean orCondition(){
		return this.insertNode(getLogicalNode(AMT_DAO_Operator.OR_EXP));
	}

	public Boolean notCondition(){
		return this.insertNode(getLogicalNode(AMT_DAO_Operator.NOT_EXP));
	}

	private Boolean insertNode(AMT_DAO_Node node){
		if(this.structureManager == null){
			throw new AMT_DAO_NodeException('Condition Builder Manager not presented.');
		}else{
			Boolean success = structureManager.addNode(node);
			if(!success){
				throw new AMT_DAO_NodeException('Can\'t insert node to manager.');
			}else{
				return true;
			}
		}
	}

	private AMT_DAO_Node getLogicalNode(AMT_DAO_Operator operator){
		AMT_DAO_Node node = AMT_DAO_ServiceProvider.getLogicalNode();
		node.setOperator(operator);
		return node;
	}

	private AMT_DAO_Node getConditionNode(AMT_DAO_Operator operator,String fieldName,Object value){
		AMT_DAO_Node node = AMT_DAO_ServiceProvider.getConditionNode();
		node.setOperator(operator);
		node.setLeftArgument(fieldName);
		node.setRightArgument(String.valueOf(value));
		return node;
	}

	private AMT_DAO_Node getConditionNode(AMT_DAO_Operator operator,String fieldName,Date value){
		AMT_DAO_Node node = AMT_DAO_ServiceProvider.getConditionNode();
		node.setOperator(operator);
		node.setLeftArgument(fieldName);
		node.setRightArgument(String.valueOf(value));
		return node;
	}
}
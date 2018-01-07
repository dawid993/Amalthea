public class AMT_DAO_WhereConditionBuilderImp implements AMT_DAO_ConditionBuilder{
	
	private AMT_DAO_ConditionBuilderStructure treeManager;

	public AMT_DAO_WhereConditionBuilderImp(){
		treeManager = AMT_DAO_ServiceProvider.getConditionBuilderStructure();
	}

	public String evaluate(){
		return treeManager.getRootNode().evaluate();
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,String value){
		value = String.escapeSingleQuotes(value);
		return this.insertNode(getConditionNode(operator,fieldName,
			value == AMT_DAO_UTL_DaoUtils.NULL_VALUE ? value : AMT_DAO_UTL_DaoUtils.insertApostrophes(value)));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Object value){
		value = String.escapeSingleQuotes(String.valueOf(value));
		return this.insertNode(getConditionNode(operator,fieldName,value));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Date value){
		return this.insertNode(getConditionNode(operator,fieldName,value));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,List<String> value){
		AMT_DAO_UTL_DaoUtils.escapeSingleQuotes(value);
		return this.insertNode(getConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,List<Object> value){
		return this.insertNode(getConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,DateTime value,String timeZone){
		timeZone = timeZone == null ? AMT_DAO_UTL_DaoUtils.DEFAULT_TIME_ZONE : timeZone;
		String dateTimeLiteral = value.format(AMT_DAO_UTL_DaoUtils.DATE_TIME_FORMAT,timeZone);
		return this.insertNode(getConditionNode(operator,fieldName,dateTimeLiteral));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,AMT_DAO_DateLiterals value){
		String literal = value.evaluate();
		return this.insertNode(getConditionNode(operator,fieldName,literal));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,AMT_DAO_DateFunction value,Object additionalValue){
		String dateFunction = value.evaluate();
		return this.insertNode(getConditionNode(operator,dateFunction,additionalValue));
	}

	public Boolean preapreAndInsertAndNode(){
		return this.insertNode(getLogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.AND_EXP));
	}

	public Boolean preapreAndInsertOrNode(){
		return this.insertNode(getLogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.OR_EXP));
	}

	public Boolean preapreAndInsertNotNode(){
		return this.insertNode(getLogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EXP));
	}

	private Boolean insertNode(AMT_DAO_Node node){
		if(this.treeManager == null){
			throw new AMT_DAO_NodeException('Condition Builder Manager not presented.');
		}else{
			Boolean success = treeManager.addNode(node);
			if(!success){
				throw new AMT_DAO_NodeException('Can\'t insert node to manager.');
			}else{
				return true;
			}
		}
	}

	private AMT_DAO_Node getLogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator){
		AMT_DAO_Node node = AMT_DAO_ServiceProvider.getLogicalNode();
		node.setOperator(operator);
		return node;
	}

	private AMT_DAO_Node getConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Object value){
		AMT_DAO_Node node = AMT_DAO_ServiceProvider.getConditionNode();
		node.setOperator(operator);
		node.setLeftArgument(fieldName);
		node.setRightArgument(String.valueOf(value));
		return node;
	}

	private AMT_DAO_Node getConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Date value){
		AMT_DAO_Node node = AMT_DAO_ServiceProvider.getConditionNode();
		node.setOperator(operator);
		node.setLeftArgument(fieldName);
		node.setRightArgument(String.valueOf(value));
		return node;
	}
}
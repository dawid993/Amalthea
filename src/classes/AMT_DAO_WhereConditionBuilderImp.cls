public class AMT_DAO_WhereConditionBuilderImp implements AMT_DAO_ConditionBuilder{
	
	private AMT_DAO_ConditionBuilderStructure treeManager;

	public AMT_DAO_WhereConditionBuilderImp(){
		treeManager = new AMT_DAO_ConditionBuilderStructureImp();
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

	public String evaluate(){
		return treeManager.getRootNode().evaluate();
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,String value){
		value = String.escapeSingleQuotes(value);
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,
			value == AMT_DAO_UTL_DaoUtils.NULL_VALUE ? value : AMT_DAO_UTL_DaoUtils.insertApostrophes(value)));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Object value){
		value = String.escapeSingleQuotes(String.valueOf(value));
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,value));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Date value){
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,value));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,List<String> value){
		AMT_DAO_UTL_DaoUtils.escapeSingleQuotes(value);
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,List<Object> value){
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,DateTime value,String timeZone){
		timeZone = timeZone == null ? AMT_DAO_UTL_DaoUtils.DEFAULT_TIME_ZONE : timeZone;
		String dateTimeLiteral = value.format(AMT_DAO_UTL_DaoUtils.DATE_TIME_FORMAT,timeZone);
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,dateTimeLiteral));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,AMT_DAO_DateLiterals value){
		String literal = value.evaluate();
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,literal));
	}

	public Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,AMT_DAO_DateFunction value,Object additionalValue){
		String dateFunction = value.evaluate();
		return this.insertNode(new AMT_DAO_ConditionNode(operator,dateFunction,additionalValue));
	}

	public Boolean preapreAndInsertAndNode(){
		AMT_DAO_Node node = new AMT_DAO_LogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.AND_EXP);
		return this.treeManager.addNode(node);
	}

	public Boolean preapreAndInsertOrNode(){
		AMT_DAO_Node node = new AMT_DAO_LogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.OR_EXP);
		return this.treeManager.addNode(node);
	}

	public Boolean preapreAndInsertNotNode(){
		AMT_DAO_Node node = new AMT_DAO_LogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EXP);
		return this.treeManager.addNode(node);
	}
}
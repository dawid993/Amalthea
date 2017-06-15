public virtual class AMT_DAO_WhereConditionBuilderImp implements AMT_DAO_ConditionBuilder{
	
	private AMT_DAO_TreeConditionBuilderManager treeManager;

	public AMT_DAO_WhereConditionBuilderImp(){
		treeManager = new AMT_DAO_TreeConditionBuilderManagerImp();
	}

	private AMT_DAO_ConditionBuilder checkInsertion(Boolean isInserted){
		if(isInserted){
			return this;
		}else{
			throw new AMT_DAO_NodeException('Can not insert node to tree.');
		}
	}

	private Boolean insertNode(AMT_DAO_Node node){
		if(this.treeManager != null){
			return this.treeManager.addNode(node,this.treeManager.getRootNode());
		}else{
			return false;
		}
	}

	protected virtual Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,String value){		
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,
			value == AMT_DAO_UTL_DaoUtils.NULL_VALUE ? value : AMT_DAO_UTL_DaoUtils.insertApostrophes(value)));
	}

	protected virtual Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Object value){
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,value));
	}	

	protected virtual Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,List<String> value){
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}

	protected virtual Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,List<Object> value){
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value)));
	}
	
	protected virtual Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,DateTime value,String timeZone){
		timeZone = timeZone == null ? AMT_DAO_UTL_DaoUtils.DEFAULT_TIME_ZONE : timeZone;
		String dateTimeLiteral = value.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'',timeZone);
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,dateTimeLiteral));
	}

	protected virtual Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,AMT_DAO_DateLiterals value){	
		String literal = value.evaluate();
		return this.insertNode(new AMT_DAO_ConditionNode(operator,fieldName,literal));
	}	

	protected virtual Boolean preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,AMT_DAO_DateFunction value,Object additionalValue){
		String dateFunction = value.evaluate();
		return this.insertNode(new AMT_DAO_ConditionNode(operator,dateFunction,additionalValue));
	}

	public String evaluate(){
		return treeManager.getRootNode().evaluate();
	}

	public AMT_DAO_ConditionBuilder makeAnd(){
		AMT_DAO_Node node = new AMT_DAO_LogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.AND_EXP);
		this.treeManager.addNode(node,this.treeManager.getRootNode());
		return this;
	}

	public AMT_DAO_ConditionBuilder makeOr(){
		AMT_DAO_Node node = new AMT_DAO_LogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.OR_EXP);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);		
	}

	public AMT_DAO_ConditionBuilder makeNot(){
		AMT_DAO_Node node = new AMT_DAO_LogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EXP);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,String value){		
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,DateTime value,String timeZone){		
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,Object value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,dateFunction,additionalValue);
		return checkInsertion(isNodeInserted);
	}
	
	public AMT_DAO_ConditionBuilder makeEq(String fieldName, AMT_DAO_DateLiterals literalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,literalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,String value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Object value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value);	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,DateTime value,String timeZone){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName, AMT_DAO_DateLiterals literalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,literalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,dateFunction,additionalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,String value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,Object value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value);
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,DateTime value,String timeZone){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName, AMT_DAO_DateLiterals literalValue){
			Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,literalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,dateFunction,additionalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,String value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Object value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value);
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,DateTime value,String timeZone){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName, AMT_DAO_DateLiterals literalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,literalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,dateFunction,additionalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,String value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,Object value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value);
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,DateTime value,String timeZone){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName, AMT_DAO_DateLiterals literalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,literalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,dateFunction,additionalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,String value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Object value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value);
		return checkInsertion(isNodeInserted);
	}	
	
	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,DateTime value,String timeZone){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName, AMT_DAO_DateLiterals literalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,literalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGtOrEq(AMT_DAO_DateFunction dateFunction,Object additionalValue){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,dateFunction,additionalValue);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLike(String fieldName,String value){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LIKE_EXP,fieldName,value);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeIn(String fieldName,List<String> values){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,fieldName,values);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeIn(String fieldName,List<Object> values){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,fieldName,values);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<String> values){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,fieldName,values);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<Object> values){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,fieldName,values);
		return checkInsertion(isNodeInserted);
	}	
	
	public AMT_DAO_ConditionBuilder makeIncludes(String fieldName,List<String> values){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.INCLUDES_EXP,fieldName,values);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeExcludes(String fieldName,List<String> values){
		Boolean isNodeInserted = this.preapreAndInsertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EXCLUDES_EXP,fieldName,values);
		return checkInsertion(isNodeInserted);
	}
	
}
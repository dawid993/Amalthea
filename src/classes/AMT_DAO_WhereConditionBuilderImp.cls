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

	protected virtual Boolean insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Object argument,String additionalParameter){
		AMT_DAO_Node node;

		if(argument instanceof String){
			String value = (String) argument;
			node = new AMT_DAO_ConditionNode(operator,fieldName,
			value == AMT_DAO_UTL_DaoUtils.NULL_VALUE ? value : AMT_DAO_UTL_DaoUtils.insertApostrophes(value));
		}else if(argument instanceof Integer){
			Integer value = (Integer) argument;
			node = new AMT_DAO_ConditionNode(operator,fieldName,value);
		}else if(argument instanceof Decimal){
			Decimal value = (Decimal) argument;
			node = new AMT_DAO_ConditionNode(operator,fieldName,value);
		}else if(argument instanceof Long){
			Long value = (Long) argument;
			node = new AMT_DAO_ConditionNode(operator,fieldName,value);
		}else if(argument instanceof Boolean){
			Boolean value = (Boolean) argument;
			node = new AMT_DAO_ConditionNode(operator,fieldName,value);
		}else if(argument instanceof List<String>){
			List<String> value = (List<String>) argument;
			node = new AMT_DAO_ConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value));
		}else if(argument instanceof List<Integer>){
			List<Integer> value = (List<Integer>) argument;
			new AMT_DAO_ConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value));
		}else if(argument instanceof List<Long>){
			List<Long> value = (List<Long>) argument;
			new AMT_DAO_ConditionNode(operator,fieldName,AMT_DAO_UTL_DaoUtils.listToString(value));
		}else if(argument instanceof DateTime){
			DateTime value = (DateTime) argument;
			String timeZone = additionalParameter == null ? AMT_DAO_UTL_DaoUtils.DEFAULT_TIME_ZONE : additionalParameter;
			String dateTimeLiteral = value.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'',timeZone);
			node = new AMT_DAO_ConditionNode(operator,fieldName,dateTimeLiteral);
		}else if(argument instanceof AMT_DAO_DateLiterals){
			AMT_DAO_DateLiterals value = (AMT_DAO_DateLiterals) argument;
			String literal = AMT_DAO_UTL_DaoUtils.dateLiteralToString(value,Integer.valueOf(additionalParameter));
			node = new AMT_DAO_ConditionNode(operator,fieldName,literal);
		} 

		if(this.treeManager != null){
			return this.treeManager.addNode(node,this.treeManager.getRootNode());
		}else{
			return false;
		}
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
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,DateTime value,String timeZone){		
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,Decimal value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,Long value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,Boolean value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value,null);	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,literalValue,String.valueOf(value));
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,String value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value,null);	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Decimal value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value,null);	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Long value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value,null);	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Boolean value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value,null);	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,DateTime value,String timeZone){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,literalValue,String.valueOf(value));
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,String value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,Decimal value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,Long value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,DateTime value,String timeZone){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
			Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,literalValue,String.valueOf(value));
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,String value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Decimal value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Long value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,DateTime value,String timeZone){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,literalValue,String.valueOf(value));
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,String value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,Decimal value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,Long value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,DateTime value,String timeZone){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,literalValue,String.valueOf(value));
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,String value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Decimal value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Long value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,DateTime value,String timeZone){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value,timeZone);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,literalValue,String.valueOf(value));
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLike(String fieldName,String value){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LIKE_EXP,fieldName,value,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeIn(String fieldName,List<String> values){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,fieldName,values,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeIn(String fieldName,List<Integer> values){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,fieldName,values,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeIn(String fieldName,List<Decimal> values){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,fieldName,values,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeIn(String fieldName,List<Long> values){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,fieldName,values,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<String> values){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,fieldName,values,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<Integer> values){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,fieldName,values,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<Decimal> values){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,fieldName,values,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<Long> values){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,fieldName,values,null);
		return checkInsertion(isNodeInserted);
	}
	
	public AMT_DAO_ConditionBuilder makeIncludes(String fieldName,List<String> values){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.INCLUDES_EXP,fieldName,values,null);
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeExcludes(String fieldName,List<String> values){
		Boolean isNodeInserted = this.insertNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EXCLUDES_EXP,fieldName,values,null);
		return checkInsertion(isNodeInserted);
	}
	
}
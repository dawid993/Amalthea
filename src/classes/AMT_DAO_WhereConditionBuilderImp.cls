public class AMT_DAO_WhereConditionBuilderImp implements AMT_DAO_ConditionBuilder{

	private static final String DATE_LITERALS_SUB_SIGN = '_n';

	public static final String DEFAULT_TIME_ZONE = 'GMT';

	public static final String NULL_VALUE = 'null';

	
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

	private String listToString(List<String> inputValues){
		String values='';
		for(String s:inputValues){
			values+=this.insertApostrophes(s)+',';
		}

		values = values.removeEnd(',');
		return this.insertBrackets(values);
	}

	private String listToString(List<Integer> inputNumbers){
		String values='';
		for(Integer s:inputNumbers){
			values+=s+',';
		}

		values = values.removeEnd(',');
		return this.insertBrackets(values);
	}

	private String listToString(List<Decimal> inputDecimals){
		String values='';
		for(Decimal s:inputDecimals){
			values+=s+',';
		}

		values = values.removeEnd(',');
		return this.insertBrackets(values);
	}

	private String listToString(List<Long> inputLongs){
		String values='';
		for(Long s:inputLongs){
			values+=s+',';
		}

		values = values.removeEnd(',');
		return this.insertBrackets(values);
	}

	private String dateLiteralToString(AMT_DAO_DateLiterals literal,Integer value){
		if(literal == null ||
			 (value == null && literal.name().contains(DATE_LITERALS_SUB_SIGN))){
			throw new AMT_DAO_NodeException('Can not create Date Literal expression. Passed parameters are null!');
		}else{
			String stringLiteral = literal.name();
			if(stringLiteral.contains(DATE_LITERALS_SUB_SIGN)){
				stringLiteral = stringLiteral.replace(DATE_LITERALS_SUB_SIGN, ':'+value);
			}
			return stringLiteral;
		}
	}

	private String insertApostrophes(String value){
		return '\''+value+'\'';
	}

	private String insertBrackets(String value){
		return '('+value+')';
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
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,
			value == NULL_VALUE ? value : this.insertApostrophes(value));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,DateTime value,String timeZone){
		timeZone = timeZone == null ? DEFAULT_TIME_ZONE : timeZone;
		String dateTimeLiteral = value.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'',timeZone);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,dateTimeLiteral);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,Integer value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,Decimal value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,Long value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,Boolean value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		String literal = dateLiteralToString(literalValue,value);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,literal);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,String value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,
			value == NULL_VALUE ? value : this.insertApostrophes(value));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Integer value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Decimal value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Long value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Boolean value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName,DateTime value,String timeZone){
		timeZone = timeZone == null ? DEFAULT_TIME_ZONE : timeZone;
		String dateTimeLiteral = value.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'',timeZone);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,dateTimeLiteral);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotEq(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		String literal = dateLiteralToString(literalValue,value);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EQ,fieldName,literal);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,String value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,this.insertApostrophes(value));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,Integer value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,Decimal value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,Long value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName,DateTime value,String timeZone){
		timeZone = timeZone == null ? DEFAULT_TIME_ZONE : timeZone;
		String dateTimeLiteral = value.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'',timeZone);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,dateTimeLiteral);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLt(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		String literal = dateLiteralToString(literalValue,value);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT,fieldName,literal);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,String value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,this.insertApostrophes(value));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Integer value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Decimal value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Long value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,DateTime value,String timeZone){
		timeZone = timeZone == null ? DEFAULT_TIME_ZONE : timeZone;
		String dateTimeLiteral = value.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'',timeZone);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,dateTimeLiteral);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		String literal = dateLiteralToString(literalValue,value);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LT_OR_EQ,fieldName,literal);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,String value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,this.insertApostrophes(value));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,Integer value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,Decimal value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName,Long value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

		public AMT_DAO_ConditionBuilder makeGt(String fieldName,DateTime value,String timeZone){
		timeZone = timeZone == null ? DEFAULT_TIME_ZONE : timeZone;
		String dateTimeLiteral = value.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'',timeZone);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,dateTimeLiteral);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGt(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		String literal = dateLiteralToString(literalValue,value);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT,fieldName,literal);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,String value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,this.insertApostrophes(value));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Integer value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Decimal value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Long value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,value);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}	

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,DateTime value,String timeZone){
		timeZone = timeZone == null ? DEFAULT_TIME_ZONE : timeZone;
		String dateTimeLiteral = value.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'',timeZone);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,dateTimeLiteral);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName, AMT_DAO_DateLiterals literalValue, Integer value){
		String literal = dateLiteralToString(literalValue,value);
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.GT_OR_EQ,fieldName,literal);
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeLike(String fieldName,String value){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.LIKE_EXP,fieldName,this.insertApostrophes(value));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeIn(String fieldName,List<String> values){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,fieldName,this.listToString(values));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeIn(String fieldName,List<Integer> values){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,fieldName,this.listToString(values));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeIn(String fieldName,List<Decimal> values){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,fieldName,this.listToString(values));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeIn(String fieldName,List<Long> values){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.IN_EXP,fieldName,this.listToString(values));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<String> values){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,fieldName,this.listToString(values));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<Integer> values){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,fieldName,this.listToString(values));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<Decimal> values){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,fieldName,this.listToString(values));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<Long> values){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_IN,fieldName,this.listToString(values));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}
	
	public AMT_DAO_ConditionBuilder makeIncludes(String fieldName,List<String> values){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.INCLUDES_EXP,fieldName,this.listToString(values));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}

	public AMT_DAO_ConditionBuilder makeExcludes(String fieldName,List<String> values){
		AMT_DAO_Node node = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EXCLUDES_EXP,fieldName,this.listToString(values));
		Boolean isNodeInserted = this.treeManager.addNode(node,this.treeManager.getRootNode());	
		return checkInsertion(isNodeInserted);
	}
	
}
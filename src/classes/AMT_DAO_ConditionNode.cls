public class AMT_DAO_ConditionNode implements AMT_DAO_Node{

	private AMT_DAO_OperatorUtils.AMT_DAO_Operator conditionOperator;

	private String leftArgument;

	private String rightArgument;

	private String expression;

	public AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Object value){		
		if(operator == null || String.isBlank(fieldName)){
			throw new AMT_DAO_NodeException('Node can not be created because key parameters are not initialized!');
		}		
		this.conditionOperator = operator;
		this.leftArgument = fieldName;

		if(value instanceof Date){
			this.rightArgument = String.valueOf( (Date) value);
		}else{
			this.rightArgument = String.valueOf(value);
		}
	}
	
	public String evaluate(){		
		String operatorSign = AMT_DAO_OperatorUtils.operatorToSoqlSign.get(conditionOperator.name());
		this.expression = '('+leftArgument+operatorSign+rightArgument+')';
		return this.getExpression();
	}

	public Boolean isLeaf(){
		return true;
	}

	public String getExpression(){
		return this.expression;
	}

	public AMT_DAO_Node getLeftChild(){
		throw new AMT_DAO_NodeException('Left Child not present in condition node.');
	}

	public AMT_DAO_Node getRightChild(){
		throw new AMT_DAO_NodeException('Right Child not present in logical node.');
	}

	public AMT_DAO_OperatorUtils.AMT_DAO_Operator getOperator(){
		return this.conditionOperator;
	}

	public String getLeftArgument(){
		return this.leftArgument;
	}

	public String getRightArgument(){
		return this.rightArgument;
	}
}
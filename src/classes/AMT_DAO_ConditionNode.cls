 public class AMT_DAO_ConditionNode implements AMT_DAO_Node{

	private AMT_DAO_OperatorUtils.AMT_DAO_Operator conditionOperator;

	private String leftArgument;

	private String rightArgument;

	private String expression;

	 public AMT_DAO_ConditionNode(){

	 }

	public AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Object value){
		if(operator == null || String.isBlank(fieldName)){
			throw new AMT_DAO_NodeException('Node can not be created because key parameters are not initialized!');
		}		
		this.conditionOperator = operator;
		this.leftArgument = fieldName;
		this.rightArgument = String.valueOf(value);

	}

	 public AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator,String fieldName,Date value){
		 if(operator == null || String.isBlank(fieldName)){
			 throw new AMT_DAO_NodeException('Node can not be created because key parameters are not initialized!');
		 }
		 this.conditionOperator = operator;
		 this.leftArgument = fieldName;
		 this.rightArgument = String.valueOf( (Date) value);
	 }
	
	public String evaluate(){		
		String operatorSign = AMT_DAO_OperatorUtils.operatorToSoqlSign.get(conditionOperator.name());
		this.expression = AMT_DAO_UTL_DaoUtils.insertBrackets
				(leftArgument+AMT_DAO_UTL_DaoUtils.insertSpaces(operatorSign)+rightArgument);
		return this.getExpression();
	}

	 public void setOperator(AMT_DAO_OperatorUtils.AMT_DAO_Operator operator){
		 this.conditionOperator = operator;
	 }

	 public void setRightArgument(String rightArgument){
		 this.rightArgument = rightArgument;
	 }

	 public void setLeftArgument(String leftArgument){
		this.leftArgument = leftArgument;
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
		throw new AMT_DAO_NodeException('Right Child not present in condition node.');
	}

	public AMT_DAO_OperatorUtils.AMT_DAO_Operator getOperator(){
		return this.conditionOperator;
	}

	// Both method should be declared by properties method. Needles Code.
	public String getLeftArgument(){
		return this.leftArgument;
	}

	public String getRightArgument(){
		return this.rightArgument;
	}
}
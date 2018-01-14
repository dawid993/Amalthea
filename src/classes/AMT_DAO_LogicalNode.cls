public class AMT_DAO_LogicalNode implements AMT_DAO_Node{

	private AMT_DAO_Operator logicalOperator;

	private String expression;

	public AMT_DAO_Node leftChild {get;set;}

	public AMT_DAO_Node rightChild {get;set;}

	public AMT_DAO_LogicalNode() {
	}

	public AMT_DAO_LogicalNode(AMT_DAO_Operator operator) {
		this.logicalOperator = operator;
	}

	public String evaluate(){		
		if(this.isNotNode()){
			this.expression = evaluateForNotOperator();
		}else{
			this.expression = evaluteForAndOrOperators();
		}
		return this.getExpression();
	}

	public void setOperator(AMT_DAO_Operator operator){
		this.logicalOperator = operator;
	}

	public Boolean isLeaf(){
		return false;
	}

	public String getExpression(){
		return this.expression;
	}

	public AMT_DAO_Node getLeftChild(){
		return this.leftChild;
	}

	public AMT_DAO_Node getRightChild(){
		if(this.isNotNode()){
			throw new AMT_DAO_NodeException('Not Node can not have right child.');
		}
		return this.rightChild;
	}

	public AMT_DAO_Operator getOperator(){
		return this.logicalOperator;
	}

	public String getLeftArgument(){
		throw new AMT_DAO_NodeException('Left argument not present in logical node.');
	}

	public String getRightArgument(){
		throw new AMT_DAO_NodeException('Right argument not present in logical node.');
	}

	public void setRightArgument(String rightArgument){
		throw new AMT_DAO_NodeException('Right argument not present in logical node.');
	}

	public void setLeftArgument(String leftArgument){
		throw new AMT_DAO_NodeException('Left argument not present in logical node.');
	}

	private String evaluateForNotOperator(){
		String operatorSign = AMT_DAO_OperatorUtils.operatorToSoqlSign.get(logicalOperator.name());
		return AMT_DAO_UTL_DaoUtils.insertBrackets
				(AMT_DAO_UTL_DaoUtils.insertSpaces(operatorSign)+ this.leftChild.evaluate());
	}

	private String evaluteForAndOrOperators(){
		String operatorSign = AMT_DAO_OperatorUtils.operatorToSoqlSign.get(logicalOperator.name());
		try{
			String leftChildEvaluate = this.leftChild.evaluate();
			String rightChildEvaluate = this.rightChild.evaluate();		
			return AMT_DAO_UTL_DaoUtils.insertBrackets
					(leftChildEvaluate+AMT_DAO_UTL_DaoUtils.insertSpaces(operatorSign)+rightChildEvaluate);
		}catch(Exception ex){
			throw new AMT_DAO_NodeException('Logical tree has inproper structure. Please check your statements.');
		}
	}

	private Boolean isNotNode(){
		return this.getOperator() == AMT_DAO_Operator.NOT_EXP;
	}
}
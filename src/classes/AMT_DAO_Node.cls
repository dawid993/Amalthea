public interface AMT_DAO_Node {
	
	String evaluate();

	Boolean isLeaf();

	String getExpression();

	AMT_DAO_Node getLeftChild();

	AMT_DAO_Node getRightChild();

	AMT_DAO_Operator getOperator();

	String getLeftArgument();

	String getRightArgument();

	void setOperator(AMT_DAO_Operator operator);

	void setRightArgument(String rightArgument);

	void setLeftArgument(String rightArgument);

}
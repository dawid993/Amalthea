public class AMT_DAO_WhereConditionBuilderImp implements AMT_DAO_ConditionBuilder{
	
	private AMT_DAO_TreeConditionBuilderManager treeManager;

	public AMT_DAO_WhereConditionBuilderImp(){
		treeManager = new AMT_DAO_TreeConditionBuilderManagerImp();
	}

	public AMT_DAO_ConditionBuilder makeAnd(){
		AMT_DAO_Node andNode = new AMT_DAO_LogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.AND_EXP);
		this.treeManager.addNode(andNode,this.treeManager.getRootNode());
		return this;
	}

	public AMT_DAO_ConditionBuilder makeOr(){
		AMT_DAO_Node andNode = new AMT_DAO_LogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.OR_EXP);
		System.debug(this.treeManager.addNode(andNode,this.treeManager.getRootNode()));
		System.debug(this.treeManager.getRootNode());
		return this;
	}

	public AMT_DAO_ConditionBuilder makeNot(){
		AMT_DAO_Node andNode = new AMT_DAO_LogicalNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.NOT_EXP);
		this.treeManager.addNode(andNode,this.treeManager.getRootNode());
		return this;
	}

	public AMT_DAO_ConditionBuilder makeEq(String fieldName,String value){
		AMT_DAO_Node eqNode = new AMT_DAO_ConditionNode(AMT_DAO_OperatorUtils.AMT_DAO_Operator.EQ,fieldName,value);
		System.debug(this.treeManager.addNode(eqNode,this.treeManager.getRootNode()));
		return this;
	}

	public String evaluate(){
		return treeManager.getRootNode().evaluate();
	}
}
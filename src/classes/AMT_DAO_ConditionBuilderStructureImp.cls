public class AMT_DAO_ConditionBuilderStructureImp implements AMT_DAO_ConditionBuilderTreeStructure {
	public AMT_DAO_Node rootNode;	

	public Boolean addNode(AMT_DAO_Node newNode){
		return addNode(newNode,rootNode);
	}

	private Boolean addNode(AMT_DAO_Node newNode,AMT_DAO_Node currentNode){
		if(currentNode == null){
			this.rootNode = newNode;			
			return true;
		}

		if(currentNode.isLeaf()){
			return false;
		}

		if(currentNode.getLeftChild() == null){
			AMT_DAO_LogicalNode logicNode = (AMT_DAO_LogicalNode) currentNode;
			logicNode.leftChild = newNode;
			return true;
		}else{
			Boolean recursiveReturnedValue = this.addNode(newNode,currentNode.getLeftChild());
			if(recursiveReturnedValue){
				return true;
			}

			if(currentNode.getOperator() == AMT_DAO_Operator.NOT_EXP){
				return false;
			}

			if(currentNode.getRightChild() == null){
				AMT_DAO_LogicalNode logicNode = (AMT_DAO_LogicalNode) currentNode;
				logicNode.rightChild = newNode;
				return true;
			}else{
				return this.addNode(newNode,currentNode.getRightChild());				 
			}
		}
	}

	public AMT_DAO_Node getRootNode(){
		return rootNode;
	}

	public void flush(){
		this.rootNode = null;
	}
}
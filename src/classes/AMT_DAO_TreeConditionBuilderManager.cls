public interface AMT_DAO_TreeConditionBuilderManager {

	Boolean addNode(AMT_DAO_Node newNode,AMT_DAO_Node baseNode);

	AMT_DAO_Node getRootNode();
}
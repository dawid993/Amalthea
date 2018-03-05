/**
 * Created by Dawid on 2017-10-22.
 */
global class AMT_DAO_ServiceProvider {

	public static final String CONDITION_BUILDER_SETTING = 'ConditionBuilderImplementation';

	public static final String CONDITION_BUILDER_STRUCTURE_SETTING = 'ConditionStructureImplementation';

	public static final String LOGICAL_NODE_SETTING = 'LogicalNodeImplementation';

	public static final String CONDITION_NODE_SETTING = 'ConditionNodeImplementation';

	global static AMT_DAO_SelectSubQuery getSelectSubQuery(sObjectType sObjectType,String relationName){
		AMT_DAO_SelectSubQuery subQuery;
		subQuery = (AMT_DAO_SelectSubQuery) AMT_DAO_ServiceProvider.constructObjectForService('AMT_DAO_SelectSubQueryBuilder');
		subQuery.createSelectSubQuery(sObjectType,relationName);
		return subQuery;
	}	

	public static AMT_DAO_ConditionBuilder getConditionBuilder(){
		AMT_DAO_ConditionBuilder conditionBuilder;
		String conditionBuilderImplementation =
				AMT_DAO_ServiceProvider.getImplementationName(AMT_DAO_ServiceProvider.CONDITION_BUILDER_SETTING);
		conditionBuilder =
			(AMT_DAO_ConditionBuilder) AMT_DAO_ServiceProvider.constructObjectForService(conditionBuilderImplementation);
		return conditionBuilder;
	}

	public static AMT_DAO_ConditionBuilderTreeStructure getConditionBuilderStructure(){
		AMT_DAO_ConditionBuilderTreeStructure conditionStructure;
		String conditionStructureImplementation =
				AMT_DAO_ServiceProvider.getImplementationName(AMT_DAO_ServiceProvider.CONDITION_BUILDER_STRUCTURE_SETTING);
		conditionStructure =(AMT_DAO_ConditionBuilderTreeStructure)
				AMT_DAO_ServiceProvider.constructObjectForService(conditionStructureImplementation);
		return conditionStructure;
	}

	public static AMT_DAO_Node getLogicalNode(){
		AMT_DAO_Node logicalNode;
		String nodeImplementation = AMT_DAO_ServiceProvider.getImplementationName(AMT_DAO_ServiceProvider.LOGICAL_NODE_SETTING);
		logicalNode = (AMT_DAO_Node) AMT_DAO_ServiceProvider.constructObjectForService(nodeImplementation);
		return logicalNode;
	}

	public static AMT_DAO_Node getConditionNode(){
		AMT_DAO_Node conditionlNode;
		String conditionImplementation = AMT_DAO_ServiceProvider.getImplementationName(AMT_DAO_ServiceProvider.CONDITION_NODE_SETTING);
		conditionlNode = (AMT_DAO_Node) AMT_DAO_ServiceProvider.constructObjectForService(conditionImplementation);
		return conditionlNode;
	}

	private static String getImplementationName(String settingName){
		AMT_ServiceConfiguration__c impName = AMT_ServiceConfiguration__c.getInstance(settingName);
		if(impName != null && String.isNotBlank(impName.ServiceName__c)){
			return impName.ServiceName__c;
		}else{
			return null;
		}
	}

	private static Object constructObjectForService(String serviceName){
		try{
			Object serviceImplementation;
			Type serviceType = Type.forName(serviceName);
			serviceImplementation = serviceType.newInstance();
			return serviceImplementation;
		}catch(Exception ex){
			System.debug(ex.getMessage());
			throw new AMT_DAO_ServiceConstructionException('Can\'t create service named: '+serviceName
					+', Reason: '+ex.getMessage());
		}
		return null;
	}
}
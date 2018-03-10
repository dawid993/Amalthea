global class AMT_DAO_QueryProviderService {

    global static AMT_DAO_Query getQuery(sObjectType objectType){
        return new AMT_DAO_QueryImp(objectType);
    }

    global static AMT_DAO_Query getQuery(sObjectType objectType,List<String> fieldNames){
        return new AMT_DAO_QueryImp(objectType,fieldNames);
    }

    global static AMT_DAO_Query getSubQuery(sObjectType objectType,String relationName){
        return new AMT_DAO_SelectSubQueryImp(objectType,relationName);
    }

    global static AMT_DAO_Query getSubQuery(sObjectType objectType,String relationName,List<String> fieldNames){
         return new AMT_DAO_SelectSubQueryImp(objectType,relationName,fieldNames);
    }

    global static AMT_DAO_Query getConditionQuery(sObjectType objectType,String idField){
        return new AMT_DAO_ConditionSubQueryImp(objectType,idField);
    } 
}
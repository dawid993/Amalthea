public interface AMT_DAO_CreatableQuery {
    AMT_DAO_SelectSubQuery createSelectSubQuery(Schema.sObjectType sObjectType,String relationName);

    AMT_DAO_SelectSubQuery createSelectSubQuery(Schema.sObjectType sObjectType,String relationName,List<String> fieldNames);
}
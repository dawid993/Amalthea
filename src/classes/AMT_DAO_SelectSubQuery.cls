global interface AMT_DAO_SelectSubQuery extends AMT_DAO_Query {
    AMT_DAO_SelectSubQuery createSelectSubQuery(Schema.sObjectType sObjectType,String relationName);

    AMT_DAO_SelectSubQuery createSelectSubQuery(Schema.sObjectType sObjectType,String relationName,List<String> fieldNames);

}
public class AMT_DAO_ConditionSubQueryBuilder extends AMT_DAO_QueryBuilder {

    public AMT_DAO_ConditionSubQueryBuilder(){

    }
    
    public AMT_DAO_ConditionSubQueryBuilder(Schema.sObjectType sObjectType,String idFieldName){
        super(sObjectType,new List<String>{idFieldName});   
    }
}
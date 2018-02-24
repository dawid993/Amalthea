public class AMT_DAO_SubQueryBuilder extends AMT_DAO_QueryBuilder{    
    public String relationName {get;set;}

    public AMT_DAO_SubQueryBuilder(Schema.sObjectType sObjectType,String relationName){
        super(sObjectType);        
        this.relationName = relationName;
    }

     public AMT_DAO_SubQueryBuilder(Schema.sObjectType sObjectType,String relationName,List<String> fieldNames){
        super(sObjectType,fieldNames);        
        this.relationName = relationName;
    }

    public override String getQuery(){
        String query = super.getQuery();
        if(String.isNotBlank(query)){
            query = query.replace('FROM '+sObjectType.getDescribe().getName(),'FROM '+relationName);
        }
        return query;
    }
}
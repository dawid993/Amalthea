global class AMT_DAO_SelectSubQueryBuilder extends AMT_DAO_QueryBuilder implements AMT_DAO_SelectSubQuery{        
    public String relationName {get;set;}

    public AMT_DAO_SelectSubQueryBuilder(){

    }
    
    public AMT_DAO_SelectSubQueryBuilder(Schema.sObjectType sObjectType,String relationName){
        super(sObjectType);        
        this.relationName = relationName;
    }

     public AMT_DAO_SelectSubQueryBuilder(Schema.sObjectType sObjectType,String relationName,List<String> fieldNames){
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

    global AMT_DAO_SelectSubQuery createSelectSubQuery(Schema.sObjectType sObjectType,String relationName){
        if(this.SObjectType != null){
            throw new AMT_DAO_QueryException('Object has been initialized already.');
        }else{
            super.init(sObjectType);
            this.relationName = relationName;
            return this;
        }
    }       

    global AMT_DAO_SelectSubQuery createSelectSubQuery(Schema.sObjectType sObjectType,String relationName,List<String> fieldNames){
        if(this.SObjectType != null){
            throw new AMT_DAO_QueryException('Object has been initialized already.');
        }else{
            createSelectSubQuery(SObjectType,relationName);
            super.setSelectFields(fieldNames);
            return this;
        }
    }
}
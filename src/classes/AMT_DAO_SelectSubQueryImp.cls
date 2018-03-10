global class AMT_DAO_SelectSubQueryImp extends AMT_DAO_QueryImp{        
    public String relationName {get;set;}

    public AMT_DAO_SelectSubQueryImp(){

    }
    
    public AMT_DAO_SelectSubQueryImp(Schema.sObjectType sObjectType,String relationName){
        super(sObjectType);        
        this.relationName = relationName;
    }

     public AMT_DAO_SelectSubQueryImp(Schema.sObjectType sObjectType,String relationName,List<String> fieldNames){
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
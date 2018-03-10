public class AMT_DAO_ConditionSubQueryImp extends AMT_DAO_QueryImp {

    public AMT_DAO_ConditionSubQueryImp(){

    }
    
    public AMT_DAO_ConditionSubQueryImp(Schema.sObjectType sObjectType,String idFieldName){
        super(sObjectType,new List<String>{idFieldName});   
    }
}
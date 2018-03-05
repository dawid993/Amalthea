global class AMT_DAO_DateLiteralEvaluator {

	public AMT_DAO_DateLiteral literal {get;set;}

	public Integer value{get;set;}

	global AMT_DAO_DateLiteralEvaluator(AMT_DAO_DateLiteral literal, Integer value){
		this.literal = literal;
		this.value = value;
	}

	public String evaluate(){
		return AMT_DAO_UTL_DaoUtils.dateLiteralToString(this,this.value);
	}
}
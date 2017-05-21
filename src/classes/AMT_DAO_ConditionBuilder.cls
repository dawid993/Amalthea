public interface AMT_DAO_ConditionBuilder {

	String evaluate();

	AMT_DAO_ConditionBuilder makeAnd();

	AMT_DAO_ConditionBuilder makeOr();

	AMT_DAO_ConditionBuilder makeNot();

	AMT_DAO_ConditionBuilder makeEq(String fieldName,String value);
}
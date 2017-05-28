public interface AMT_DAO_ConditionBuilder {

	String evaluate();

	AMT_DAO_ConditionBuilder makeAnd();

	AMT_DAO_ConditionBuilder makeOr();

	AMT_DAO_ConditionBuilder makeNot();

	AMT_DAO_ConditionBuilder makeEq(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeEq(String fieldName,Integer value);

	AMT_DAO_ConditionBuilder makeEq(String fieldName,Decimal value);

	AMT_DAO_ConditionBuilder makeEq(String fieldName,Long value);

	AMT_DAO_ConditionBuilder makeEq(String fieldName,Boolean value);

	AMT_DAO_ConditionBuilder makeEq(String fieldName,DateTime value,String timeZone);

	AMT_DAO_ConditionBuilder makeEq(String fieldName,Date value);

	AMT_DAO_ConditionBuilder makeNotEq(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Integer value);

	AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Decimal value);

	AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Long value);

	AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Boolean value);

	AMT_DAO_ConditionBuilder makeLt(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeLt(String fieldName,Integer value);

	AMT_DAO_ConditionBuilder makeLt(String fieldName,Decimal value);

	AMT_DAO_ConditionBuilder makeLt(String fieldName,Long value);

	AMT_DAO_ConditionBuilder makeGt(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeGt(String fieldName,Integer value);

	AMT_DAO_ConditionBuilder makeGt(String fieldName,Decimal value);

	AMT_DAO_ConditionBuilder makeGt(String fieldName,Long value);

	AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Integer value);

	AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Decimal value);

	AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Long value);

	AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,DateTime value,String timeZone);

	AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Integer value);

	AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Decimal value);

	AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Long value);

	AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,DateTime value,String timeZone);

	AMT_DAO_ConditionBuilder makeLike(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeIn(String fieldName,List<String> values);

	AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<String> values);

	AMT_DAO_ConditionBuilder makeIncludes(String fieldName,List<String> value);

	AMT_DAO_ConditionBuilder makeExcludes(String fieldName,List<String> value);
}
public interface AMT_DAO_ConditionBuilder {	

	String evaluate();

	AMT_DAO_ConditionBuilder makeAnd();

	AMT_DAO_ConditionBuilder makeOr();

	AMT_DAO_ConditionBuilder makeNot();

	AMT_DAO_ConditionBuilder makeEq(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeEq(String fieldName,Object value);	

	AMT_DAO_ConditionBuilder makeEq(String fieldName,DateTime value,String timeZone);

	AMT_DAO_ConditionBuilder makeEq(String fieldName,AMT_DAO_DateLiterals literalValue);

	AMT_DAO_ConditionBuilder makeEq(String fieldName,AMT_DAO_DateFunction dateFunction,Object additionalValue);

	AMT_DAO_ConditionBuilder makeNotEq(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeNotEq(String fieldName,Object value);	

	AMT_DAO_ConditionBuilder makeNotEq(String fieldName,DateTime value,String timeZone);

	AMT_DAO_ConditionBuilder makeNotEq(String fieldName,AMT_DAO_DateLiterals literalValue);

	AMT_DAO_ConditionBuilder makeNotEq(String fieldName,AMT_DAO_DateFunction dateFunction,Object additionalValue);

	AMT_DAO_ConditionBuilder makeLt(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeLt(String fieldName,Object value);	

	AMT_DAO_ConditionBuilder makeLt(String fieldName,DateTime value,String timeZone);

	AMT_DAO_ConditionBuilder makeLt(String fieldName,AMT_DAO_DateLiterals literalValue);

	AMT_DAO_ConditionBuilder makeLt(String fieldName,AMT_DAO_DateFunction dateFunction,Object additionalValue);

	AMT_DAO_ConditionBuilder makeGt(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeGt(String fieldName,Object value);

	AMT_DAO_ConditionBuilder makeGt(String fieldName,DateTime value,String timeZone);

	AMT_DAO_ConditionBuilder makeGt(String fieldName,AMT_DAO_DateLiterals literalValue);

	AMT_DAO_ConditionBuilder makeGt(String fieldName,AMT_DAO_DateFunction dateFunction,Object additionalValue);

	AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,Object value);	

	AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,DateTime value,String timeZone);

	AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,AMT_DAO_DateLiterals literalValue);

	AMT_DAO_ConditionBuilder makeLtOrEq(String fieldName,AMT_DAO_DateFunction dateFunction,Object additionalValue);

	AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,Object value);	

	AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,DateTime value,String timeZone);

	AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,AMT_DAO_DateLiterals literalValue);

	AMT_DAO_ConditionBuilder makeGtOrEq(String fieldName,AMT_DAO_DateFunction dateFunction,Object additionalValue);

	AMT_DAO_ConditionBuilder makeLike(String fieldName,String value);

	AMT_DAO_ConditionBuilder makeIn(String fieldName,List<String> values);

	AMT_DAO_ConditionBuilder makeIn(String fieldName,List<Object> values);	

	AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<String> values);

	AMT_DAO_ConditionBuilder makeNotIn(String fieldName,List<Object> values);	

	AMT_DAO_ConditionBuilder makeIncludes(String fieldName,List<String> value);

	AMT_DAO_ConditionBuilder makeExcludes(String fieldName,List<String> value);
}
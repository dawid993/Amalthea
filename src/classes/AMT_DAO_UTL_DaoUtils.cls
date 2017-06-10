public class AMT_DAO_UTL_DaoUtils {

	public static final String DATE_LITERALS_SUB_SIGN = '_n';

	public static final String DEFAULT_TIME_ZONE = 'GMT';

	public static final String NULL_VALUE = 'null';

	public static String listToString(List<String> inputValues){
		String values='';
		for(String s:inputValues){
			values+=AMT_DAO_UTL_DaoUtils.insertApostrophes(s)+',';
		}

		values = values.removeEnd(',');
		return AMT_DAO_UTL_DaoUtils.insertBrackets(values);
	}

	public static String listToString(List<Integer> inputNumbers){
		String values='';
		for(Integer s:inputNumbers){
			values+=s+',';
		}

		values = values.removeEnd(',');
		return AMT_DAO_UTL_DaoUtils.insertBrackets(values);
	}

	public static String listToString(List<Decimal> inputDecimals){
		String values='';
		for(Decimal s:inputDecimals){
			values+=s+',';
		}

		values = values.removeEnd(',');
		return AMT_DAO_UTL_DaoUtils.insertBrackets(values);
	}

	public static String listToString(List<Long> inputLongs){
		String values='';
		for(Long s:inputLongs){
			values+=s+',';
		}

		values = values.removeEnd(',');
		return AMT_DAO_UTL_DaoUtils.insertBrackets(values);
	}

	public static String dateLiteralToString(AMT_DAO_DateLiterals literal,Integer value){
		if(literal == null ||
			 (value == null && literal.name().contains(DATE_LITERALS_SUB_SIGN))){
			throw new AMT_DAO_NodeException('Can not create Date Literal expression. Passed parameters are null!');
		}else{
			String stringLiteral = literal.name();
			if(stringLiteral.contains(DATE_LITERALS_SUB_SIGN)){
				stringLiteral = stringLiteral.replace(DATE_LITERALS_SUB_SIGN, ':'+value);
			}
			return stringLiteral;
		}
	}

	public static String insertApostrophes(String value){
		return '\''+value+'\'';
	}

	public static String insertBrackets(String value){
		return '('+value+')';
	}
}
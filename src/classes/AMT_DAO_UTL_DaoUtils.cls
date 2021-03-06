public class AMT_DAO_UTL_DaoUtils {

	public static final String DATE_LITERALS_SUB_SIGN = '_n';

	public static final String DEFAULT_TIME_ZONE = 'GMT';

	public static final String NULL_VALUE = 'null';

	public static final String DATE_TIME_FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'';

	public static String listToString(List<String> inputValues){
		String values='';
		for(String s:inputValues){
			values+=AMT_DAO_UTL_DaoUtils.insertApostrophes(s)+',';
		}

		values = values.removeEnd(',');
		return AMT_DAO_UTL_DaoUtils.insertBrackets(values);
	}

	public static String listToString(List<Object> inputValues){
		String values='';
		for(Object s:inputValues){
			values+=String.valueOf(s)+',';
		}

		values = values.removeEnd(',');
		return AMT_DAO_UTL_DaoUtils.insertBrackets(values);
	}	

	public static String dateLiteralToString(AMT_DAO_DateLiteralEvaluator literal, Integer value){
		if(literal == null ||
			 (value == null && literal.literal.name().contains(DATE_LITERALS_SUB_SIGN))){
			throw new AMT_DAO_NodeException('Can not create Date Literal expression. Passed parameters are null!');
		}else{
			String stringLiteral = literal.literal.name();
			if(stringLiteral.contains(DATE_LITERALS_SUB_SIGN)){
				stringLiteral = stringLiteral.replace(DATE_LITERALS_SUB_SIGN, ':'+value);
			}
			return stringLiteral;
		}
	}

	public static String insertApostrophes(String value){
		if(String.isNotBlank(value)){
			return '\''+value+'\'';
		}else{
			return null;
		}
	}

	public static String insertBrackets(String value){
		if(String.isNotBlank(value)){
			return '('+value+')';
		}else{
			return null;
		}
	}

	public static String insertSpaces(String value){
		if(String.isNotBlank(value)){
			return ' '+value+' ';
		}else{
			return null;
		}
	}

	public static void escapeSingleQuotes(List<String> values){
		for(Integer i =0; i<values.size(); i++){
			values[i] = String.escapeSingleQuotes(values[i]);
		}
	}

	public static void escapeSingleQuotes(List<Object> values){
		for(Integer i =0; i<values.size(); i++){
			values[i] = String.escapeSingleQuotes(String.valueOf(values[i]));
		}
	}
}
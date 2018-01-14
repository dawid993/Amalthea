public class AMT_DAO_OperatorUtils {
	public static Map<String,String> operatorToSoqlSign = new Map<String,String> {
		'AND_EXP' => 'AND',
		'OR_EXP' => 'OR',
		'NOT_EXP' => 'NOT',
		'EQ' => '=',
		'NOT_EQ' => '!=',
		'GT' => '>',
		'LT' => '<',
		'LT_OR_EQ' => '<=',
		'GT_OR_EQ' => '>=',
		'LIKE_EXP' => 'LIKE',
		'IN_EXP' => 'IN',
		'NOT_IN' => 'NOT IN',
		'INCLUDES_EXP' => 'INCLUDES',
		'EXCLUDES_EXP' => 'EXCLUDES'
	};
}
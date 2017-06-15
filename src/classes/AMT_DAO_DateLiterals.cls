public class AMT_DAO_DateLiterals {	

	public DateLiterals literal {get;set;}

	public Integer value{get;set;}

	public AMT_DAO_DateLiterals(DateLiterals literal,Integer value){
		this.literal = literal;
		this.value = value;
	}

	public String evaluate(){
		return AMT_DAO_UTL_DaoUtils.dateLiteralToString(this,this.value);
	}

	public enum DateLiterals{
		YESTERDAY,
		TODAY,
		TOMORROW,
		LAST_WEEK,
		THIS_WEEK,
		NEXT_WEEK,
		LAST_MONTH,
		THIS_MONTH,
		NEXT_MONTH,
		LAST_90_DAYS,
		NEXT_90_DAYS,
		LAST_N_DAYS_n,
		NEXT_N_DAYS_n,
		NEXT_N_WEEKS_n,
		LAST_N_WEEKS_n,
		NEXT_N_MONTHS_n,
		LAST_N_MONTHS_n,
		THIS_QUARTER,
		LAST_QUARTER,
		NEXT_QUARTER,
		NEXT_N_QUARTERS_n,
		LAST_N_QUARTERS_n,
		THIS_YEAR,
		LAST_YEAR,
		NEXT_YEAR,
		NEXT_N_YEARS_n,
		LAST_N_YEARS_n,
		THIS_FISCAL_QUARTER,
		LAST_FISCAL_QUARTER,
		NEXT_FISCAL_QUARTER,	
		THIS_FISCAL_YEAR,
		LAST_FISCAL_YEAR,
		NEXT_FISCAL_YEAR	
	}


}
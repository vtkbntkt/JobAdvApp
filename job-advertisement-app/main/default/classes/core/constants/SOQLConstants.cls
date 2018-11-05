public class SOQLConstants {    
    public static final String POINTER = '?';
    public static final String STATEMENT_SELECT = 'SELECT';
    public static final String STATEMENT_FROM = 'FROM';
    public static final String STATEMENT_WHERE = 'WHERE';
    public static final String STATEMENT_AND = 'AND';
    public static final String STATEMENT_OR = 'OR';
    public static final String STATEMENT_LIKE = 'LIKE';
    public static final String STATEMENT_IN = 'IN';
    public static final String FIELD_NAME = 'name';
    public static final String FIELD_STATUS = 'status__c';
    public static final String FIELD_SALARY_FROM = 'salary_from__c';
    public static final String FIELD_SALARY_TO = 'salary_to__c';
    public static final String FIELD_CREATED_DATE = 'createddate';
    public static final String FIELD_LOCATION = 'Location__c';
    public static final String STANDARD_FIELD_CREATED_DATE = 'createdDate';

    public static final String TABLE_JOB_ADVERTISEMENT = 'Job_Advertisement__c';
    public static final String QUERY_BASE_EXP = 'SELECT ?, ?, ?, ? FROM Job_Advertisement__c';
    public static final String QUERY_BASE_EXP_WITH_DATE = 'SELECT ?, ?, ?, ?,? FROM Job_Advertisement__c';
    public static final String QUERY_BASE_EXP_RESUMES_WITH_JOB_ADS = 'SELECT (SELECT Job_Advertisement__r.id FROM SentResumes__r),'+ 
    'First_Name__c,Last_Name__c,Age__c,Phone__c,Email__c,Education__c,Currently_Employed__c,Country__c,City__c,State_Province__c,'+
    'Zip_Postal_Code__c,Street_Address__c,Salary__c,Years_of_Experience__c,Additional_Info__c,PhotoFileId__c FROM Resume__c';
    public static final String QUERY_BASE_EXP_RESUMES_NUMBER = 'SELECT COUNT() FROM Resume__c';
    public static final String QUERY_OPERATOR_ANY = '%';
    public static final String QUERY_OPERATOR_EQUAL = '=';
    public static final String TIME_ADDITION = 'T23:59:59Z';
    public static final Map<String,String> CUSTOM_EXPRESSIONS;
    
    static {
    CUSTOM_EXPRESSIONS = new Map<String,String>();
    CUSTOM_EXPRESSIONS.put('EXP_SALARY_EQUAL', '((salary_from__c<=? AND salary_to__c>=?) OR (salary_from__c<=? AND salary_to__c=null))');
    CUSTOM_EXPRESSIONS.put('EXP_SALARY_LESS', 'salary_from__c<?');
    CUSTOM_EXPRESSIONS.put('EXP_SALARY_MORE','(salary_to__c>? OR salary_to__c=null)');
    CUSTOM_EXPRESSIONS.put('EXP_SALARY_LESSOREQUAL',  'salary_from__c<=?');
    CUSTOM_EXPRESSIONS.put('EXP_SALARY_MOREOREQUAL',  '(salary_to__c>=? OR salary_to__c=null)');
    CUSTOM_EXPRESSIONS.put('EXP_SALARY_NOTEQUAL',  '(salary_from__c>? OR salary_to__c<?)');       
    CUSTOM_EXPRESSIONS.put('EXP_CREATED_DATE_EQUAL', '(createddate>?T00:00:00Z AND createddate<?T23:59:59Z)');
   }

}
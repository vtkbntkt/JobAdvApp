public class Query {    
    private String query;
    public static final String COMMA = ',';
    public static final String SPACE = ' ';
    public static final String EMPTY = '';
    public static final String QUOTE = '\'';
    public static final String LEFT_BRACKET = '(';
    public static final String RIGHT_BRACKET = ')';
    
    
    public Query(){
        query = EMPTY; 
    }
    
    public Query append(String value){
        if(isAllowed(value)){
            query+=value;
        }
        return this;
    }
    
    public Query appendEqual(String field, String value){
        this.append(field).append(SOQLConstants.QUERY_OPERATOR_EQUAL).append(value);
        return this;
    }
    
    public Query appendEqualWithQuotes(String field, String value){
        this.append(field).append(SOQLConstants.QUERY_OPERATOR_EQUAL)
            .append(QUOTE).append(value).append(QUOTE);
        
        return this;
    }
    
    public Query appendWithWildCardAnyFull(String field, String value){
        String exp = field+SPACE+SOQLConstants.STATEMENT_LIKE+
            SPACE+QUOTE+SOQLConstants.QUERY_OPERATOR_ANY+value+
            SOQLConstants.QUERY_OPERATOR_ANY+QUOTE;
        return append(exp);
    }
    
    public Query appendINStatement(String field, List<String> values){     
        String exp = field+SPACE+SOQLConstants.STATEMENT_IN+SPACE+LEFT_BRACKET;
        for(String value:values){
            exp+=QUOTE+value+QUOTE+COMMA;
        }
        exp = exp.substring(0, exp.length()-1); 
        exp+=RIGHT_BRACKET;
        return append(exp);
    }
    
    public Query appendSpace(){
        query+=SPACE;
        return this;
    }
    
    public Query appendComma(){ 
        query+=COMMA;
        return this;
    }
    
    public Query appendByPointer(String expression, List<String> values){
        Integer pointerNumber = expression.countMatches(SOQLConstants.POINTER);
        if(pointerNumber!=values.size()||pointerNumber==0){
            throw new QueryCreationException('Illegal argument number'); 
        }
        Integer addedValuesNum = 0;
        List<String> chars = expression.split(EMPTY);       
        for(String charX:chars){           
            if(charX.equals(SOQLConstants.POINTER)){
                query+=values.get(addedValuesNum);
                addedValuesNum++;
            }
            else{
                query+=charX;
            }           
        }
        return this;       
    }
    
    public Query appendByPointer(String expression, String valueForAllPointers){
        Integer pointerNumber = expression.countMatches(SOQLConstants.POINTER); 
        if(pointerNumber==0){
            throw new QueryCreationException('Illegal argument number');
        }
        List<String> values = new List<String>();
        for(Integer i=0;i<pointerNumber;i++){
            values.add(valueForAllPointers);   
        }
        return appendByPointer(expression, values);       
    }
    
    private Boolean isAllowed(String value){
        if(value.equals(SOQLConstants.STATEMENT_WHERE) && query.contains(SOQLConstants.STATEMENT_WHERE)){
            return false;
        }
        return true;
    }
    
    public String getQueryAsString(){ 
        return query;
    }
    
    public class ExpandedStringList {
        private List<String> values;
        
        public ExpandedStringList(String value){
            values = new List<String>();
            values.add(value);
        }
        
        public ExpandedStringList add(String value){
            values.add(value);
            return this;
        }
        
        public List<String> getList(){
            return values;
        }
    }
    
    
    
    
}
public class QueryBuilder { 
    
    public static String getQueryByJobAdsFilter(Filter filter){
        Query query = new Query();
        query.appendByPointer(SOQLConstants.QUERY_BASE_EXP, 
                              new Query.ExpandedStringList(SOQLConstants.FIELD_NAME)
                              .add(SOQLConstants.FIELD_SALARY_FROM)
                              .add(SOQLConstants.FIELD_SALARY_TO)
                              .add(SOQLConstants.FIELD_STATUS)
                              .getList());  
        
        List<String> salaryValue = filter.filterItems.get(Constants.FILTER_ITEM_NAME_SALARY_VALUE).getValues();
        List <String> salaryConditions = filter.filterItems.get(Constants.FILTER_ITEM_NAME_SALARY_CONDITIONS).getValues();
        List<String> jobTitle = filter.filterItems.get(Constants.FILTER_ITEM_NAME_ADV_TITLE).getValues();
        List<String> advStatuses = filter.filterItems.get(Constants.FILTER_ITEM_NAME_STATUS).getValues();
        if(!salaryValue.isEmpty()){ 
            if(!salaryConditions.isEmpty()){
                query.appendSpace().append(SOQLConstants.STATEMENT_WHERE).appendSpace()
                    .appendByPointer(SOQLConstants.CUSTOM_EXPRESSIONS.get(salaryConditions.get(0)),salaryValue.get(0));              
            }
        }
        
        if(!jobTitle.isEmpty()){
            if(!salaryValue.isEmpty()){
                query.appendSpace().append(SOQLConstants.STATEMENT_AND).appendSpace();
            }
            else{
                query.appendSpace().append(SOQLConstants.STATEMENT_WHERE).appendSpace();
            }            
            query.appendWithWildCardAnyFull(SOQLConstants.FIELD_NAME,jobTitle.get(0));
        }
      
        if (!advStatuses.isEmpty()){
            if(!jobTitle.isEmpty()||!salaryValue.isEmpty()){
                query.appendSpace().append(SOQLConstants.STATEMENT_AND).appendSpace();
            }
            else{
                query.appendSpace().append(SOQLConstants.STATEMENT_WHERE).appendSpace(); 
            }
            query.appendINStatement(SOQLConstants.FIELD_STATUS, advStatuses);  
        }
        return query.getQueryAsString();
    }
    
    public static String getQueryByJobAdsSiteFilter(Filter filter){
    Query query = new Query();
        query.appendByPointer(SOQLConstants.QUERY_BASE_EXP_WITH_DATE, 
                              new Query.ExpandedStringList(SOQLConstants.FIELD_NAME)
                              .add(SOQLConstants.FIELD_SALARY_FROM)
                              .add(SOQLConstants.FIELD_SALARY_TO)
                              .add(SOQLConstants.FIELD_STATUS)
                               .add(SOQLConstants.FIELD_LOCATION).getList());  
        
       
        List<String> salaryValue = filter.filterItems.get(Constants.FILTER_ITEM_NAME_SALARY_VALUE).getValues();
        List <String> salaryConditions = filter.filterItems.get(Constants.FILTER_ITEM_NAME_SALARY_CONDITIONS).getValues();
        List<String> jobTitle = filter.filterItems.get(Constants.FILTER_ITEM_NAME_ADV_TITLE).getValues();
        List<String> creationDate = filter.filterItems.get(Constants.FILTER_ITEM_NAME_CREATION_DATE).getValues();
        
        if(!salaryValue.isEmpty()){ 
            if(!salaryConditions.isEmpty()){
                query.appendSpace().append(SOQLConstants.STATEMENT_WHERE).appendSpace()
                    .appendByPointer(SOQLConstants.CUSTOM_EXPRESSIONS.get(salaryConditions.get(0)),salaryValue.get(0));              
            }
        }
        
        if(!jobTitle.isEmpty()){
            if(!salaryValue.isEmpty()){
                query.appendSpace().append(SOQLConstants.STATEMENT_AND).appendSpace();
            }
            else{
                query.appendSpace().append(SOQLConstants.STATEMENT_WHERE).appendSpace();
            }            
            query.appendWithWildCardAnyFull(SOQLConstants.FIELD_NAME,jobTitle.get(0));
        }
        
      
        if (!creationDate.isEmpty()){
            if(!jobTitle.isEmpty()||!salaryValue.isEmpty()){
                query.appendSpace().append(SOQLConstants.STATEMENT_AND).appendSpace();
            }
            else{
                query.appendSpace().append(SOQLConstants.STATEMENT_WHERE).appendSpace(); 
            }
            query.appendByPointer(SOQLConstants.CUSTOM_EXPRESSIONS.get('EXP_CREATED_DATE_EQUAL'),creationDate.get(0)); 
        }
        return query.getQueryAsString();
    
    }

    public static String getResumeQueryByCreatedDateParam(String createdDate){
    Query query = new Query();
        query.append(SOQLConstants.QUERY_BASE_EXP_RESUMES_WITH_JOB_ADS)
        .appendSpace().append(SOQLConstants.STATEMENT_WHERE).appendSpace()
        .appendByPointer(SOQLConstants.CUSTOM_EXPRESSIONS.get('EXP_CREATED_DATE_EQUAL'), createdDate);
        return query.getQueryAsString();
    }

    public static String getResumeNumberQueryByCreatedDateParam(String createdDate){
    Query query = new Query();
        query.append(SOQLConstants.QUERY_BASE_EXP_RESUMES_NUMBER)
        .appendSpace().append(SOQLConstants.STATEMENT_WHERE).appendSpace()
        .appendByPointer(SOQLConstants.CUSTOM_EXPRESSIONS.get('EXP_CREATED_DATE_EQUAL'), createdDate);
        return query.getQueryAsString();
    }
}
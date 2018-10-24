public class  JobAdvertisementListController {
    private final Integer DEFAULT_PAGE_SIZE=10;
    public Filter advFilter{get;set;}
    private ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {         
                setCon = new ApexPages.StandardSetController(
                    Database.getQueryLocator(QueryBuilder.getQueryByJobAdsFilter(advFilter)));
            }
            return setCon;
        }     
        set; 
    }
    
    public List<WrappedJobAdvertisement> wrappedAds{
        get {             
            wrappedAds = wrapAdvertisement(getAdsFromBase());           
            return wrappedAds;
        }  
        set;
    }
    
    //Constructor
    public JobAdvertisementListController() { 
        System.debug('*** Init constructor start');
        advFilter = new Filter();
        initAdvFilter();      
        setCon.setPageSize(DEFAULT_PAGE_SIZE);
        //selectedProducts = new WrappedProductContainer();            
    }
    
    
    private void initAdvFilter(){ 
        // add salary conditions
        Map<String, String> optionsForSalary = new Map<String,String>();
        optionsForSalary.put('EXP_SALARY_EQUAL', System.Label.Filter_list_equal);
        optionsForSalary.put('EXP_SALARY_LESS', System.Label.Filter_list_less);
        optionsForSalary.put('EXP_SALARY_MORE', System.Label.Filter_list_more);
        optionsForSalary.put('EXP_SALARY_LESSOREQUAL', System.Label.Filter_list_lessorequal);
        optionsForSalary.put('EXP_SALARY_MOREOREQUAL', System.Label.Filter_list_moreorequal);
        optionsForSalary.put('EXP_SALARY_NOTEQUAL', System.Label.Filter_list_notequal); 
        SelectList salarySelectList = new SelectList(optionsForSalary);
        advFilter.addFilterItem(Constants.FILTER_ITEM_NAME_SALARY_CONDITIONS,salarySelectList);
        
        //add salary value
        advFilter.addFilterItem(Constants.FILTER_ITEM_NAME_SALARY_VALUE, new InputField()); 
        
        //add advertisement title value
        advFilter.addFilterItem(Constants.FILTER_ITEM_NAME_ADV_TITLE, new InputField());
        
        //add stauses selection
        SelectList statusSelectList = 
            new SelectList(Job_Advertisement__c.Status__c.getDescribe().getPicklistValues());
        advFilter.addFilterItem(Constants.FILTER_ITEM_NAME_STATUS,statusSelectList);         
    }
    
    private List<Job_Advertisement__c> getAdsFromBase() {        
        return (List<Job_Advertisement__c>) setCon.getRecords();       
    }
    
    private List<WrappedJobAdvertisement> wrapAdvertisement(List<Job_Advertisement__c> ads){
        List<WrappedJobAdvertisement> wrappedAds = new List<WrappedJobAdvertisement>();
        for(Job_Advertisement__c adv:ads){
            wrappedAds.add(new WrappedJobAdvertisement(adv));
        }
        return wrappedAds;        
    }
    
    public void applyFilters(){
        List<String> errors = checkFilter();
        if(errors.isEmpty()){
            Integer currentPageSize = setCon.getPagesize();
            setCon=null;
            setCon.setPageSize(currentPageSize);
            first();          
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,String.join(errors, '\n')));
        }
        
    }
    
    public void clearFilters(){      
        Integer currentPageSize = setCon.getPagesize();
        advFilter.clearFilterItem();
        setCon=null;
        setCon.setPageSize(currentPageSize);
        first();  
    }
    
    private List<String> checkFilter(){
        List<String> errors = new List<String>();
        List<String> salaryValue = 
            advFilter.filterItems.get(Constants.FILTER_ITEM_NAME_SALARY_VALUE).getValues(); 
        if(!salaryValue.isEmpty()&&!salaryValue.get(0).isNumeric()){
            errors.add(System.Label.Error_salary_value);  
        }
        return errors;
    }
    
    public void setPageNumber(Integer pageNumber){
        setCon.setPageNumber(pageNumber);
    }
    
    public Integer getResultSize(){
        return setCon.getResultSize();
    }
    
    public Void previous(){
        setCon.previous();
    }
    
    public Boolean getHasPrevious(){
        return setCon.getHasPrevious();
    }
    
    public Boolean getHasNext(){
        return setCon.getHasNext();
    }   
    
    public Void next(){
        setCon.next();
    }
    
    public void last(){
        setCon.last();
    }
    
    public void first(){
        setCon.first();
    } 
    
    public Integer getPageNumber(){
        return setCon.getPageNumber();
    }
    
    public Void setPageSize(Integer pageSize){
        setCon.setPageSize(pageSize);
    }
    
    public Integer getPageSize(){
        return setCon.getPageSize();
    }    
}
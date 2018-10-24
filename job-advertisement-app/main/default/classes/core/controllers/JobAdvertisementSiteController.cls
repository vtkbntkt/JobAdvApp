public class JobAdvertisementSiteController {   
    private final Integer DEFAULT_PAGE_SIZE=10;
    public Filter advFilter{get;set;}
    public List<WrappedJobAdvertisement> selectedwrappedAds{get;set;}
    private ApexPages.StandardSetController setCon {
        get {
            
            if(setCon == null) {         
                setCon = new ApexPages.StandardSetController(
                    Database.getQueryLocator(QueryBuilder.getQueryByJobAdsSiteFilter(advFilter)));
            }
            return setCon; 
        }     
        set;
    }
    
    public List<WrappedJobAdvertisement> wrappedAds{
        get { 
            if(wrappedAds==null){
                wrappedAds = wrapAdvertisement(getAdsFromBase()); 
                updateSelectionStatus();
            }
            return wrappedAds;
        }  
        set;        
    }
    
    //Constructor
    public JobAdvertisementSiteController() { 
        advFilter = new Filter();
        initAdvFilter();      
        setCon.setPageSize(DEFAULT_PAGE_SIZE);
        selectedwrappedAds = new List<WrappedJobAdvertisement>();
        ControllerContext.getInstance().put(Constants.CONTEXT_SELECTED_JOB_ADV, selectedwrappedAds);
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
        
        //add date creation selection
        advFilter.addFilterItem(Constants.FILTER_ITEM_NAME_CREATION_DATE, new InputField());               
    }
    
    public void updateSelectionStatus(){      
        for(WrappedJobAdvertisement jobAdv : selectedwrappedAds){
            WrappedJobAdvUtils.changeSelectionStatusById(jobAdv,true,wrappedAds);           
        }
    }
    
    
    public void addToSelectedList(){        
        String selectedJobAdvId = ApexPages.currentPage().getParameters().get(Constants.REQUEST_PARAMS_SELECTED_AD_ID);
        if (selectedJobAdvId != null) {
            WrappedJobAdvertisement jobAdv = WrappedJobAdvUtils.getJobAdvById(selectedJobAdvId, wrappedAds);
            if(jobAdv!=null){
                jobAdv.isSelected = true;
                WrappedJobAdvUtils.addUniqueById(jobAdv, selectedwrappedAds);
            }           
        }        
    }
     
    public void removeFromSelectedList(){  
        String selectedJobAdvId = ApexPages.currentPage().getParameters().get(Constants.REQUEST_PARAMS_REMOVED_AD_ID);
        if(selectedJobAdvId!=null){
            WrappedJobAdvertisement jobAdv = WrappedJobAdvUtils.getJobAdvById(selectedJobAdvId, wrappedAds);
            if(jobAdv!=null){
                jobAdv.isSelected = false;
                WrappedJobAdvUtils.removeFromListById(jobAdv,selectedwrappedAds);                  
            }           
        }    
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
        wrappedAds = null;
        setCon.previous();
    }
    
    public Boolean getHasPrevious(){
        return setCon.getHasPrevious();
    }   
    
    public Boolean getHasNext(){
        return setCon.getHasNext();
    }
    
    
    public Void next(){
        wrappedAds = null;
        setCon.next();
    }
    
    public void last(){
        wrappedAds = null;
        setCon.last();
    }
    
    public void first(){
        wrappedAds = null;
        setCon.first();
    } 
    
    public Integer getPageNumber(){
        return setCon.getPageNumber();
    }
    
    public Void setPageSize(Integer pageSize){
        wrappedAds = null;
        setCon.setPageSize(pageSize);
    }
    
    public Integer getPageSize(){
        return setCon.getPageSize();
    }      
}
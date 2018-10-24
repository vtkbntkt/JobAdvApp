@isTest
private class JobAdvertisementListControllerTest {
     
    @isTest static void test_Filters_CaseEqual(){ 
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementListController controller = new JobAdvertisementListController();
        setSalaryCondition(controller,'EXP_SALARY_EQUAL');
        setSalaryValue(controller,'81000');
        setAdvertisementStatuses(controller, new TestDataFactory.ExpandedStringList('Active').getList());      
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(1, wrappedAds.size());
        System.assertEquals('Java developer', wrappedAds.get(0).adv.name);
    }
    
    @isTest static void test_Filters_CaseLess(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementListController controller = new JobAdvertisementListController();
        setSalaryCondition(controller,'EXP_SALARY_LESS');
        setSalaryValue(controller,'120000');
        setAdvertisementStatuses(controller, new TestDataFactory.ExpandedStringList('Active').add('On hold').getList()); 
        setJobTitle(controller,'Developer');
        
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(3, wrappedAds.size());
        
        System.assert(TestDataFactory.listsAreEqual(wrappedAds, 
                                                    new TestDataFactory.ExpandedStringList('Front-end Developer')
                                                    .add('Pega Developer').add('Java developer').getList()));
    }
    
    @isTest static void test_Filters_CaseMore(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementListController controller = new JobAdvertisementListController();
        setSalaryCondition(controller,'EXP_SALARY_MORE');
        setSalaryValue(controller,'80000');
        setAdvertisementStatuses(controller, 
                                 new TestDataFactory.ExpandedStringList('Active').add('On hold').add('Archive').getList()); 
        setJobTitle(controller,'server');
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(3, wrappedAds.size());        
        System.assert(TestDataFactory.listsAreEqual(wrappedAds, 
                                                    new TestDataFactory.ExpandedStringList('Beer Server')
                                                    .add('In Room Dining Server').add('Restaurant Server').getList()));
    }
    
    @isTest static void test_Filters_CaseLessOrEqual(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementListController controller = new JobAdvertisementListController();
        setSalaryCondition(controller,'EXP_SALARY_LESSOREQUAL');
        setSalaryValue(controller,'50000');
        setAdvertisementStatuses(controller, 
                                 new TestDataFactory.ExpandedStringList('Active').add('On hold').add('Archive').getList()); 
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(3, wrappedAds.size());        
        System.assert(TestDataFactory.listsAreEqual(wrappedAds, 
                                                    new TestDataFactory.ExpandedStringList('Pega Developer')
                                                    .add('Server').add('Rigger').getList()));
    }
    
    @isTest static void test_Filters_CaseMoreOrEqual(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementListController controller = new JobAdvertisementListController();
        setSalaryCondition(controller,'EXP_SALARY_MOREOREQUAL');
        setSalaryValue(controller,'75000');
        setAdvertisementStatuses(controller, 
                                 new TestDataFactory.ExpandedStringList('Active').getList()); 
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(4, wrappedAds.size());        
        System.assert(TestDataFactory.listsAreEqual(wrappedAds, 
                                                    new TestDataFactory.ExpandedStringList('Java trainee')
                                                    .add('Trainee java').add('Java developer').add('Pega Developer').getList()));
    }
    
    @isTest static void test_Filters_CaseNotEqual(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementListController controller = new JobAdvertisementListController();
        setSalaryCondition(controller,'EXP_SALARY_NOTEQUAL');
        setSalaryValue(controller,'130000');
        setAdvertisementStatuses(controller, 
                                 new TestDataFactory.ExpandedStringList('Archive').getList()); 
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(3, wrappedAds.size());        
        System.assert(TestDataFactory.listsAreEqual(wrappedAds, 
                                                    new TestDataFactory.ExpandedStringList('Rigger')
                                                    .add('Restaurant Server').add('Associate Trainee').getList()));
    }
    
    @isTest static void test_Filters_CaseEqualNoRelevantSalary(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementListController controller = new JobAdvertisementListController();
        setSalaryCondition(controller,'EXP_SALARY_EQUAL');
        setSalaryValue(controller,'49000');
        
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(0, wrappedAds.size());        
    }
    
    @isTest static void test_FiltersNegativeSalary(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementListController controller = new JobAdvertisementListController();
        setSalaryCondition(controller,'EXP_SALARY_EQUAL');
        setSalaryValue(controller,'-25');
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<Apexpages.Message> msgs = ApexPages.getMessages();      
        boolean result = false;       
        for(Apexpages.Message msg:msgs){           
            if (msg.getDetail().contains(System.Label.Error_salary_value)) result = true;          
        }      
        System.assert(result);      
    }
    
    @isTest static void test_FiltersNotNumericSalary(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementListController controller = new JobAdvertisementListController();
        setSalaryCondition(controller,'EXP_SALARY_EQUAL');
        setSalaryValue(controller,'rrrrr');
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<Apexpages.Message> msgs = ApexPages.getMessages();      
        boolean result = false;       
        for(Apexpages.Message msg:msgs){           
            if (msg.getDetail().contains(System.Label.Error_salary_value)) result = true;          
        }      
        System.assert(result);      
    }
    
    @isTest static void test_FilterClearing(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementListController controller = new JobAdvertisementListController();
        setSalaryCondition(controller,'EXP_SALARY_NOTEQUAL');
        setSalaryValue(controller,'130000');
        setAdvertisementStatuses(controller, 
                                 new TestDataFactory.ExpandedStringList('Archive').getList()); 
        
        //When
        Test.startTest();
        controller.applyFilters();
        
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(3, wrappedAds.size());        
        System.assert(TestDataFactory.listsAreEqual(wrappedAds, 
                                                    new TestDataFactory.ExpandedStringList('Rigger')
                                                    .add('Restaurant Server').add('Associate Trainee').getList()));
        
        //When  
        controller.setPageSize(100);      
        controller.clearFilters();
        Test.stopTest();
        
        //Then
        wrappedAds  = controller.wrappedAds;
        System.debug('***Test result*** '+wrappedAds);
        System.assertEquals(12, wrappedAds.size()); 
    }
    
    @isTest static void test_Pagenation(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        
        //When
        Test.startTest();
        JobAdvertisementListController controller = new JobAdvertisementListController();
        controller.setPageSize(100);
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(ads.size(), wrappedAds.size());
        System.assertEquals(ads.size(), controller.getResultSize());        
        
        
        //Given
        Integer pageSize = 5;
        setSalaryCondition(controller,'EXP_SALARY_MORE');
        setSalaryValue(controller,'1000');
        setAdvertisementStatuses(controller, 
                                 new TestDataFactory.ExpandedStringList('Archive').add('On hold').add('Active').getList());
        controller.setPageSize(pageSize);
        
        //When        
        controller.applyFilters();
        
        //Then - page size should be saved after filter applying
        wrappedAds  = controller.wrappedAds;
        System.assertEquals(ads.size(),controller.getResultSize());
        System.assertEquals(pageSize, wrappedAds.size());
        System.assertEquals(pageSize, controller.getPageSize());
        
        
        //Given
        Integer pageNumber = 2;
        
        //When
        controller.setPageNumber(pageNumber);
        
        //Then - test 'hasnext'
        System.assertEquals(pageNumber,controller.getPageNumber());
        System.assertEquals(controller.getResultSize()-controller.getPageSize()*pageNumber>0,controller.getHasNext());
        
        
        //When
        controller.next();
        
        //Then - test 'next'
        System.assertEquals(pageNumber+1,controller.getPageNumber());
        
        
        //When
        controller.last();
        
        //Then - test 'last'
        Decimal lastPageNamber = Decimal.valueOf(controller.getResultSize())/Decimal.valueOf(pageSize);
        lastPageNamber = lastPageNamber.round(roundingMode.UP);
        System.assertEquals(lastPageNamber,controller.getPageNumber());
        
        //When     
        controller.setPageNumber(pageNumber);
        
        //Then - test 'has previous'
        System.assertEquals(true,controller.getHasPrevious()); 
        
        
        //When
        controller.previous();
        
        //Then - test 'previous'
        System.assertEquals(pageNumber-1,controller.getPageNumber());
        
        
        //When        
        controller.last();
        controller.first();
        
        //Then - test 'first'
        System.assertEquals(1,controller.getPageNumber());
        Test.stopTest();       
    }
    
    private static void setSalaryCondition(JobAdvertisementListController controller, String condition){
        ((SelectList)controller.advFilter.filterItems
         .get(Constants.FILTER_ITEM_NAME_SALARY_CONDITIONS)).setValues(condition);
    }
    
    private static void setSalaryValue(JobAdvertisementListController controller, String salaryValue){
        ((InputField)controller.advFilter.filterItems
         .get(Constants.FILTER_ITEM_NAME_SALARY_VALUE)).value = salaryValue;
    }
    
    private static void setAdvertisementStatuses(JobAdvertisementListController controller, List<String> statusList){
        ((SelectList)controller.advFilter.filterItems
         .get(Constants.FILTER_ITEM_NAME_STATUS)).setValues(statusList);
    }
    
    private static void setJobTitle(JobAdvertisementListController controller, String jobTitle){
        ((InputField)controller.advFilter.filterItems
         .get(Constants.FILTER_ITEM_NAME_ADV_TITLE)).value = jobTitle;
    }
    
    private static List<Job_Advertisement__c> prepareAdsList(){
        List<Job_Advertisement__c> ads = new List<Job_Advertisement__c>();
        ads.add(new Job_Advertisement__c(name='Pega Developer',salary_from__c=50000, salary_to__c=75000, status__c='Active'));//
        ads.add(new Job_Advertisement__c(name='Java developer',salary_from__c=75000, salary_to__c=90000, status__c='Active'));
        ads.add(new Job_Advertisement__c(name='Trainee java',salary_from__c=90000, salary_to__c=120000, status__c='Active'));
        ads.add(new Job_Advertisement__c(name='Java trainee',salary_from__c=120000, status__c='Active'));
        ads.add(new Job_Advertisement__c(name='Server',salary_from__c=50000, salary_to__c=75000, status__c='On hold'));//
        ads.add(new Job_Advertisement__c(name='Front-end Developer',salary_from__c=75000, salary_to__c=90000, status__c='On hold'));
        ads.add(new Job_Advertisement__c(name='Beer Server',salary_from__c=90000, salary_to__c=120000, status__c='On hold'));
        ads.add(new Job_Advertisement__c(name='In Room Dining Server',salary_from__c=120000, status__c='On hold'));
        ads.add(new Job_Advertisement__c(name='Rigger',salary_from__c=50000, salary_to__c=75000, status__c='Archive'));///
        ads.add(new Job_Advertisement__c(name='Restaurant Server',salary_from__c=75000, salary_to__c=90000, status__c='Archive'));
        ads.add(new Job_Advertisement__c(name='Associate Trainee',salary_from__c=90000, salary_to__c=120000, status__c='Archive'));
        ads.add(new Job_Advertisement__c(name='Excavator Operator',salary_from__c=120000, status__c='Archive'));
        return ads;
    }
    
}
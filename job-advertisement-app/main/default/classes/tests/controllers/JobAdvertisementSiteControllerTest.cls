@isTest
private class JobAdvertisementSiteControllerTest {

    @isTest static void test_Filters_CaseEqual(){ 
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        setSalaryCondition(controller,'EXP_SALARY_EQUAL');
        setSalaryValue(controller,'81000');
        setCreatedDate(controller, Datetime.now().format('yyyy-MM-dd'));
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(3, wrappedAds.size());
        System.assert(TestDataFactory.listsAreEqual(wrappedAds, 
                                                    new TestDataFactory.ExpandedStringList('Java developer')
                                                    .add('Front-end Developer').add('Restaurant Server').getList()));
    }

    
    @isTest static void test_Filters_CaseLess(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        setSalaryCondition(controller,'EXP_SALARY_LESS');
        setSalaryValue(controller,'120000');
        setCreatedDate(controller, Datetime.now().format('yyyy-MM-dd'));
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
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        setSalaryCondition(controller,'EXP_SALARY_MORE');
        setSalaryValue(controller,'80000');
        setCreatedDate(controller, Datetime.now().format('yyyy-MM-dd'));
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
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        setSalaryCondition(controller,'EXP_SALARY_LESSOREQUAL');
        setSalaryValue(controller,'50000');
        setCreatedDate(controller, Datetime.now().format('yyyy-MM-dd'));
    
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
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        setSalaryCondition(controller,'EXP_SALARY_MOREOREQUAL');
        setSalaryValue(controller,'75000');
        setCreatedDate(controller, Datetime.now().format('yyyy-MM-dd'));        
        
        //When
        Test.startTest();
        controller.setPageSize(100); 
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(12, wrappedAds.size());        
    }

    @isTest static void test_Filters_CaseNotEqual(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        setSalaryCondition(controller,'EXP_SALARY_NOTEQUAL');
        setSalaryValue(controller,'130000');
        setCreatedDate(controller, Datetime.now().format('yyyy-MM-dd'));        

        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(9, wrappedAds.size());        
        System.assert(TestDataFactory.listsAreEqual(wrappedAds, 
                                                    new TestDataFactory.ExpandedStringList('Pega Developer')
                                                    .add('Java developer').add('Trainee java').add('Server')
                                                    .add('Front-end Developer').add('Beer Server')
                                                    .add('Rigger').add('Restaurant Server')
                                                    .add('Associate Trainee').getList()));
    }


        @isTest static void test_Filters_CaseEqualNoRelevantSalary(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        setSalaryCondition(controller,'EXP_SALARY_EQUAL');
        setSalaryValue(controller,'49000');
        setCreatedDate(controller, Datetime.now().format('yyyy-MM-dd'));        

        
        
        //When
        Test.startTest();
        controller.applyFilters();
        Test.stopTest();
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(0, wrappedAds.size());        
    }

    
        @isTest static void test_Filters_CaseEqualNoRelevantCreatedDate(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        setSalaryCondition(controller,'EXP_SALARY_EQUAL');
        setSalaryValue(controller,'81000');
        setCreatedDate(controller, '1901-10-10');        

        
        
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
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        setSalaryCondition(controller,'EXP_SALARY_EQUAL');
        setSalaryValue(controller,'-25');
        setCreatedDate(controller, Datetime.now().format('yyyy-MM-dd'));        

        
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
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        setSalaryCondition(controller,'EXP_SALARY_EQUAL');
        setSalaryValue(controller,'rrrrr');
        setCreatedDate(controller, Datetime.now().format('yyyy-MM-dd'));        

        
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

    
    @isTest static void test_Pagenation(){
        //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        
        //When
        Test.startTest();
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        controller.setPageSize(100);
        
        //Then
        List<WrappedJobAdvertisement> wrappedAds  = controller.wrappedAds;
        System.assertEquals(ads.size(), wrappedAds.size());
        System.assertEquals(ads.size(), controller.getResultSize());        
        
        
        //Given
        Integer pageSize = 5;
        setSalaryCondition(controller,'EXP_SALARY_MORE');
        setSalaryValue(controller,'1000');
        setCreatedDate(controller, Datetime.now().format('yyyy-MM-dd'));        
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

    
    @isTest static void test_addToSelectedList(){
         //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        WrappedJobAdvertisement wrappedJobAdv = controller.wrappedAds.get(0);
        ApexPages.currentPage().getParameters().put(Constants.REQUEST_PARAMS_SELECTED_AD_ID, wrappedJobAdv.adv.id);
      
        //When
        Test.startTest();
        controller.addToSelectedList();
        Test.stopTest();
        
        //Then
        System.assertEquals(wrappedJobAdv.adv.id, controller.selectedwrappedAds.get(0).adv.id); 
   

    }

    
    @isTest static void test_removeFromSelectedList(){
         //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        WrappedJobAdvertisement wrappedJobAdv = controller.wrappedAds.get(0);
        ApexPages.currentPage().getParameters().put(Constants.REQUEST_PARAMS_SELECTED_AD_ID, wrappedJobAdv.adv.id);
      
        //When
        Test.startTest();
        controller.addToSelectedList();
        
       //Then
        System.assertEquals(wrappedJobAdv.adv.id, controller.selectedwrappedAds.get(0).adv.id);

        //When
        ApexPages.currentPage().getParameters().put(Constants.REQUEST_PARAMS_REMOVED_AD_ID, wrappedJobAdv.adv.id);
        controller.removeFromSelectedList();
        Test.stopTest();

        //Then
        System.assert(controller.selectedwrappedAds.isEmpty());
    }

    
    @isTest static void test_updateSelectionStatus(){
         //Given
        List<Job_Advertisement__c> ads = prepareAdsList(); 
        insert ads;
        JobAdvertisementSiteController controller = new JobAdvertisementSiteController();
        WrappedJobAdvertisement wrappedJobAdv = controller.wrappedAds.get(0);
        ApexPages.currentPage().getParameters().put(Constants.REQUEST_PARAMS_SELECTED_AD_ID, wrappedJobAdv.adv.id);
      
        //When
        Test.startTest();
        controller.addToSelectedList();
        
       //Then
        System.assertEquals(wrappedJobAdv.adv.id, controller.selectedwrappedAds.get(0).adv.id);

        //When
        controller.first();
        Test.stopTest();

        //Then
        System.assert(controller.wrappedAds.get(0).isSelected);
    }

     private static void setCreatedDate(JobAdvertisementSiteController controller, String createdDate){
        ((InputField)controller.advFilter.filterItems
         .get(Constants.FILTER_ITEM_NAME_CREATION_DATE)).value = createdDate;
    }

    private static void setSalaryCondition(JobAdvertisementSiteController controller, String condition){
        ((SelectList)controller.advFilter.filterItems
         .get(Constants.FILTER_ITEM_NAME_SALARY_CONDITIONS)).setValues(condition);
    }
    
    private static void setSalaryValue(JobAdvertisementSiteController controller, String salaryValue){
        ((InputField)controller.advFilter.filterItems
         .get(Constants.FILTER_ITEM_NAME_SALARY_VALUE)).value = salaryValue;
    }
    
    private static void setJobTitle(JobAdvertisementSiteController controller, String jobTitle){
        ((InputField)controller.advFilter.filterItems
         .get(Constants.FILTER_ITEM_NAME_ADV_TITLE)).value = jobTitle;
    }

    private static List<Job_Advertisement__c> prepareAdsList(){
        List<Job_Advertisement__c> ads = new List<Job_Advertisement__c>();
        ads.add(new Job_Advertisement__c(name='Pega Developer',salary_from__c=50000, salary_to__c=75000));
        ads.add(new Job_Advertisement__c(name='Java developer',salary_from__c=75000, salary_to__c=90000));
        ads.add(new Job_Advertisement__c(name='Trainee java',salary_from__c=90000, salary_to__c=120000));
        ads.add(new Job_Advertisement__c(name='Java trainee',salary_from__c=120000));
        ads.add(new Job_Advertisement__c(name='Server',salary_from__c=50000, salary_to__c=75000));
        ads.add(new Job_Advertisement__c(name='Front-end Developer',salary_from__c=75000, salary_to__c=90000));
        ads.add(new Job_Advertisement__c(name='Beer Server',salary_from__c=90000, salary_to__c=120000));
        ads.add(new Job_Advertisement__c(name='In Room Dining Server',salary_from__c=120000));
        ads.add(new Job_Advertisement__c(name='Rigger',salary_from__c=50000, salary_to__c=75000));
        ads.add(new Job_Advertisement__c(name='Restaurant Server',salary_from__c=75000, salary_to__c=90000));
        ads.add(new Job_Advertisement__c(name='Associate Trainee',salary_from__c=90000, salary_to__c=120000));
        ads.add(new Job_Advertisement__c(name='Excavator Operator',salary_from__c=120000));
        return ads;
    }
    

}

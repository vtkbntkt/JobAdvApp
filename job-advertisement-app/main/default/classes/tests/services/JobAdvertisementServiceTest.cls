@isTest
private class JobAdvertisementServiceTest { 
    
    @IsTest static void test_getJobAdvertisementsCorrectly(){
        //Given 
        Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;
        
        //When
        String jobAdsJson = new JobAdvertisementService().getJobAdvertisements();
        List<Job_Advertisement__c> jobAds = (List<Job_Advertisement__c>)System.JSON.deserialize(jobAdsJson, List<Job_Advertisement__c>.class);
        
        //Then             
        System.assertEquals(1, jobAds.size());
        System.assertEquals(jobAdv.id, jobAds.get(0).id);        
    }
    
    @IsTest static void test_insertJobAdvertisementsByJsonCorrectly(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager"}}';
        
        //When
        String jobAdsJson = new JobAdvertisementService().insertJobAdvertisementsByJson(json);
        Map<String,Job_Advertisement__c> jobAds = 
            (Map<String,Job_Advertisement__c>)System.JSON.deserialize(jobAdsJson, Map<String,Job_Advertisement__c>.class);
        
        //Then
        List<Job_Advertisement__c> jobAdsFromBd = [SELECT name FROM Job_Advertisement__c WHERE name='Developer' OR name='Manager'];
        System.assertEquals(2, jobAdsFromBd.size());        
        System.assertNotEquals(null, jobAds.get('1').id);
        System.assertEquals('Developer', jobAds.get('1').name);
        System.assertNotEquals(null, jobAds.get('2').id);
        System.assertEquals('Manager', jobAds.get('2').name);
        
    }
    
    @IsTest static void test_insertJobAdvertisementsByJsonInvalidBodyType(){
        //Given        
        String json = '{"1":{"Name","Developer"},"2":{"Name":"Manager"}}';
        
        //When
        try{
            String jobAdsJson = new JobAdvertisementService().insertJobAdvertisementsByJson(json);
            System.assert(false,'Expected exception');
        } 
        catch(Exception exc){
            //Then
            System.assert(exc instanceof InvalidBodyTypeException );
        }
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_insertJobAdvertisementsByJsonInvalidBodyContent(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager","Status__c":"Undefined"}}';
        
        //When
        try{
            String jobAdsJson = new JobAdvertisementService().insertJobAdvertisementsByJson(json);
            System.assert(false,'Expected exception');
        } 
        catch(Exception exc){
            //Then
            System.assert(exc instanceof InvalidBodyContentException);  
        }                 
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_upsertJobAdvertisementsByJsonCorrectly(){
        //Given - test insert  
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager"}}';  
        JobAdvertisementService service = new JobAdvertisementService();
        
        //When - test insert
        service.upsertJobAdvertisementsByJson(json);
        
        //Then - test insert
        List<Job_Advertisement__c> jobAds = [SELECT id, name FROM Job_Advertisement__c WHERE name='Developer' OR name='Manager'];
        System.assertEquals(2, jobAds.size());
        
        //Given - test update
        Map<String,Job_Advertisement__c> newRecords = new Map<String,Job_Advertisement__c>();
        newRecords.put('3',new Job_Advertisement__c(name='Accountant'));
        newRecords.put('4',jobAds.get(0));
        newRecords.put('5',jobAds.get(1));
        json = Utils.jobAdsList2JsonAsString(newRecords);
        
        //When - test update
        service.upsertJobAdvertisementsByJson(json);
        
        //Then - test update
        jobAds = [SELECT name FROM Job_Advertisement__c ];
        System.assertEquals(3, [SELECT name FROM Job_Advertisement__c ].size());      
    }
    
    @IsTest static void test_upsertJobAdvertisementsByJsonInvalidBodyType(){
        //Given        
        String json = '{"1":{"Name","Developer"},"2":{"Name":"Manager"}}';
        
        //When
        try{
            new JobAdvertisementService().upsertJobAdvertisementsByJson(json);
            System.assert(false,'Expected exception');
        } 
        catch(Exception exc){
            //Then
            System.assert(exc instanceof InvalidBodyTypeException );
        }
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_upsertJobAdvertisementsByJsonInvalidBodyContent(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager","Status__c":"Undefined"}}';
        
        //When
        try{
            new JobAdvertisementService().upsertJobAdvertisementsByJson(json);
            System.assert(false,'Expected exception');
        } 
        catch(Exception exc){
            //Then
            System.assert(exc instanceof InvalidBodyContentException);  
        }                 
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_removeJobAdvertisementByJsonCorrectly(){
        //Given
        Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;       
        Map<String,Job_Advertisement__c> records = new Map<String,Job_Advertisement__c>();
        records.put('15',jobAdv);
        String json = 
            Utils.jobAdsList2JsonAsString(records);
        
        //When
        new JobAdvertisementService().removeJobAdvertisementByJson(json);
        
        //Then        
        List<Job_Advertisement__c> jobAds = [SELECT name FROM Job_Advertisement__c];
        System.assert(jobAds.isEmpty());
    }
    
    @IsTest static void test_removeJobAdvertisementByJsonInvalidBodyType(){
        //Given  
        Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;       
        Map<String,Job_Advertisement__c> records = new Map<String,Job_Advertisement__c>();
        records.put('15',jobAdv);
        String json = Utils.jobAdsList2JsonAsString(records);
        json = json.replace(':',',');
        
        //When
        try{
            new JobAdvertisementService().removeJobAdvertisementByJson(json);
            System.assert(false,'Expected exception');
        }
        catch(Exception exc){
            System.assert(exc instanceof InvalidBodyTypeException);  
        }
        
        //Then
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(1, advNum);
    }
    
    @IsTest static void test_removeJobAdvertisementByJsonInvalidBodyContent(){
        //Given
        Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;       
        Map<String,Job_Advertisement__c> records = new Map<String,Job_Advertisement__c>();
        records.put('15',jobAdv);
        String json = Utils.jobAdsList2JsonAsString(records);      
        
        //When
        new JobAdvertisementService().removeJobAdvertisementByJson(json);
        
        //Then        
        List<Job_Advertisement__c> jobAds = [SELECT name FROM Job_Advertisement__c];
        System.assert(jobAds.isEmpty());
        
        //When
        try{
            new JobAdvertisementService().removeJobAdvertisementByJson(json);
            System.assert(false,'Expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceof InvalidBodyContentException);  
        }             
    }

    
    
}
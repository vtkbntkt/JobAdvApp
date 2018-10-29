@isTest
private class ResumeServiceImplTest {
    
    @isTest static void test_addResumeWithJobAdsCorrectly(){
        //Given
        Integer jobAdNum = 10;
        Resume__c cv = TestDataFactory.getRandomResume(true);
        cv.First_Name__c = 'Test';
        List<Job_Advertisement__c> jobAds = TestDataFactory.prepareJobAdsList(jobAdNum, true);
        ResumeServiceImpl service = new ResumeServiceImpl();
        
        //When
        Test.startTest();
        service.addResumeWithJobAds(cv, jobAds);
        Test.stopTest();
        
        //Then
        List<Resume__c> resumes = [SELECT First_Name__c FROM Resume__c];
        System.assertEquals(1, resumes.size());
        System.assertEquals('Test', resumes.get(0).First_Name__c);
        List<SentResume__c> sentResumes = [SELECT id FROM SentResume__c WHERE Resume__c=:cv.id];
        System.assertEquals(jobAdNum, sentResumes.size());
    } 
    
    @isTest static void test_addResumeWithJobAdsDMLExcWithRollback(){
        //Given
        Integer jobAdNum = 10;
        Resume__c cv = TestDataFactory.getRandomResume(true);
        cv.First_Name__c = 'Test';
        List<Job_Advertisement__c> jobAds = TestDataFactory.prepareJobAdsList(jobAdNum, true);
        ResumeServiceImpl service = new ResumeServiceImpl();
        delete jobAds.get(0);
        
        //When
        Test.startTest();
        try{
            service.addResumeWithJobAds(cv, jobAds);
            System.assert(false,'Expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf ResumeServiceImplException);
            
        }
        Test.stopTest();
        
        //Test rollback
        List<Resume__c> resumes = [SELECT First_Name__c FROM Resume__c];
        System.assertEquals(1, resumes.size());
        System.assertNotEquals('Test', resumes.get(0).First_Name__c);   
    }

    
    @isTest static void test_attachPhotoToResumeCorrectly(){
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);
        ResumeServiceImpl service = new ResumeServiceImpl();
        
        //When
        Test.startTest();
        service.attachPhotoToResume(cv, 'path');
        Test.stopTest();
        
        //Then
        List<Resume__c> resumes = [SELECT PhotoFileId__c FROM Resume__c];
        System.assertEquals(1, resumes.size());
        System.assertEquals('path', resumes.get(0).PhotoFileId__c);
    } 
    
    @isTest static void test_attachPhotoToResumeExc(){
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);
        ResumeServiceImpl service = new ResumeServiceImpl();
        delete cv;
        
        //When
        Test.startTest();
        try{
        service.attachPhotoToResume(cv, 'path');
        System.assert(false,'Expected exception');

        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf ResumeServiceImplException);

        }
        Test.stopTest();
    } 

    @isTest static void test_getResumesAndJobAdsByResumeCreatedDate_Correctly(){
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);

        //When
        Test.startTest();
        String json = new ResumeServiceImpl().getResumesAndJobAdsByResumeCreatedDate(Datetime.now().format('yyyy-MM-dd'));
        Test.stopTest();

        //Then
        System.assertNotEquals(null,json);
        List<ResumeDTO> resumesDto = new List<ResumeDTO>();
        try{
            resumesDto = (List<ResumeDTO>)System.JSON.deserialize(json, List<ResumeDTO>.class);
        }
        catch(JsonException exc){
            System.assert(false, 'unexpected exception');
        }
        System.assert(!resumesDto.isEmpty());
        ResumeDTO resumeDto = resumesDto.get(0);
        System.assertEquals(cv.Age__c, Decimal.valueOf(resumeDto.age));
        System.assertEquals(cv.City__c, resumeDto.city);
        System.assertEquals(cv.Country__c, resumeDto.country);
        System.assertEquals(cv.Education__c, resumeDto.education);
        System.assertEquals(cv.Email__c, resumeDto.email);
        System.assertEquals(cv.First_Name__c, resumeDto.firstName);
        System.assertEquals(cv.Last_Name__c, resumeDto.lastName);
        System.assertEquals(cv.Phone__c, resumeDto.phone);		
        System.assertEquals(cv.Salary__c, Decimal.valueOf(resumeDto.salary));
        System.assertEquals(cv.State_Province__c, resumeDto.state);
        System.assertEquals(cv.Street_Address__c , resumeDto.street);
        System.assertEquals(cv.Years_of_Experience__c, Decimal.valueOf(resumeDto.experienceYears));
        System.assertEquals(cv.Zip_Postal_Code__c, resumeDto.zipCode);
    }
     @isTest static void test_getResumesAndJobAdsByResumeCreatedDate_Exc(){
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);

        //When
        Test.startTest();
        try{
            String json = new ResumeServiceImpl().getResumesAndJobAdsByResumeCreatedDate('\"2018-10-10\"');
            System.assert(false, 'expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf ResumeServiceImplException);
        }
        
        Test.stopTest();
    }
    
}
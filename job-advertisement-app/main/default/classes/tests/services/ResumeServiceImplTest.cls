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
}
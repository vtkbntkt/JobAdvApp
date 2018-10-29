@isTest
private class JobAdvertisementTriggerTest {
   
   @isTest private static void test_removeSentResumeBulk(){
         //Given
        Integer jobAdvNum = 200;
        Resume__c cv = TestDataFactory.getRandomResume(true);
        Map<Id, Job_Advertisement__c> oldJobAds = new Map<Id,Job_Advertisement__c>(TestDataFactory.prepareJobAdsList(jobAdvNum, true));
        List<SentResume__c> sentResumes = TestDataFactory.getSentResumesByJobAdsAndCV(oldJobAds.values(),cv,true);
        Map<Id,Job_Advertisement__c> newJobAds = new Map<Id,Job_Advertisement__c>([SELECT Status__c FROM Job_Advertisement__c]);
        for(Id jobAdvId:newJobAds.keySet()){
           newJobAds.get(jobAdvId).Status__c = 'Archive'; 
        }        
        System.assertEquals(jobAdvNum, [SELECT COUNT() FROM SentResume__c]);

        //When
        Test.startTest();
        update newJobAds.values();
        Test.stopTest();

        //Then
        System.assertEquals(0,[SELECT COUNT() FROM SentResume__c]);
   }

    @isTest private static void test_removeSentResumeBulk_NoRelevantJobAds(){
         //Given
        Integer jobAdvNum = 200;
        Resume__c cv = TestDataFactory.getRandomResume(true);
        Map<Id, Job_Advertisement__c> oldJobAds = new Map<Id,Job_Advertisement__c>(TestDataFactory.prepareJobAdsList(jobAdvNum, true));
        List<SentResume__c> sentResumes = TestDataFactory.getSentResumesByJobAdsAndCV(oldJobAds.values(),cv,true);
        Map<Id,Job_Advertisement__c> newJobAds = new Map<Id,Job_Advertisement__c>([SELECT Status__c FROM Job_Advertisement__c]);
        for(Id jobAdvId:newJobAds.keySet()){
           newJobAds.get(jobAdvId).Status__c = 'On hold'; 
        }        
        System.assertEquals(jobAdvNum, [SELECT COUNT() FROM SentResume__c]);

        //When
        Test.startTest();
        update newJobAds.values();
        Test.stopTest();

        //Then
        System.assertEquals(jobAdvNum,[SELECT COUNT() FROM SentResume__c]);
   }
}

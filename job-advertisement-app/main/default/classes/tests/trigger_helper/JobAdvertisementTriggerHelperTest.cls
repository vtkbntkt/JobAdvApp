@isTest
private class JobAdvertisementTriggerHelperTest {
    
    @isTest private static void test_manageSentResumesRemovalCorrectly() {
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);
        Map<Id, Job_Advertisement__c> oldJobAds = new Map<Id,Job_Advertisement__c>(TestDataFactory.prepareJobAdsList(5, true));
        List<SentResume__c> sentResumes = TestDataFactory.getSentResumesByJobAdsAndCV(oldJobAds.values(),cv,true);
        Map<Id,Job_Advertisement__c> newJobAds = new Map<Id,Job_Advertisement__c>([SELECT Status__c FROM Job_Advertisement__c]);
        Job_Advertisement__c jobAdvToCheck = newJobAds.values().get(0);
        System.assertEquals(1, [SELECT COUNT() FROM SentResume__c WHERE Job_Advertisement__c=:jobAdvToCheck.id]);
        jobAdvToCheck.Status__c = 'Archive';

        //When
        Test.startTest();
        JobAdvertisementTriggerHelper.manageSentResumesRemoval(oldJobAds, newJobAds);
        Test.stopTest();

        //Then
        System.assertEquals(0,[SELECT COUNT() FROM SentResume__c WHERE Job_Advertisement__c=:jobAdvToCheck.id]);
    }

    @isTest private static void test_manageSentResumesRemovalNoRelevantJobAds() {
        //Given
        Integer jobAdvNum = 5;
        Resume__c cv = TestDataFactory.getRandomResume(true);
        Map<Id, Job_Advertisement__c> oldJobAds = new Map<Id,Job_Advertisement__c>(TestDataFactory.prepareJobAdsList(jobAdvNum, true));
        List<SentResume__c> sentResumes = TestDataFactory.getSentResumesByJobAdsAndCV(oldJobAds.values(),cv,true);
        Map<Id,Job_Advertisement__c> newJobAds = new Map<Id,Job_Advertisement__c>([SELECT Status__c FROM Job_Advertisement__c]);
        Job_Advertisement__c jobAdvToCheck = newJobAds.values().get(0);
        System.assertEquals(1, [SELECT COUNT() FROM SentResume__c WHERE Job_Advertisement__c=:jobAdvToCheck.id]);
        jobAdvToCheck.Status__c = 'On hold';

        //When
        Test.startTest();
        JobAdvertisementTriggerHelper.manageSentResumesRemoval(oldJobAds, newJobAds);
        Test.stopTest();

        //Then
        System.assertEquals(jobAdvNum,[SELECT COUNT() FROM SentResume__c]);
        System.assertEquals(1,[SELECT COUNT() FROM SentResume__c WHERE Job_Advertisement__c=:jobAdvToCheck.id]);
    }
     @isTest private static void test_manageSentResumesRemovalBulk() {
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
        JobAdvertisementTriggerHelper.manageSentResumesRemoval(oldJobAds, newJobAds);
        Test.stopTest();

        //Then
        System.assertEquals(0,[SELECT COUNT() FROM SentResume__c]);
    }
}

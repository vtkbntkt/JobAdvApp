@isTest
private class UtilsTest {
    
    @isTest private static void test_resume2resumeDto(){
        //Given
        Blob photoContent = Blob.valueOf('test');
        String photoName = 'test.gif';
        Integer jobAdvNum = 3;
        Resume__c cv = TestDataFactory.getRandomResume(true);
        ContentVersion contentVersion = getContentVersion(photoName, photoContent,cv.id);
        List<Job_advertisement__c> jobAds = TestDataFactory.prepareJobAdsList(jobAdvNum,true);
        List<SentResume__c> sentCVs = TestDataFactory.getSentResumesByJobAdsAndCV(jobAds, cv, true);
        cv = getActualCV();

        //When
        Test.startTest();
        ResumeDTO resumeDto = Utils.resume2resumeDto(cv, contentVersion);
        Test.stopTest();

        //Then
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
        System.assertEquals(EncodingUtil.base64Encode(photoContent), resumeDto.photo);
        System.assertEquals(photoName, resumeDto.photoName);
        Set<String> jobAdvIds = new Set<String>(resumeDto.jobAdIds);
        System.assertEquals(jobAds.size(),jobAdvIds.size());

        Boolean testResult = true;
        for(Job_advertisement__c jobadv:jobAds){
            if(!jobAdvIds.contains(jobAdv.id)){
               testResult = false; 
            }
        }
        System.assert(testResult);
    }

    @isTest private static void test_resumes2resumesDTO(){
        //Given
        Blob photoContent = Blob.valueOf('test');
        String photoName = 'test.gif';
        Integer jobAdvNum = 3;
        Resume__c cv = TestDataFactory.getRandomResume(true);
        cv.Salary__c = null;
        ContentVersion contentVersion = getContentVersion(photoName, photoContent,cv.id);
        List<Job_advertisement__c> jobAds = TestDataFactory.prepareJobAdsList(jobAdvNum,true);
        List<SentResume__c> sentCVs = TestDataFactory.getSentResumesByJobAdsAndCV(jobAds, cv, true);
        cv = getActualCV();
        cv.PhotoFileId__c =contentVersion.id;

        //When
        Test.startTest();
        List<ResumeDTO> resumesDto = Utils.resumes2resumesDTO(new List<Resume__c>{cv}, new List<ContentVersion>{contentVersion});
        Test.stopTest();

        //Then
        System.assertEquals(1, resumesDto.size());
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
        System.assertEquals(EncodingUtil.base64Encode(photoContent), resumeDto.photo);
        System.assertEquals(photoName, resumeDto.photoName);
        Set<String> jobAdvIds = new Set<String>(resumeDto.jobAdIds);
        System.assertEquals(jobAds.size(),jobAdvIds.size());

        Boolean testResult = true;
        for(Job_advertisement__c jobadv:jobAds){
            if(!jobAdvIds.contains(jobAdv.id)){
               testResult = false; 
            }
        }
        System.assert(testResult);
    }

    private static Resume__c getActualCV(){
        return Database.query('SELECT (SELECT Job_Advertisement__r.id FROM SentResumes__r),'+
        'First_Name__c,Last_Name__c,Age__c,Phone__c,Email__c,Education__c,'+
        'Currently_Employed__c,Country__c,City__c,State_Province__c,Zip_Postal_Code__c,'+
        'Street_Address__c,Salary__c,Years_of_Experience__c,Additional_Info__c,PhotoFileId__c FROM Resume__c');
    }

    private static ContentVersion getContentVersion(String fileName, Blob fileContent, id relatedEntityId){
        ContentVersion contentVersion = TestDataFactory.getContentVersion(fileName, fileContent);
        insert contentVersion;
        Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id].ContentDocumentId;
        ContentDocumentLink contentDocLink = TestDataFactory.getContentDocLink(contentDocId, 'I', 'AllUsers', relatedEntityId);
        insert contentDocLink;
        return contentVersion;
    }
}

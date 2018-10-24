@isTest
private class BaseFileServiceTest {
    
    
    @IsTest static void test_saveFileAsBlobCorrectly(){
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);
        BaseFileService service = new BaseFileService();
        String fileName = 'photo';
        String fileContent = 'photo';
        String shareType = 'I';
        String visibility = 'AllUsers';
        Id relatedEntityId = cv.id;
        
        //When
        Test.startTest();
        String fileId = service.saveFile(fileName, Blob.valueOf(fileContent), shareType, visibility, relatedEntityId);
        Test.stopTest();
        
        //Then
        List<ContentVersion> contentVersions = [SELECT ContentDocumentId, Title FROM ContentVersion WHERE Title=:fileName];      
        System.assertEquals(1, contentVersions.size());
        System.assertEquals(fileName, contentVersions.get(0).title);
        
        List<ContentDocument> contentDocs = 
            [SELECT id, Title FROM ContentDocument WHERE id=:contentVersions.get(0).ContentDocumentId];       
        System.assertEquals(1, contentDocs.size());
        System.assertEquals(fileName, contentDocs.get(0).title);
        
        List<ContentDocumentLink> contentDocLinks = 
            [SELECT id FROM ContentDocumentLink WHERE ContentDocumentId=:contentDocs.get(0).id AND LinkedEntityId = :relatedEntityId];
        System.assertEquals(1, contentDocLinks.size());
        
        System.assertEquals(contentVersions.get(0).id, fileId);       
    }
    
    @IsTest static void test_saveFileAsBlob_SaveFileException(){
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);
        BaseFileService service = new BaseFileService();
        delete cv;
        
        //When
        Test.startTest();
        
        try{
            String fileId = service.saveFile('photo', Blob.valueOf('photo'), 'I', 'AllUsers', cv.id);
            System.assert(false,'Expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf SaveFileException);
        }
        Test.stopTest();          
    }
    
    @IsTest static void test_saveFileAsTextCorrectly(){
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);
        BaseFileService service = new BaseFileService();
        String fileName = 'photo';
        String fileContent = 'photo';
        String shareType = 'I';
        String visibility = 'AllUsers';
        Id relatedEntityId = cv.id;
        
        //When
        Test.startTest();
        String fileId = service.saveFile(fileName, fileContent, shareType, visibility, cv.id);
        Test.stopTest();
        
        //Then
        List<ContentVersion> contentVersions = [SELECT ContentDocumentId, Title FROM ContentVersion WHERE Title=:fileName];      
        System.assertEquals(1, contentVersions.size());
        System.assertEquals(fileName, contentVersions.get(0).title);
        
        List<ContentDocument> contentDocs = 
            [SELECT id, Title FROM ContentDocument WHERE id=:contentVersions.get(0).ContentDocumentId];       
        System.assertEquals(1, contentDocs.size());
        System.assertEquals(fileName, contentDocs.get(0).title);
        
        List<ContentDocumentLink> contentDocLinks = 
            [SELECT id FROM ContentDocumentLink WHERE ContentDocumentId=:contentDocs.get(0).id AND LinkedEntityId = :relatedEntityId];
        System.assertEquals(1, contentDocLinks.size());
        
        System.assertEquals(contentVersions.get(0).id, fileId);       
    }
    
    @IsTest static void test_saveFileAsText_SaveFileException(){
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);
        BaseFileService service = new BaseFileService();
        delete cv;
        
        //When
        Test.startTest();
        
        try{
            String fileId = service.saveFile('photo', 'photo', 'I', 'AllUsers', cv.id);
            System.assert(false,'Expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf SaveFileException);
        }
        Test.stopTest();          
    }
    
    @IsTest static void test_removeFileCorrectly(){
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);
        BaseFileService service = new BaseFileService();
        
        //When
        Test.startTest();
        String fileId = service.saveFile('photo', Blob.valueOf('photo'), 'I', 'AllUsers', cv.id);
        
        //Then
        System.assertNotEquals(null, fileId);
        
        //When
        service.removeFile(fileId);
        Test.stopTest();
        
        //Then
        List<ContentDocument> contentDocs = [SELECT id FROM ContentDocument];
        System.assert(contentDocs.isEmpty());
        
    }
    
    @IsTest static void test_removeFileClearFileExc(){
        //Given
        Resume__c cv = TestDataFactory.getRandomResume(true);
        BaseFileService service = new BaseFileService();
        
        //When
        Test.startTest();
        String fileId = service.saveFile('photo', Blob.valueOf('photo'), 'I', 'AllUsers', cv.id);
        
        //Then
        System.assertNotEquals(null, fileId);
        
        //When
        ContentDocument contentDoc = 
            [SELECT id FROM ContentDocument].get(0); 
        delete contentDoc;
        try{
            service.removeFile(fileId);
            System.assert(false,'Expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf ClearFileException);
            
        }
        Test.stopTest();
    }
    
    
    
    
    
    
    
}
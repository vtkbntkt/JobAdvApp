@isTest
private class CVcreationControllerTest {
    @isTest private static void test_applyCVCorrectly(){
     //Given
     FileServiceMock fileService = new FileServiceMock();
     fileService.testDataSet.put('file_id', '8825');
     ValidatorMock validator = new ValidatorMock();
     ResumeServiceMock resumeService = new ResumeServiceMock();
     new CVcreationController();
     CVcreationController controller = getController(validator,resumeService,fileService);

     //When
     Test.startTest();
     controller.applyCV();

     //Then
     System.assertEquals(1,Limits.getEmailInvocations());
     Test.stopTest();
     List<Apexpages.Message> msgs = ApexPages.getMessages();      
        boolean result = false;       
        for(Apexpages.Message msg:msgs){           
            if (msg.getDetail().contains(System.Label.Msg_success_cv_send)) result = true;          
        }      
        System.assert(result);
    }
    @isTest private static void test_applyCV_FormFillingErrors(){
     //Given
     FileServiceMock fileService = new FileServiceMock();
     ValidatorMock validator = new ValidatorMock();
     validator.errors.add(System.Label.Error_state_province);
     ResumeServiceMock resumeService = new ResumeServiceMock();
     CVcreationController controller = getController(validator,resumeService,fileService);
     
     //When
     Test.startTest();
     controller.applyCV();
     Test.stopTest();

     //Then
     List<Apexpages.Message> msgs = ApexPages.getMessages();      
        boolean result = false;       
        for(Apexpages.Message msg:msgs){           
            if (msg.getDetail().contains(System.Label.Error_state_province)) result = true;          
        }      
        System.assert(result);
    }

    
    @isTest private static void test_applyCV_NoSelectedAds(){
     //Given
     FileServiceMock fileService = new FileServiceMock();
     ValidatorMock validator = new ValidatorMock();
     ResumeServiceMock resumeService = new ResumeServiceMock();
     CVcreationController controller = getController(validator,resumeService,fileService);
     ControllerContext.getInstance().put(Constants.CONTEXT_SELECTED_JOB_ADV, new List<WrappedJobAdvertisement>());
     
     //When
     Test.startTest();
     controller.applyCV();
     Test.stopTest();

     //Then
     List<Apexpages.Message> msgs = ApexPages.getMessages();      
        boolean result = false;       
        for(Apexpages.Message msg:msgs){           
            if (msg.getDetail().contains(System.Label.Error_no_selected_ads)) result = true;          
        }      
        System.assert(result);
    }

    
    @isTest private static void test_applyCV_AlreadySentCvError(){
     //Given
     FileServiceMock fileService = new FileServiceMock();
     ValidatorMock validator = new ValidatorMock();
     ResumeServiceMock resumeService = new ResumeServiceMock();
     Job_Advertisement__c jobAdv = TestDataFactory.prepareJobAdsList(1,true).get(0);
     WrappedJobAdvertisement wrappedJobAdv = new WrappedJobAdvertisement(jobAdv);
     ControllerContext.getInstance().put(Constants.CONTEXT_SELECTED_JOB_ADV, new List<WrappedJobAdvertisement>{wrappedJobAdv});
     CVcreationController controller = new CVcreationController(validator,resumeService,fileService);
     controller.wrappedCV = getWrappedCv();
     SentResume__c sentResume = new SentResume__c(Job_Advertisement__c=jobAdv.id,Resume__c=controller.wrappedCV.cv.id);
     insert sentResume;

     //When
     Test.startTest();
     controller.applyCV();
     Test.stopTest();

     //Then
     List<Apexpages.Message> msgs = ApexPages.getMessages();      
        boolean result = false;       
        for(Apexpages.Message msg:msgs){           
            if (msg.getDetail().contains(System.Label.Error_already_sent_posns)){
                result = true; 
            }          
        }      
        System.assert(result);
    }

    
    @isTest private static void test_applyCV_ResumeserviceExc(){
     //Given
     FileServiceMock fileService = new FileServiceMock();
     ValidatorMock validator = new ValidatorMock();
     ResumeServiceMock resumeService = new ResumeServiceMock();
     resumeService.testDataSet.put('exc', new ResumeServiceImplException());
     CVcreationController controller = getController(validator,resumeService,fileService);
     
     //When
     Test.startTest();
     controller.applyCV();
     Test.stopTest();

     //Then
     List<Apexpages.Message> msgs = ApexPages.getMessages();      
        boolean result = false;       
        for(Apexpages.Message msg:msgs){           
            if (msg.getDetail().contains(System.Label.Exc_send_cv)) result = true;          
        }      
        System.assert(result);
    }

    @isTest private static void test_applyCV_ClearFileExc(){
     //Given
     FileServiceMock fileService = new FileServiceMock();
     fileService.testDataSet.put('clear_file_exc', new ClearFileException());
     ValidatorMock validator = new ValidatorMock();
     ResumeServiceMock resumeService = new ResumeServiceMock();
     CVcreationController controller = getController(validator,resumeService,fileService);
     Resume__c resume = controller.wrappedCV.cv;
     resume.PhotoFileId__c =resume.id;
     update resume;
     
     //When
     Test.startTest();
     controller.applyCV();
     Test.stopTest();

     //Then
     List<Apexpages.Message> msgs = ApexPages.getMessages();      
        boolean result = false;       
        for(Apexpages.Message msg:msgs){           
            if (msg.getDetail().contains(System.Label.Exc_save_photo)) result = true;          
        }      
        System.assert(result);
    }

     @isTest private static void test_applyCV_SaveFileExc(){
     //Given
     FileServiceMock fileService = new FileServiceMock();
     fileService.testDataSet.put('save_file_exc', new SaveFileException());
     ValidatorMock validator = new ValidatorMock();
     ResumeServiceMock resumeService = new ResumeServiceMock();
     CVcreationController controller = getController(validator,resumeService,fileService);
     
     
     //When
     Test.startTest();
     controller.applyCV();
     Test.stopTest();

     //Then
     List<Apexpages.Message> msgs = ApexPages.getMessages();      
        boolean result = false;       
        for(Apexpages.Message msg:msgs){           
            if (msg.getDetail().contains(System.Label.Exc_save_photo)) result = true;          
        }      
        System.assert(result);
    }


    private static CVcreationController getController(ValidatorMock validator, ResumeServiceMock cvService, FileServiceMock fileService){
     Job_Advertisement__c jobAdv = TestDataFactory.prepareJobAdsList(1,true).get(0);
     WrappedJobAdvertisement wrappedJobAdv = new WrappedJobAdvertisement(jobAdv);
     ControllerContext.getInstance().put(Constants.CONTEXT_SELECTED_JOB_ADV, new List<WrappedJobAdvertisement>{wrappedJobAdv});
     CVcreationController controller = new CVcreationController(validator,cvService,fileService);
     controller.wrappedCV = getWrappedCv();
     return controller;
    }

    private static WrappedCV getWrappedCv(){
        Resume__c resume = TestDataFactory.getRandomResume(true);
        WrappedCV wrappedCv = new WrappedCV();
        wrappedCv.cv = resume;
        return wrappedCv;
    }

    private class FileServiceMock implements IfileService{
        public Map<String, Object> testDataSet{get;set;}
        public FileServiceMock(){
           testDataSet = new Map<String,Object>(); 
        }

       public String saveFile(String fileName, String fileContent, String shareType, String visibility, id relatedEntityId){
           if(testDataSet.containsKey('save_file_exc')){
               throw (SaveFileException)testDataSet.get('save_file_exc');
           }
           return String.valueOf(testDataSet.get('file_id'));
         
       }

       public String saveFile(String fileName, Blob fileContent, String shareType, String visibility, id relatedEntityId){
         return null;
       }

       public void removeFile(Id contentVersionId){
       if(testDataSet.containsKey('clear_file_exc')){
               throw (ClearFileException)testDataSet.get('clear_file_exc');
           }
       }
    }

    private class ResumeServiceMock implements IresumeService{
        public Map<String,Object> testDataSet{get;set;}
        public ResumeServiceMock(){
            testDataSet = new Map<String,Object>();
        }
        
        public void addResumeWithJobAds(Resume__c cv, List<Job_Advertisement__c> jobAds){
            if(testDataSet.containsKey('exc')){
                throw (ResumeServiceImplException)testDataSet.get('exc');
            }
        }

        public void attachPhotoToResume(Resume__c cv, String fileId){
            if(testDataSet.containsKey('exc')){
                throw (ResumeServiceImplException)testDataSet.get('exc');
            }
        }

        public String getResumesAndJobAdsByResumeCreatedDate(String createdDate){
            return null;
        }
    }

    private class ValidatorMock implements Ivalidator{     
        public List<String> errors{get;set;}
        public ValidatorMock(){
            errors = new List<String>();
        }
        public List<String> validate(Object ob){
         return errors;
        }
    }
}

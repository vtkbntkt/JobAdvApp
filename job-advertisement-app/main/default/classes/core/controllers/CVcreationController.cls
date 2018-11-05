public class CVcreationController {
    public WrappedCV wrappedCV{get;set;}
    private Ivalidator validator;
    private IresumeService cvService; 
    private IfileService fileService;
    private ControllerContext context;
    
    public CVcreationController(){
        this(new WrappedCvValidator(), new ResumeServiceImpl(), new BaseFileService());
    }
    
    public CVcreationController(Ivalidator validator, IresumeService cvService, IfileService fileService){
        this.validator = validator;
        this.cvService = cvService;
        this.fileService = fileService;
        wrappedCV = new WrappedCV();
        context = ControllerContext.getInstance();
    }

   
    public PageReference applyCV(){  
        List<WrappedJobAdvertisement> selectedwrappedAds =
        (List<WrappedJobAdvertisement>) context.get(Constants.CONTEXT_SELECTED_JOB_ADV);
        List<String> errors = validator.validate(wrappedCV);
        if(errors.isEmpty()){          
            if(!selectedwrappedAds.isEmpty()){                
                Map<Id, Job_Advertisement__c> selectedAds = WrappedJobAdvUtils.extractJobAdsAsMap(selectedwrappedAds);
                List<SentResume__c> sentResumes = getSentResumes(selectedAds.keySet(), wrappedCV.cv.Email__c);                 
                if(sentResumes.isEmpty()){
                    Savepoint savePoint = Database.setSavepoint();
                    try{
                        cvService.addResumeWithJobAds(wrappedCV.cv,selectedAds.values());                        
                        cvService.attachPhotoToResume(wrappedCV.cv, savePhoto());
                        sendNotification(selectedAds.values(), wrappedCV.cv.Email__c);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, System.Label.Msg_success_cv_send));
                        wrappedCV.clearPhotoDetails();
                        PageReference pageRef = Page.JobAdvertisementSite;
                        pageRef.setRedirect(true);
                        return pageRef;
                       

                    }
                    catch(ResumeServiceImplException exc){
                        Database.rollback(savePoint);
                        addError(System.Label.Exc_send_cv);                                           
                    } 
                    catch(ClearFileException exc){
                        Database.rollback(savePoint);
                        addError(System.Label.Exc_save_photo);
                    }
                    catch(SaveFileException exc){
                        Database.rollback(savePoint);
                        addError(System.Label.Exc_save_photo);
                    }                    
                }
                else{
                    addErrors(System.Label.Error_already_sent_posns, sentResumes);
                }               
            }
            else{
                addError(System.Label.Error_no_selected_ads);
            }            
        }
        else{
            addErrors(errors);    
        }       
        wrappedCV.clearPhotoDetails();
        return null;
               
    }

    private void sendNotification(List<Job_Advertisement__c> jobAds, String mailAddress){
        String mailBody = Constants.EMAIL_SEND_CV_NOTIFICATION_BODY_HEADER;
        for(Job_Advertisement__c jobAdv:jobAds){          
            mailBody+=jobAdv.name+'\n';
        }
        EmailManager.EmailAddress addresses = new EmailManager.EmailAddress();
        addresses.to.add(mailAddress); 
        EmailManager.sendMail(addresses, Constants.EMAIL_SEND_CV_NOTIFICATION_SUBJECT, mailBody); 
    }

    private String savePhoto(){
        Resume__c resume = [SELECT PhotoFileId__c FROM Resume__c WHERE id = :wrappedCV.cv.id].get(0);
           if(!String.isBlank(resume.PhotoFileId__c)){
               fileService.removeFile(resume.PhotoFileId__c);
            }
            return fileService.saveFile(wrappedCV.photoName, wrappedCV.photoAsString, 'I', 'AllUsers', resume.id);
    }
       
    private List<SentResume__c> getSentResumes(Set<Id> selectedWrappedAdsIds, String cvEmail){
        return [SELECT Job_Advertisement__r.id, Job_Advertisement__r.name 
                FROM SentResume__c 
                WHERE Job_Advertisement__c IN :selectedWrappedAdsIds AND Resume__r.email__c = :cvEmail];
    }
    
    private void addError(String msg){
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg)); 
    }
    
    private void addErrors(List<String> msgs){
        for(String msg:msgs){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));  
        } 
    }
    
    private void addErrors(String title, List<SentResume__c> sentResumes){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,title));
                    for(SentResume__c sentCV:sentResumes){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,sentCV.Job_Advertisement__r.name));                       
                    } 
    } 
    
}
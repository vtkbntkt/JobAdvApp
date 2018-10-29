public class ResumeServiceImpl implements IresumeService {
     
    public void addResumeWithJobAds(Resume__c cv, List<Job_Advertisement__c> jobAds){
       Savepoint savePoint = Database.setSavepoint();
        try{
            
           upsert cv cv.email__c;
           insert prepareSentResumes(jobAds,cv);           
        }
        catch(DMLException exc){
            Database.rollback(savePoint);
            throw new ResumeServiceImplException(exc.getMessage(),exc);
        }
    }

    public String getResumesAndJobAdsByResumeCreatedDate(String createdDate){
     List<Resume__c> resumes = new List<Resume__c>();
     List<ContentVersion> contentVersions = new List<ContentVersion>();
     String resumeJson;
     try{
         resumes =  Database.query(QueryBuilder.getResumeQueryByCreatedDateParam(createdDate));
         if(!resumes.isEmpty()){
            contentVersions =  getResumePhotoDetails(resumes);
            List<ResumeDTO> resumesDto = Utils.resumes2resumesDTO(resumes, contentVersions);
            resumeJson =  JSON.serialize(resumesDto);
         }
     }
     catch(QueryException exc){
        throw new ResumeServiceImplException(exc);
     }
        return resumeJson;
    

    }

    public void attachPhotoToResume(Resume__c cv, String fileId){
        try{
            cv.PhotoFileId__c = fileId;
            update cv;
        }
        catch(DMLException exc){
            throw new ResumeServiceImplException(exc.getMessage(),exc);
        }
    }
    
    private List<SentResume__c> prepareSentResumes(List<Job_Advertisement__c> jobAds, Resume__c cv ){
       List<SentResume__c> sentResumes = new List<SentResume__c>();
        Id cvId = cv.id;
        for(Job_Advertisement__c jobAdv:jobAds){
            sentResumes.add(new SentResume__c(Job_Advertisement__c=jobAdv.id, Resume__c = cvId));
        }
        return sentResumes;
    }

    private List<ContentVersion> getResumePhotoDetails(List<Resume__c> resumes){
        List<Id> contentVersionIds = new List<String>();
        for(Resume__c resume:resumes){
            contentVersionIds.add(resume.PhotoFileId__c);
        }
        return [SELECT Title, versionData FROM ContentVersion WHERE id IN : contentVersionIds];
      
    }

    
    
    
   
    
    

}
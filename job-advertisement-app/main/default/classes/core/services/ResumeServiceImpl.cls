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

    

    public String getResumesAndJobAdsByResumeCreatedDate(String createdDate, Integer pageNumber, Integer pageSize){
     List<Resume__c> resumes = new List<Resume__c>();
     List<ContentVersion> contentVersions = new List<ContentVersion>();
     String resumeJson;
     try{
         //resumes =  Database.query(QueryBuilder.getResumeQueryByCreatedDateParam(createdDate));
         resumes =  extractResumesByPageNumber(QueryBuilder.getResumeQueryByCreatedDateParam(createdDate),pageNumber, pageSize);
         if(!resumes.isEmpty()){
            //resumes = extractResumesByPageNumber(resumes,pageNumber,pageSize);
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

    public String getResumesAndJobAdsNumberByResumeCreatedDate(String createdDate){
        return String.valueOf(Database.countQuery(QueryBuilder.getResumeNumberQueryByCreatedDateParam(createdDate)));
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

   /* private List<Resume__c> extractResumesByPageNumber(List<Resume__c> originList, Integer pageNumber, Integer pageSize){
        List<Resume__c> outputList = new List<Resume__c>();
        Integer startIndex = (pageNumber-1)*pageSize;
        Integer endIndex = originList.size()<pageSize*pageNumber?originList.size():startIndex+pageSize;
        for (Integer i=startIndex;i<endIndex;i++){
            outputList.add(originList.get(i));  
        }
        return outputList;
    }*/

    private List<Resume__c> extractResumesByPageNumber(String query, Integer pageNumber, Integer pageSize){
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        setController.setPageSize(pageSize);
        setController.setPageNumber(pageNumber);
        return setController.getRecords();
    }

}
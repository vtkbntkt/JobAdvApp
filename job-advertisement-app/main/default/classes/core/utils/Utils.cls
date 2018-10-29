public class Utils {
    
    public static String jobAdsList2JsonAsString(Map<String,Job_Advertisement__c> jobAds){       
        return JSON.serialize(jobAds);
    }
     
    public static Map<String,Job_Advertisement__c> blob2JobAdsWithIds(Blob body){
        Map<String,Job_Advertisement__c> jobAds = 
            (Map<String,Job_Advertisement__c>) JSON.deserialize(body.toString(), Map<String,Job_Advertisement__c>.class);
        return jobAds;
    }
    
    public static Map<String,Job_Advertisement__c> blob2JobAdsWithIds(String body){
        Map<String,Job_Advertisement__c> jobAds = 
            (Map<String,Job_Advertisement__c>) JSON.deserialize(body, Map<String,Job_Advertisement__c>.class);
        return jobAds;
    }

    public static List<ResumeDTO> resumes2resumesDTO(List<Resume__c> resumes, List<ContentVersion> contentVersions){
        Map<Id, ContentVersion> photoDetails = new Map<Id, ContentVersion>(contentVersions);
        List<ResumeDTO> resumesDto = new List<ResumeDTO>();
        for(Resume__c resume:resumes){
            resumesDto.add(resume2resumeDto(resume, photoDetails.get(resume.PhotoFileId__c)));
        }
        return resumesDto;

    }

    public static ResumeDTO resume2resumeDto(Resume__c resume, ContentVersion contentVersion){
       ResumeDTO resumeDto = new ResumeDTO();    
       resumeDto.firstName = resume.First_Name__c;
       resumeDto.lastName = resume.Last_Name__c;
       resumeDto.phone = resume.Phone__c;
       resumeDto.email = resume.Email__c;
       resumeDto.education = resume.Education__c;
       resumeDto.currentlyEmployed = resume.Currently_Employed__c;
       resumeDto.country = resume.Country__c;
       resumeDto.city = resume.City__c;
       resumeDto.state = resume.State_Province__c;
       resumeDto.zipCode = resume.Zip_Postal_Code__c;
       resumeDto.street = resume.Street_Address__c;
       resumeDto.additionalInformation = resume.Additional_Info__c; 
       resumeDto.salary = String.valueOf(resume.Salary__c);
       resumeDto.experienceYears = String.valueOf(resume.Years_of_Experience__c);
       resumeDto.age = String.valueOf(resume.Age__c);      
       if(contentVersion!=null){
           resumeDto.photo = EncodingUtil.base64Encode(contentVersion.versionData);
           resumeDto.photoName = contentVersion.title;
       }
        for (SentResume__c sentResume : resume.SentResumes__r){
            resumeDto.jobAdIds.add(sentResume.Job_Advertisement__r.id); 
        }
        return resumeDto;
    }
    
}
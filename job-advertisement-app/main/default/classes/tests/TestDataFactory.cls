@isTest
public class TestDataFactory {

    public static Resume__c getRandomResume(Boolean ifInsert){
    Resume__c cv = new Resume__c(
        Age__c = 18,
        City__c='Kh',
        Country__c='US',	
        Education__c='MD',	
        Email__c='test@gmail.com',
        First_Name__c = 'Alex',
        Last_Name__c = 'Gudkov',	
        Phone__c = '0502209449',		
        Salary__c = 2500,	
        State_Province__c = 'NY',
        Street_Address__c = 'Str #55',
        Years_of_Experience__c	= 25,
        Zip_Postal_Code__c = '886589');
        if(ifInsert){
            insert cv;
        }
        return cv;
    }

    public static List<SentResume__c> getSentResumesByJobAdsAndCV(List<Job_Advertisement__c> jobAds, Resume__c resume, Boolean isInsert){
        Id resumeId = resume.id;
        List<SentResume__c> resumes = new List<SentResume__c>();
        for(Job_Advertisement__c jobAdv:jobAds){
            resumes.add(new SentResume__c(Job_Advertisement__c = jobAdv.id, Resume__c = resumeId));
        }
        if(isInsert){
            insert resumes;
        }
        return resumes;

    }

    public static List<Job_advertisement__c> prepareJobAdsList(Integer num, Boolean ifInsert){
     List<Job_Advertisement__c> jobAds = new List<Job_Advertisement__c>();
        for(Integer i=0;i<num;i++){
         jobAds.add(new Job_Advertisement__c(name='Vacancy'));
        }
        if(ifInsert){
          insert jobAds;
        }
        return jobAds;
    }
    
    public static Boolean listsAreEqual(List<WrappedJobAdvertisement> ads, List<String> jobTitles){
        if(ads.size()!=jobTitles.size()){
            return false;
         }        
        Integer index = 0;
        List<String> titles = new List<String>(jobTitles);
        for (WrappedJobAdvertisement adv:ads){           
            String advTitle = adv.adv.name; 
            for(Integer i=0;i<titles.size();i++){
                if(advTitle==titles.get(i)){
                    titles.remove(i);
                    break;                  
                } 
            }         
        }
       return titles.size()==0; 
    }  


    public static ContentVersion getContentVersion(String fileName, Blob fileContent){
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.versionData = fileContent;
        contentVersion.title = fileName;
        contentVersion.pathOnClient =fileName;
        return contentVersion;       
    }


    public static ContentDocumentLink getContentDocLink(Id contentDocId, String shareType, String visibility, id linkedEntityId){
        ContentDocumentLink contentDocLink = new ContentDocumentLink();
        contentDocLink.ContentDocumentId = contentDocId;
        contentDocLink.LinkedEntityId = linkedEntityId;
        contentDocLink.ShareType = shareType; 
        contentDocLink.Visibility = visibility;
        return contentDocLink;
    }

    
    
    public class ExpandedStringList {
        private List<String> values;
        
        public ExpandedStringList(){
            values = new List<String>();
        }
        
        public ExpandedStringList(String value){
            values = new List<String>();
            values.add(value);
        }
        
        public ExpandedStringList add(String value){
            values.add(value);
            return this;
        }
        
        public List<String> getList(){
            return values;
        }
        
    }

    

}
public class WrappedJobAdvUtils {
     
    public static WrappedJobAdvertisement getJobAdvById(Id jobAdvId, List<WrappedJobAdvertisement> jobAdvList){
        for(WrappedJobAdvertisement jobAdv:jobAdvList){
            if(jobAdv.adv.id==jobAdvId){
                return jobAdv;
            }
        }
        return null;
    } 
    
    
    public static void changeSelectionStatusById(WrappedJobAdvertisement jobAdv, Boolean status, List<WrappedJobAdvertisement> jobAdvList){
        Id currentAdId = jobAdv.adv.id;
        for(WrappedJobAdvertisement jobAdvL:jobAdvList){
            if(jobAdvL.adv.id==currentAdId){
                jobAdvL.isSelected = status; 
            }
        }
    }
    
    public static void removeFromListById(WrappedJobAdvertisement jobAdv, List<WrappedJobAdvertisement> jobAdvList){
        Id currentAdId = jobAdv.adv.id;
        for(Integer i = 0; i<jobAdvList.size();i++){         
            if(jobAdvList.get(i).adv.id==currentAdId){
                jobAdvList.remove(i);  
            }
        }
    }
    
    
    public static void addUniqueById(WrappedJobAdvertisement jobAdv, List<WrappedJobAdvertisement> jobAdvList){        
        if(getJobAdvById(jobAdv.adv.id,jobAdvList)==null){
            jobAdvList.add(jobAdv);     
        }     
    }
    
    public static List<Job_Advertisement__c> extractJobAdsAsList(List<WrappedJobAdvertisement> wrappedJobAds){
       List<Job_Advertisement__c> jobAds = new List<Job_Advertisement__c>();
        for(WrappedJobAdvertisement wrappedJobAdv:wrappedJobAds){
            jobAds.add(wrappedJobAdv.adv);
        }
            
            return jobAds;
    }
    
    public static Map<Id,Job_Advertisement__c> extractJobAdsAsMap(List<WrappedJobAdvertisement> wrappedJobAds){
        return new Map<Id, Job_Advertisement__c>(extractJobAdsAsList(wrappedJobAds));
    }
    
    
}
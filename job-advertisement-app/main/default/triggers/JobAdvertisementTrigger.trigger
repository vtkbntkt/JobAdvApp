trigger JobAdvertisementTrigger on Job_Advertisement__c (after update) {

 if(Trigger.isBefore){
        
} 
    
else{
    if(Trigger.isAfter){
        if(Trigger.isInsert){
             System.debug('<JobAdvertisement trigger after insert>');          
        }
        if(Trigger.isUpdate){
            System.debug('<JobAdvertisement trigger after update start>');
            JobAdvertisementTriggerHelper.manageSentResumesRemoval(Trigger.oldMap, Trigger.newMap);
            System.debug('<JobAdvertisement trigger after update end>');
        }
        }
    }

}
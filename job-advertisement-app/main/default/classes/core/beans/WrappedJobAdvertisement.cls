public class WrappedJobAdvertisement {
    public Job_Advertisement__c adv{get;set;}
    public Boolean isSelected{get;set;}
     
    public WrappedJobAdvertisement (Job_Advertisement__c adv){
        isSelected = false;
        this.adv = adv;
    }
}
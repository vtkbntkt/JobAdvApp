public class TriggerUtils {

     public class RecordFilter{
        private Map<Id, sObject> oldMap;
        private Map<Id, sObject> newMap;
        private Map<String, Set<String>> fieldValues;
        private String fieldForCompearing;
        
        public RecordFilter (Map<Id, sObject> oldMap,Map<Id, sObject> newMap, Map<String, Set<String>> fieldValues, String fieldForCompearing){
            this.oldMap = oldMap;                         
            this.newMap = newMap;
            this.fieldValues = fieldValues;
            this.fieldForCompearing  = fieldForCompearing;
        }
        
        public List<sObject> getFilteredList(){
            List<sObject> filteredList = new List<sObject>();             
            for(Id recordId:newMap.keySet()){
                if(oldMap.get(recordId).get(fieldForCompearing)!= 
                   newMap.get(recordId).get(fieldForCompearing)&&
                   isValuesEqual(newMap.get(recordId))){                  
                       filteredList.add(newMap.get(recordId)); 
                   }                 
            }
            return  filteredList;
        }
        
        private Boolean isValuesEqual(sObject record){            
            for(String field:fieldValues.keySet()){
                if(!fieldValues.get(field).contains(String.valueOf(record.get(field)))){
                    return false;
                }                
            }           
            return true;
        }
    }
}

public class Filter {
    public Map<String,FilterItemInterface> filterItems{get;set;}
    
    public Filter(){
        filterItems = new Map<String,FilterItemInterface>(); 
    } 
    
    public void addFilterItem(String key, FilterItemInterface item){
        filterItems.put(key, item);
    }
    
    public void clearFilterItem(){
        for(String key:filterItems.keySet()){
            filterItems.get(key).clear();
        }
    }
    
    
    
    
    
}
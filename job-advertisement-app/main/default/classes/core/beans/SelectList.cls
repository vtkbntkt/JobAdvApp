public class SelectList implements FilterItemInterface {
    public List<String> values;
    public List<SelectOption> options{get;set;}
    
     
    public SelectList (Map<String,String> optionMap){
        values = new List<String>();
        options = new List<SelectOption>();
        initOptions(optionMap);
    }
    
    public SelectList (List<Schema.PicklistEntry> pickList){
        values = new List<String>();
        options = new List<SelectOption>();
        initOptions(pickList);
    }
    
    private void initOptions(Map<String,String> optionMap){
        for(String key:optionMap.keySet()){
            options.add(new SelectOption(key,optionMap.get(key)));
        }   
    }
    
    private void initOptions(List<Schema.PicklistEntry> pickList){
        for( Schema.PicklistEntry listItem : pickList){
            options.add(new SelectOption(listItem.getLabel(), listItem.getValue()));
        }       
    }
    
    public void setValues(List<String> values) {
        this.values = values;
    }
    
    public void setValues(String value) {
        values.clear();
        values.add(value);
    }
    
    public List<String> getValues() {
        return values;
    }
    
    public void clear(){
        values.clear();
    }
    
    
    
    
    
    
}
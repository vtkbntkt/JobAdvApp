public class InputField implements FilterItemInterface{
    public String value{get;set;}
    
     
    public List<String> getValues() {
        List<String> values = new List<String>();
        if(!String.isBlank(value)){
            values.add(value);
        }        
        return values;
    }
    
    public void clear(){
        value=null;
    }
    
    

}
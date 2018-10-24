public class ControllerContext { 
    private static ControllerContext instance = null;
    private Map<String,Object> container;
       
    private ControllerContext(){
        container = new Map<String,Object>();
    }
    
    public static ControllerContext getInstance(){
        if(instance == null) instance = new ControllerContext();
        return instance;
    }
    
    public void put(String key, Object value){
        container.put(key, value);
    }
    
    public Object get(String key){
        return container.get(key);
    }
    
}
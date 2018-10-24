public class WrappedCvValidator implements Ivalidator {   
    public static final Integer FILE_SIZE_LIMIT = 1048576;
    public static final Set<String> FILE_EXTENSIONS_ALLOWED = new Set<String>{'image/jpeg','image/gif','image/pjpeg','image/png'};
         
        public List<String> validate(Object wrappedCV){
            List<String> errors = new List<String>();
            WrappedCV cv = (WrappedCV) wrappedCV;
            
            if(String.isBlank(cv.photoAsString)){
                errors.add(System.Label.ImageNull);
            }
            try{
                if(Integer.valueOf(cv.photoSize)>FILE_SIZE_LIMIT){
                    errors.add(System.Label.ImageInvalidSize);                   
                }
            }
            catch(Exception exc){
                errors.add(System.Label.ImageInvalidSize);
            }
            if (!FILE_EXTENSIONS_ALLOWED.contains(cv.photoContentType)){
                errors.add(System.Label.ImageInvalidType);
            } 
            if(cv.cv.Age__c<18){
                errors.add(System.Label.Error_age_value);
            }
            if(String.isBlank(cv.cv.First_Name__c)){
                errors.add(System.Label.Error_first_name);
            }
            if(String.isBlank(cv.cv.Last_Name__c)){
                errors.add(System.Label.Error_last_name);
            }
            if(!isMatch(Constants.REGEX_PHONE,cv.cv.Phone__c)){
                errors.add(System.Label.Error_phone);
            }
            if(!isMatch(Constants.REGEX_EMAIL,cv.cv.Email__c)){
                errors.add(System.Label.Invalid_email);
            }
            if(cv.cv.Salary__c<=0){
                errors.add(System.Label.Error_salary_value);
            }            
            if(cv.cv.Years_of_Experience__c<0){
                errors.add(System.Label.Error_experience_years_value);
            }
            if(String.isBlank(cv.cv.Country__c)){
                errors.add(System.Label.Error_country_value);
            }
            if(String.isBlank(cv.cv.Zip_Postal_Code__c)){
                errors.add(System.Label.Error_postal_code);
            }
            if(String.isBlank(cv.cv.State_Province__c)){
                errors.add(System.Label.Error_state_province);
            }
            if(String.isBlank(cv.cv.City__c)){
                errors.add(System.Label.Error_city);
            }
            if(String.isBlank(cv.cv.Street_Address__c)){
                errors.add(System.Label.Error_street_address);
            }
            return errors;            
        }

        private Boolean isMatch(String regex, String value){
            Matcher matcher = Pattern.compile(regex).matcher(value);
            if(!matcher.matches()){
                return false;  
            } 

            return true;
        }
    
}
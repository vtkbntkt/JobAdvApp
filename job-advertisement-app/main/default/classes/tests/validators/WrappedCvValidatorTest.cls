@isTest
private class WrappedCvValidatorTest {
    @IsTest static void test_ValidateCorrectly(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assert(errors.isEmpty());
    }
    @IsTest static void test_Validate_InvalidFileContent(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.photoAsString = null;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.ImageNull,errors.get(0));
    }
     @IsTest static void test_Validate_InvalidFileSize(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.photoSize='1048577';

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.ImageInvalidSize,errors.get(0));
    }
     @IsTest static void test_Validate_InvalidFileSizeValueType(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.photoSize='weew';

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.ImageInvalidSize,errors.get(0));
    }
     @IsTest static void test_Validate_InvalidFileContentType(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.photoContentType = '.com';

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.ImageInvalidType,errors.get(0));
    }
    
     @IsTest static void test_Validate_InvalidAge(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.Age__c = 17;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_age_value,errors.get(0));
    }
      @IsTest static void test_Validate_InvalidFirstName(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.First_Name__c = null;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_first_name,errors.get(0));
    }
    @IsTest static void test_Validate_InvalidLastName(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.Last_Name__c = null;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_last_name,errors.get(0));
    }
    @IsTest static void test_Validate_InvalidPhone(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.Phone__c = '05022094498';

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_phone,errors.get(0));
    }
    @IsTest static void test_Validate_InvalidEmail(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.Email__c = 'test';

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Invalid_email,errors.get(0));
    }

      @IsTest static void test_Validate_InvalidSalary(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.Salary__c = 0;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_salary_value,errors.get(0));
    }
    @IsTest static void test_Validate_InvalidYearsOfExperience(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.Years_of_Experience__c = -1;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_experience_years_value,errors.get(0));
    }
    @IsTest static void test_Validate_InvalidCountry(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.Country__c = null;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_country_value,errors.get(0));
    }
     @IsTest static void test_Validate_InvalidZipCode(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.Zip_Postal_Code__c = null;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_postal_code,errors.get(0));
    }
       @IsTest static void test_Validate_InvalidState(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.State_Province__c = null;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_state_province,errors.get(0));
    }
      @IsTest static void test_Validate_InvalidCity(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.City__c = null;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_city,errors.get(0));
    }
     @IsTest static void test_Validate_InvalidStreet(){
        //Given     
        WrappedCvValidator validator = new WrappedCvValidator();
        WrappedCV wrappedCv = getWrappedCv();
        wrappedCv.cv.Street_Address__c = null;

        //When
        Test.startTest();
        List<String> errors = validator.validate(wrappedCv);
        Test.stopTest();

        //Then
        System.assertEquals(System.Label.Error_street_address,errors.get(0));
    }


    private static WrappedCV getWrappedCv(){
        Resume__c resume = TestDataFactory.getRandomResume(false);
        WrappedCV wrappedCv = new WrappedCV();
        wrappedCv.cv = resume;
        wrappedCv.photoAsString='test';
        wrappedCv.photoContentType='image/jpeg';
        wrappedCv.photoName='test';
        wrappedCv.photoSize  = '12';
        return wrappedCv;
    }
}

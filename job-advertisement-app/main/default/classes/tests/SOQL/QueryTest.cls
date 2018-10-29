@isTest
private class QueryTest {
    
    @isTest private static void test_append(){
        //Given
        String value = 'test';

        //When
        String result = new Query().append(value).getQueryAsString();

        //Then
        System.assert(value.equals(result));
    }

    @isTest private static void test_appendEqual(){
        //Given
        String field = 'test';
        String value = 'true';

        //When
        String result = new Query().appendEqual(field, value).getQueryAsString();

        //Then
        System.assertEquals('test=true', result);
    }
    @isTest private static void test_appendEqualWithQuotes(){
        //Given
        String field = 'test';
        String value = 'true';

        //When
        String result = new Query().appendEqualWithQuotes(field, value).getQueryAsString();

        //Then
        System.assertEquals('test=\'true\'', result);
    }
    @isTest private static void test_appendWithWildCardAnyFull(){
        //Given
        String field = 'test';
        String value = 'true';

        //When
        String result = new Query().appendWithWildCardAnyFull(field, value).getQueryAsString();

        //Then
        System.assertEquals('test LIKE \'%true%\'', result);
    }
    @isTest private static void test_appendINStatement(){
        //Given
        String field = 'test';
        String value = 'true';

        //When
        String result = new Query().appendINStatement(field, 
        new Query.ExpandedStringList(value).add(value).add(value).getList()).getQueryAsString();

        //Then
        System.assertEquals('test IN (\'true\',\'true\',\'true\')', result);
    }

     @isTest private static void test_appendSpace(){
        //Given
         String value = 'true';

        //When
        String result = new Query().append(value).appendSpace().getQueryAsString();

        //Then
        System.assertEquals(value+' ', result);
    }

    
     @isTest private static void test_appendComma(){
        //Given
        String value = 'true';

        //When
        String result = new Query().append(value).appendComma().getQueryAsString();

        //Then
        System.assertEquals(value+',', result);
    }
    @isTest private static void test_appendByPointerListCorrectly(){
        //Given
        String exp = 'It?s a ? ?';
       
        //When
        String result = new Query().appendByPointer(exp, 
        new Query.ExpandedStringList('\'').add('test').add('sentence').getList()).getQueryAsString();

        //Then
        System.assertEquals('It\'s a test sentence', result);
    }
     @isTest private static void test_appendByPointerListExc_NoValues(){
        //Given
        String exp = 'It?s a ? ?';
       
        //When
        try{
            String result = new Query().appendByPointer(exp, new List<String>()).getQueryAsString();
            System.assert(false, 'Expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf QueryCreationException);
        }
    }
     @isTest private static void test_appendByPointerListExc_NoPointers(){
        //Given
        String exp = 'Its a  ';
       
        //When
        try{
            String result = new Query().appendByPointer(exp, 
        new Query.ExpandedStringList('\'').add('test').add('sentence').getList()).getQueryAsString();
        System.assert(false, 'Expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf QueryCreationException);
        }
    }

     @isTest private static void test_appendByPointerCorrectly(){
        //Given
        String exp = 'a>? and b<?';
       
        //When
        String result = new Query().appendByPointer(exp, 'c').getQueryAsString();

        //Then
        System.assertEquals('a>c and b<c', result);
    }

    @isTest private static void test_appendByPointerExc_NoPointers(){
        //Given
        String exp = 'a> and b<';
       
        //When
        try{
            String result = new Query().appendByPointer(exp, 'c').getQueryAsString();
            System.assert(false,'Expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf QueryCreationException);
        }
    }

    @isTest private static void test_preventExtraWhereStatement(){
        //Given
        String exp = 'SELECT name FROM test WHERE id=003';
       
        //When
        String result = new Query().append(exp).append('WHERE').getQueryAsString();

        //Then
        System.assertEquals(exp, result);
    }


}

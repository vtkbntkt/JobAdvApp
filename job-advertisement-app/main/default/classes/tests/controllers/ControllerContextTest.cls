@isTest
private class ControllerContextTest {
    @isTest static void test_ControllerContext(){
        //Given
        String key = 'testData';
        Object value = '8856';
        ControllerContext.getInstance().put(key, value);

        //When
        Object ob = ControllerContext.getInstance().get(key);

        //Then
        System.assertEquals(value, ob);
    }
}

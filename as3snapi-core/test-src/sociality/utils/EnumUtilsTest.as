package as3snapi.utils {
import as3snapi.utils.EnumUtils;

public class EnumUtilsTest {

    [Test]
    public function testEnum():void {
        assertEquals("TestEnum.AAA", EnumUtils.getName(TestEnum, 1));
        assertEquals("TestEnum.BBB", EnumUtils.getName(TestEnum, 2));
        assertEquals("TestEnum.CCC", EnumUtils.getName(TestEnum, 3));
        assertEquals("TestEnum.DDD", EnumUtils.getName(TestEnum, "4"));
        assertEquals("TestEnum", EnumUtils.getShortClassName(TestEnum));
    }
}
}

internal class TestEnum {
    public static const AAA:int = 1;
    public static const BBB:Number = 2;
    public static const CCC:uint = 3;
    public static const DDD:String = "4";
}
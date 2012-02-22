package as3snapi.bus {

[Test]
public class MixinTest {

    [Test(expects="as3snapi.bus.UnsupportedFeatureError")]
    public function testDictMixinThrows():void {
        var mixin:IMutableBus = new BusImpl();
        mixin.addFeature(Number, "");
    }

    [Test]
    public function testDictMixin():void {
        baseMixinTest(new BusImpl());
        featureReferenceTest3(new BusImpl());
    }

    private function baseMixinTest(mixin:IMutableBus):void {
        // Blank mixin test
        assertFalse(mixin.hasFeature(IAAA));
        assertFalse(mixin.hasFeature(IBBB));
        assertNull(mixin.getFeature(IAAA));
        assertNull(mixin.getFeature(IBBB));
        assertEquals(0, mixin.getFeatures().length);
        assertEquals(0, mixin.getVersion());

        // Adding IAAA feature test
        var aDelegate:AAA = new AAA();
        mixin.addFeature(IAAA, aDelegate);
        assertTrue(mixin.hasFeature(IAAA));
        assertFalse(mixin.hasFeature(IBBB));
        assertEquals(aDelegate, mixin.getFeature(IAAA));
        assertNull(mixin.getFeature(IBBB));
        assertEquals(1, mixin.getFeatures().length);
        assertEquals(1, mixin.getVersion());

        // Adding IBBB feature test
        var bDelegate:BBB = new BBB();
        mixin.addFeature(IBBB, bDelegate);
        assertTrue(mixin.hasFeature(IAAA));
        assertTrue(mixin.hasFeature(IBBB));
        assertEquals(aDelegate, mixin.getFeature(IAAA));
        assertEquals(bDelegate, mixin.getFeature(IBBB));
        assertEquals(2, mixin.getVersion());

        // Check list of features
        var features:Array = mixin.getFeatures();
        assertEquals(2, features.length);
        assertEquals(IAAA, features[0]);
        assertEquals(IBBB, features[1]);

        // Disable IAAA feature test
        mixin.disable(IAAA);
        assertFalse(mixin.hasFeature(IAAA));
        assertTrue(mixin.hasFeature(IBBB));
        assertNull(mixin.getFeature(IAAA));
        assertEquals(bDelegate, mixin.getFeature(IBBB));
        assertEquals(3, mixin.getVersion());

        // Disable IBBB feature test
        mixin.disable(IBBB);
        assertFalse(mixin.hasFeature(IAAA));
        assertFalse(mixin.hasFeature(IBBB));
        assertNull(mixin.getFeature(IAAA));
        assertNull(mixin.getFeature(IBBB));
        assertEquals(0, mixin.getFeatures().length);
        assertEquals(4, mixin.getVersion());

        // Disable already disabled feature test
        mixin.disable(IBBB);
        assertFalse(mixin.hasFeature(IAAA));
        assertFalse(mixin.hasFeature(IBBB));
        assertNull(mixin.getFeature(IAAA));
        assertNull(mixin.getFeature(IBBB));
        assertEquals(0, mixin.getFeatures().length);
        assertEquals(4, mixin.getVersion());
    }


    private function featureReferenceTest3(mixin:IMutableBus):void {
        var aDelegate1:AAA = new AAA();
        var aDelegate2:AAA = new AAA();
        mixin.addFeature(IAAA, aDelegate1);
        mixin.addFeatureIfNotExist(IAAA, aDelegate2);
        assertEquals(mixin.getFeature(IAAA), aDelegate1);
    }

}
}

internal interface IAAA {
}

internal interface IBBB {
}

internal class AAA implements IAAA {
}

internal class BBB implements IBBB {
}


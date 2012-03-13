package as3snapi.utils.bus {

import flash.events.Event;

/**
 * События шины
 */
public class BusChangeEvent extends Event {

    public static const FEATURE_ADDED:String = "FEATURE_ADDED";
    public static const FEATURE_DISABLED:String = "FEATURE_DISABLED";

    public var bus:IMutableBus;
    public var featureClass:Class;
    public var delegate:Object;

    public function BusChangeEvent(type:String, bus:IMutableBus, featureClass:Class, delegate:Object = null) {
        super(type);

        this.bus = bus;
        this.featureClass = featureClass;
        this.delegate = delegate;
    }

    override public function clone():Event {
        return new BusChangeEvent(type, bus, featureClass, delegate);
    }
}
}

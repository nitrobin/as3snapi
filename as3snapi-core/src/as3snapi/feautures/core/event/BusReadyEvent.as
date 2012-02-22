package as3snapi.feautures.core.event {
import flash.events.Event;

public class BusReadyEvent extends Event {

    public static const BASIC_FEATURES_ADDED:String = "BASIC_FEATURES_ADDED";
    public static const SOCIAL_NETWORK_FEATURES_ADDED:String = "SOCIAL_NETWORK_FEATURES_ADDED";
    public static const FEATURES_READY:String = "FEATURES_READY";

    public function BusReadyEvent(type:String) {
        super(type);
    }

    override public function clone():Event {
        return new BusReadyEvent(type);
    }
}
}

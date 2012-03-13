package as3snapi.core {
import flash.events.Event;

/**
 * События различных стадий жизненного цикла шины
 * @see ConnectionFactory
 */
public class BusFactoryEvent extends Event {

    public static const BASIC_FEATURES_ADDED:String = "BASIC_FEATURES_ADDED";
    public static const SOCIAL_NETWORK_FEATURES_ADDED:String = "SOCIAL_NETWORK_FEATURES_ADDED";
    public static const FEATURES_READY:String = "FEATURES_READY";

    public function BusFactoryEvent(type:String) {
        super(type);
    }

    override public function clone():Event {
        return new BusFactoryEvent(type);
    }
}
}

package as3snapi.networks.vkcom.features {
import flash.events.Event;

/**
 * Событие API vk.com
 */
public class EventVkcom extends Event {
    public static const ON_WINDOW_FOCUS:String = "onWindowFocus";
    public static const ON_BALANCE_CHANGED:String = "onBalanceChanged";
    public static const ON_WINDOW_BLUR:String = "onWindowBlur";
    //TODO http://vk.com/developers.php?oid=-1&p=IFrame-%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D1%8F

    public var data:Object;

    public function EventVkcom(event:String, data:Object) {
        super(event);
        this.data = data;
    }
}
}

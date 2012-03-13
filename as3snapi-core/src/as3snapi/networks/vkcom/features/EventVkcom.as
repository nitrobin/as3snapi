package as3snapi.networks.vkcom.features {
import flash.events.Event;

/**
 * Событие API vk.com
 */
public class EventVkcom extends Event {
    public var data:Object;

    public function EventVkcom(event:String, data:Object) {
        super(event);
        this.data = data;
    }
}
}

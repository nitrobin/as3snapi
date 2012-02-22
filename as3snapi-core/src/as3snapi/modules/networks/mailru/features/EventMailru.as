package as3snapi.modules.networks.mailru.features {
import flash.events.Event;

/**
 * Событие API mail.ru
 */
public class EventMailru extends Event {
    public var data:Object;

    public function EventMailru(name:String, data:Object) {
        super(name);
        this.data = data;
    }
}
}

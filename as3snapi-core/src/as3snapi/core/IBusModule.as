package as3snapi.core {
import as3snapi.bus.IMutableBus;

public interface IBusModule {

    function install(bus:IMutableBus):void;

}
}

package as3snapi.modules.bus {
import as3snapi.bus.IMutableBus;
import as3snapi.core.IBusModule;
import as3snapi.feautures.core.log.*;

public class BusModuleLogHook implements IBusModule {
    private var logHook:Function;
    private var apiLogHook:Function;
    private var eventLogHook:Function;

    public function BusModuleLogHook(logHook:Function, apiLogHook:Function, eventLogHook:Function) {
        this.logHook = logHook;
        this.apiLogHook = apiLogHook;
        this.eventLogHook = eventLogHook;
    }

    public function install(bus:IMutableBus):void {
        bus.addFeature(IFeatureLog, new FeatureLogHook(logHook, apiLogHook, eventLogHook));
    }

}
}

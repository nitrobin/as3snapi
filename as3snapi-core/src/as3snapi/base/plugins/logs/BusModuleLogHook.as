package as3snapi.base.plugins.logs {
import as3snapi.base.features.log.*;
import as3snapi.base.plugins.IBusModule;
import as3snapi.utils.bus.IMutableBus;

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

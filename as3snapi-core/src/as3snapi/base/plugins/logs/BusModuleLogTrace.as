package as3snapi.base.plugins.logs {
import as3snapi.base.features.log.FeatureLogTrace;
import as3snapi.base.features.log.IFeatureLog;
import as3snapi.base.plugins.IBusModule;
import as3snapi.utils.bus.IMutableBus;

public class BusModuleLogTrace implements IBusModule {
    public function BusModuleLogTrace() {
    }

    public function install(bus:IMutableBus):void {
        bus.addFeature(IFeatureLog, new FeatureLogTrace())
    }


}
}

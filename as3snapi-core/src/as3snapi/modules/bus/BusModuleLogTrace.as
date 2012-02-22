package as3snapi.modules.bus {
import as3snapi.bus.IMutableBus;
import as3snapi.core.IBusModule;
import as3snapi.feautures.core.log.FeatureLogTrace;
import as3snapi.feautures.core.log.IFeatureLog;

public class BusModuleLogTrace implements IBusModule {
    public function BusModuleLogTrace() {
    }

    public function install(bus:IMutableBus):void {
        bus.addFeature(IFeatureLog, new FeatureLogTrace())
    }


}
}

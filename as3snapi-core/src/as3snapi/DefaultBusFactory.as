/**
 * @author nitrobin
 */
package as3snapi {
import as3snapi.base.plugins.IBusModule;
import as3snapi.utils.bus.BusImpl;
import as3snapi.utils.bus.IMutableBus;

public class DefaultBusFactory implements IBusFactory {
    private var busModules:Vector.<IBusModule> = new <IBusModule>[];

    public function DefaultBusFactory(busModules:Vector.<IBusModule> = null) {
        if (busModules != null) {
            for each(var busModule:IBusModule in busModules) {
                this.busModules.push(busModule);
            }
        }
    }

    public function createBus():IMutableBus {
        var bus:IMutableBus = new BusImpl();
        var busModue:IBusModule;
        for each (busModue in busModules) {
            busModue.install(bus);
        }
        return bus;
    }
}
}

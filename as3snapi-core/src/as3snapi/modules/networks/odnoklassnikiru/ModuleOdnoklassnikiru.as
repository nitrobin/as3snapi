package as3snapi.modules.networks.odnoklassnikiru {
import as3snapi.bus.IMutableBus;
import as3snapi.core.INetworkModule;
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.FeaturesHelper;
import as3snapi.feautures.basic.init.IFeatureAsyncInit;
import as3snapi.feautures.core.flashvars.FlashVars;
import as3snapi.modules.networks.odnoklassnikiru.features.IFeatureOdnoklassnikiApi;
import as3snapi.modules.networks.odnoklassnikiru.impl.OdnoklassnikiruApiImpl;
import as3snapi.modules.networks.odnoklassnikiru.impl.OdnoklassnikiruState;

/**
 * {@link:http://dev.odnoklassniki.ru/wiki/display/ok/API+Documentation}
 * {@link:http://dev.odnoklassniki.ru/wiki/display/ok/Odnoklassniki+ActionScript+API}
 */
public class ModuleOdnoklassnikiru implements INetworkModule {
    public function ModuleOdnoklassnikiru() {
    }

    public function isAvailable(context:INetworkModuleContext):Boolean {
        var config:ConfigOdnoklassnikiru = context.getConfig() as ConfigOdnoklassnikiru
        if (config == null) {
            return false;
        }

        var flashVars:FlashVars = context.getFlashVars();
        var apiServer:String = flashVars.getString('api_server');
        if (apiServer != null && apiServer.match(/(odnoklassniki\.ru)/)) {
            return true;
        }

        return false;
    }

    public function install(context:INetworkModuleContext):void {
        var bus:IMutableBus = context.getBus();
        var state:OdnoklassnikiruState = new OdnoklassnikiruState(context);

        var apiCore:OdnoklassnikiruApiImpl = new OdnoklassnikiruApiImpl(state, context);
        FeaturesHelper.installBasicFeatures(bus, apiCore);
        bus.addFeature(IFeatureOdnoklassnikiApi, apiCore);
        bus.addFeature(IFeatureAsyncInit, apiCore);
    }
}
}

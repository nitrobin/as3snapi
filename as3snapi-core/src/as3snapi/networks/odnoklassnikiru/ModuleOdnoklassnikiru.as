package as3snapi.networks.odnoklassnikiru {
import as3snapi.api.feautures.social.SocialFeaturesInstallHelper;
import as3snapi.base.INetworkModule;
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.asyncinit.IFeatureAsyncInit;
import as3snapi.base.features.flashvars.FlashVars;
import as3snapi.networks.odnoklassnikiru.features.IFeatureOdnoklassnikiApi;
import as3snapi.networks.odnoklassnikiru.impl.OdnoklassnikiruApiImpl;
import as3snapi.networks.odnoklassnikiru.impl.OdnoklassnikiruState;
import as3snapi.utils.bus.IMutableBus;

/**
 * {@link:http://dev.odnoklassniki.ru/wiki/display/ok/API+Documentation}
 * {@link:http://dev.odnoklassniki.ru/wiki/display/ok/Odnoklassniki+ActionScript+API}
 */
public class ModuleOdnoklassnikiru implements INetworkModule {
    public static const SHORT_NETWORK_ID:String = "ok";

    private var shortNetworkId:String;

    public function ModuleOdnoklassnikiru(shortNetworkId:String = null) {
        this.shortNetworkId = shortNetworkId || SHORT_NETWORK_ID;
    }

    public function isAvailable(context:INetworkModuleContext):Boolean {
        var config:ConfigOdnoklassnikiru = context.getConfig() as ConfigOdnoklassnikiru
        if (config == null) {
            return false;
        }
        if (!config.getSecretKey()) {
            context.log("WARNING Odnoklassniki.ru Config : empty secretKey");
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

        var apiCore:OdnoklassnikiruApiImpl = new OdnoklassnikiruApiImpl(state, context, shortNetworkId);
        SocialFeaturesInstallHelper.installBasicFeatures(bus, apiCore);
        bus.addFeature(IFeatureOdnoklassnikiApi, apiCore);
        bus.addFeature(IFeatureAsyncInit, apiCore);
    }
}
}

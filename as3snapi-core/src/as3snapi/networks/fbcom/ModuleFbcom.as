package as3snapi.networks.fbcom {
import as3snapi.api.feautures.social.SocialFeaturesInstallHelper;
import as3snapi.base.INetworkModule;
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.javascript.IFeatureJavaScript;
import as3snapi.networks.fbcom.features.IFeatureFbcomApiCore;
import as3snapi.networks.fbcom.impl.FbcomApiImpl;
import as3snapi.networks.fbcom.impl.FbcomState;
import as3snapi.networks.vkcom.ConfigVkcom;
import as3snapi.utils.bus.IMutableBus;

public class ModuleFbcom implements INetworkModule {
    public static const SHORT_NETWORK_ID:String = "fb";

    private var shortNetworkId:String;

    public function ModuleFbcom(shortNetworkId:String = null) {
        this.shortNetworkId = shortNetworkId || SHORT_NETWORK_ID;
    }

    public function isAvailable(context:INetworkModuleContext):Boolean {
        var config:ConfigVkcom = context.getConfig() as ConfigVkcom
        if (config == null) {
            return false;
        }
        try {
            var js:IFeatureJavaScript = context.getJavaScript();
            if (js.isAvailable() && js.call("function(){return !!FB}")) {
                return true;
            }
        } catch (e:Error) {
            return false;
        }
        return false;
    }

    public function install(context:INetworkModuleContext):void {
        var bus:IMutableBus = context.getBus();
        var state:FbcomState = new FbcomState(context);

        var js:IFeatureJavaScript = context.getJavaScript();
        if (js.isAvailable()) {
            context.log("Using JavaScript driver");
        } else {
            throw new Error();
        }

        var apiCore:FbcomApiImpl = new FbcomApiImpl(state, context, shortNetworkId);
        bus.addFeature(IFeatureFbcomApiCore, apiCore);
        SocialFeaturesInstallHelper.installBasicFeatures(bus, apiCore);
        //TODO:bus.addFeature(IFeatureAsyncInit, apiCore);
    }
}
}

package as3snapi.modules.networks.mailru {
import as3snapi.bus.IMutableBus;
import as3snapi.core.INetworkModule;
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.FeaturesHelper;
import as3snapi.feautures.basic.init.IFeatureAsyncInit;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.modules.networks.mailru.features.IFeatureMailruApiCore;
import as3snapi.modules.networks.mailru.impl.MailruApiImpl;
import as3snapi.modules.networks.mailru.impl.MailruState;

/**
 * Модуль поддержки API mail.ru
 */
public class NetworkModuleMailru implements INetworkModule {
    public function NetworkModuleMailru() {
    }

    public function isAvailable(context:INetworkModuleContext):Boolean {
        var config:ConfigMailru = context.getConfig() as ConfigMailru
        if (config == null) {
            return false;
        }
        var js:IFeatureJavaScript = context.getJavaScript();
        if (js.isAvailable() && js.call("function(){return !!mailru}")) {
            return true;
        }
        return false;
    }

    public function install(context:INetworkModuleContext):void {
        var bus:IMutableBus = context.getBus();
        var state:MailruState = new MailruState(context);

        var js:IFeatureJavaScript = context.getJavaScript();
        if (js.isAvailable()) {
            context.log("Using JavaScript driver");
        } else {
            throw new Error();
        }

        var apiCore:MailruApiImpl = new MailruApiImpl(state);
        bus.addFeature(IFeatureMailruApiCore, apiCore);
        FeaturesHelper.installBasicFeatures(bus, apiCore);
        bus.addFeature(IFeatureAsyncInit, apiCore);
    }
}
}

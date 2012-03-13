package as3snapi.networks.mailru {
import as3snapi.api.feautures.social.SocialFeaturesInstallHelper;
import as3snapi.base.INetworkModule;
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.asyncinit.IFeatureAsyncInit;
import as3snapi.base.features.javascript.IFeatureJavaScript;
import as3snapi.networks.mailru.features.IFeatureMailruApiCore;
import as3snapi.networks.mailru.impl.MailruApiImpl;
import as3snapi.networks.mailru.impl.MailruState;
import as3snapi.utils.bus.IMutableBus;

/**
 * Модуль поддержки API mail.ru
 * {@link:http://api.mail.ru/docs/}
 */
public class ModuleMailru implements INetworkModule {
    public static const SHORT_NETWORK_ID:String = "mm";

    private var shortNetworkId:String;

    public function ModuleMailru(shortNetworkId:String = null) {
        this.shortNetworkId = shortNetworkId || SHORT_NETWORK_ID;
    }

    public function isAvailable(context:INetworkModuleContext):Boolean {
        var config:ConfigMailru = context.getConfig() as ConfigMailru
        if (config == null) {
            return false;
        }
        try {
            var js:IFeatureJavaScript = context.getJavaScript();
            if (js.isAvailable() && js.call("function(){return !!mailru}")) {
                return true;
            }
        } catch (e:Error) {
            return false;
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

        var apiCore:MailruApiImpl = new MailruApiImpl(state, context, shortNetworkId);
        bus.addFeature(IFeatureMailruApiCore, apiCore);
        SocialFeaturesInstallHelper.installBasicFeatures(bus, apiCore);
        bus.addFeature(IFeatureAsyncInit, apiCore);
    }
}
}

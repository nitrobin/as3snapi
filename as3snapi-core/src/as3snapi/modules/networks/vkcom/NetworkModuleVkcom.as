package as3snapi.modules.networks.vkcom {
import as3snapi.bus.IMutableBus;
import as3snapi.core.INetworkModule;
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.FeaturesHelper;
import as3snapi.feautures.core.flashvars.FlashVars;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomApiCore;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomApiUi;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomMethods;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomRequester;
import as3snapi.modules.networks.vkcom.impl.VkcomApiCore;
import as3snapi.modules.networks.vkcom.impl.VkcomApiUi;
import as3snapi.modules.networks.vkcom.impl.VkcomMethodsJs;
import as3snapi.modules.networks.vkcom.impl.VkcomRequesterJs;
import as3snapi.modules.networks.vkcom.impl.VkcomState;

/**
 * Модуль поддержки API vk.com
 */
public class NetworkModuleVkcom implements INetworkModule {
    public function NetworkModuleVkcom() {
    }

    public function isAvailable(context:INetworkModuleContext):Boolean {
        var flashVars:FlashVars = context.getFlashVars();
        var apiUrl:String = flashVars.getString('api_url');
        if (apiUrl == null || !apiUrl.match(/(vkontakte\.ru)|(vk\.com)/)) {
            return false;
        }
        return context.getConfig() is ConfigVkcom;
    }

    public function install(context:INetworkModuleContext):void {
        var bus:IMutableBus = context.getBus();
        var state:VkcomState = new VkcomState(context);

        var js:IFeatureJavaScript = context.getJavaScript();
        if (js.isAvailable()) {
            context.log("Using JavaScript driver");
            bus.addFeature(IFeatureVkcomRequester, new VkcomRequesterJs(state));
            bus.addFeature(IFeatureVkcomMethods, new VkcomMethodsJs(state));
        } else {
            throw new Error();
//            context.log("Using HTTP-REST driver");
//            bus.addFeature(IFeatureVkRequester, new VkRequesterRest(state));
        }

        if (bus.hasFeature(IFeatureVkcomMethods)) {
            var apiUi:VkcomApiUi = new VkcomApiUi(state);
            bus.addFeature(IFeatureVkcomApiUi, apiUi);
            FeaturesHelper.installBasicFeatures(bus, apiUi);
        }

        var apiCore:VkcomApiCore = new VkcomApiCore(state);
        bus.addFeature(IFeatureVkcomApiCore, apiCore);
        FeaturesHelper.installBasicFeatures(bus, apiCore);
    }
}
}

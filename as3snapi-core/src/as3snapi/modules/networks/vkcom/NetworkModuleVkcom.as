package as3snapi.modules.networks.vkcom {
import as3snapi.bus.IMutableBus;
import as3snapi.core.INetworkModule;
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.FeaturesHelper;
import as3snapi.feautures.basic.init.IFeatureAsyncInit;
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
import as3snapi.modules.networks.vkcom.impl.VkcomRequesterRest;
import as3snapi.modules.networks.vkcom.impl.VkcomState;

import flash.utils.getTimer;

/**
 * Модуль поддержки API vk.com
 */
public class NetworkModuleVkcom implements INetworkModule {
    public function NetworkModuleVkcom() {
    }

    public function isAvailable(context:INetworkModuleContext):Boolean {
        if (context.getConfig() is ConfigVkcom) {
            var flashVars:FlashVars = context.getFlashVars();
            var apiUrl:String = flashVars.getString('api_url');
            if (apiUrl == null || !apiUrl.match(/(vkontakte\.ru)|(vk\.com)/)) {
                return false;
            }
            return true;
        }
        return false;
    }

    public function install(context:INetworkModuleContext):void {
        var bus:IMutableBus = context.getBus();
        var state:VkcomState = new VkcomState(context);

        var js:IFeatureJavaScript = context.getJavaScript();
//        if (js.isAvailable()) {
        if (jsCallbacksAvailable(js)) {
            context.log("Using JavaScript driver");
            bus.addFeature(IFeatureVkcomRequester, new VkcomRequesterJs(state, context));
            bus.addFeature(IFeatureVkcomMethods, new VkcomMethodsJs(state, context));
            bus.addFeature(IFeatureAsyncInit, new VkcomJsAsyncInit(context));
        } else {
            context.log("Using HTTP-REST driver");
            bus.addFeature(IFeatureVkcomRequester, new VkcomRequesterRest(state, context));
            // TODO: IFeatureVkcomMethods в режиме "без контейнера"
        }

        if (bus.hasFeature(IFeatureVkcomMethods)) {
            var apiUi:VkcomApiUi = new VkcomApiUi(state, context);
            bus.addFeature(IFeatureVkcomApiUi, apiUi);
            FeaturesHelper.installBasicFeatures(bus, apiUi);
        }

        var apiCore:VkcomApiCore = new VkcomApiCore(state, context);
        bus.addFeature(IFeatureVkcomApiCore, apiCore);
        FeaturesHelper.installBasicFeatures(bus, apiCore);
    }

    private function jsCallbacksAvailable(js:IFeatureJavaScript):Boolean {
        if (js.isAvailable()) {
            try {
                var fn:String = "testVkCallback" + getTimer();
                js.addCallback(fn, function (...rest):void {
                });
                js.addCallback(fn, null);
                return true;
            } catch (e:Error) {
                return false;
            }
        }
        return false;
    }
}
}

import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.basic.init.IAsyncInitHandler;
import as3snapi.feautures.basic.init.IFeatureAsyncInit;
import as3snapi.feautures.core.javascript.JavaScriptUtils;

/**
 * Инициалозация JS API
 */
internal class VkcomJsAsyncInit implements IFeatureAsyncInit {
    private var jsUtils:JavaScriptUtils;

    public function VkcomJsAsyncInit(context:INetworkModuleContext) {
        this.jsUtils = context.getJavaScriptUtils();
    }

    public function init(handler:IAsyncInitHandler):void {
        jsUtils.callSmart("VK.init", function (...rest):void {
            handler.onSuccess("ok");
        });
    }
}

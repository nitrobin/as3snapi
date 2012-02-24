package as3snapi.modules.networks.vkcom.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.feautures.core.javascript.JavaScriptUtils;
import as3snapi.modules.networks.vkcom.features.*;

import flash.events.IEventDispatcher;

/**
 * JS драйвер дря работы с VK API.
 */
public class VkcomMethodsJs implements IFeatureVkcomMethods {
    private var context:INetworkModuleContext;
    private var js:IFeatureJavaScript;
    private var jsUtils:JavaScriptUtils;
    private var dispatcher:IEventDispatcher;

    public function VkcomMethodsJs(state:VkcomState, context:INetworkModuleContext) {
        this.context = context;
        this.js = context.getJavaScript();
        this.jsUtils = context.getJavaScriptUtils();
        this.dispatcher = context.getEventDispatcher()
        registerEvents();
    }

    private function registerEvents():void {
        event("onApplicationAdded");
        event("onSettingsChanged");
        event("onBalanceChanged");
        event("onMerchantPaymentCancel");
        event("onMerchantPaymentSuccess");
        event("onMerchantPaymentFail");
        event("onProfilePhotoSave");
        event("onWallPostSave");
        event("onWallPostCancel");
        event("onWindowResized");
        event("onLocationChanged");
        event("onWindowBlur");
        event("onWindowFocus");
        event("onScrollTop");
        event("onScroll");
        event("onToggleFlash");

        function event(event:String):void {
            jsUtils.callSmart("VK.addCallback", event, jsUtils.permanent(eventProxy));
            function eventProxy(...rest):void {
                var params:Object = rest ? rest[0] : null;
                context.eventLog({event:event, params:params});
                dispatcher.dispatchEvent(new EventVkcom(event, params));
            }
        }
    }

    public function callMethod(method:String, ...rest):void {
        var a:Array = ["VK.callMethod", method].concat(rest);
        js.call.apply(null, a);
    }
}
}

package as3snapi.modules.networks.vkcom.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.feautures.core.javascript.JavaScriptUtils;
import as3snapi.modules.networks.vkcom.features.*;

import flash.events.IEventDispatcher;

public class VkcomMethodsJs implements IFeatureVkcomMethods {
    private var context:INetworkModuleContext;
    private var js:IFeatureJavaScript;
    private var jsUtils:JavaScriptUtils;
    private var dispatcher:IEventDispatcher;

    public function VkcomMethodsJs(state:VkcomState) {
        this.context = state.context;
        this.js = state.context.getJavaScript();
        this.jsUtils = new JavaScriptUtils(js);
        this.dispatcher = state.context.getEventDispatcher();
        reg();
    }

    private function reg():void {

        function regEvent(event:String):void {
            var script:String = "function(event){VK.addCallback(event,{callback})}"
                    .replace("{callback}", jsUtils.createClosure(eventProxy));

            function eventProxy(...rest):void {
                eventHandler(event, rest)
            }

            js.call(script, event);
        }

        regEvent("onApplicationAdded");
        regEvent("onSettingsChanged");
        regEvent("onBalanceChanged");
        regEvent("onMerchantPaymentCancel");
        regEvent("onMerchantPaymentSuccess");
        regEvent("onMerchantPaymentFail");
        regEvent("onProfilePhotoSave");
        regEvent("onWallPostSave");
        regEvent("onWallPostCancel");
        regEvent("onWindowResized");
        regEvent("onLocationChanged");
        regEvent("onWindowBlur");
        regEvent("onWindowFocus");
        regEvent("onScrollTop");
        regEvent("onScroll");
        regEvent("onToggleFlash");
    }

    public function eventHandler(event:String, rest:Array):void {
        var params:Object = rest ? rest[0] : null;
        context.eventLog({event:event, params:params});
        dispatcher.dispatchEvent(new EventVkcom(event, params));
    }

    public function callMethod(method:String, ...rest):void {
        var a:Array = ["VK.callMethod", method].concat(rest);
        js.call.apply(null, a);
    }
}
}

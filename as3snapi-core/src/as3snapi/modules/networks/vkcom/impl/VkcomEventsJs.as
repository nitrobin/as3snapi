package as3snapi.modules.networks.vkcom.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.feautures.core.javascript.JavaScriptUtils;
import as3snapi.modules.networks.vkcom.features.*;

import flash.events.IEventDispatcher;

public class VkcomEventsJs {
    private var context:INetworkModuleContext;
    private var js:IFeatureJavaScript;
    private var jsUtils:JavaScriptUtils;
    private var dispatcher:IEventDispatcher;

    public function VkcomEventsJs(state:VkcomState) {
        this.context = state.context;
        this.js = state.context.getJavaScript();
        this.jsUtils = new JavaScriptUtils(js);
        this.dispatcher = state.context.getEventDispatcher();
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
                eventHandler(event, rest)
            }
        }
    }

    public function eventHandler(event:String, rest:Array):void {
        var params:Object = rest ? rest[0] : null;
        context.eventLog({event:event, params:params});
        dispatcher.dispatchEvent(new EventVkcom(event, params));
    }
}
}

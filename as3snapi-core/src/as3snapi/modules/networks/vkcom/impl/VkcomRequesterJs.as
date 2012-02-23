package as3snapi.modules.networks.vkcom.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.feautures.core.javascript.JavaScriptUtils;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomRequester;

import flash.utils.setTimeout;

public class VkcomRequesterJs implements IFeatureVkcomRequester {
    private var context:INetworkModuleContext;
    private var js:IFeatureJavaScript;
    private var jsUtils:JavaScriptUtils;

    public function VkcomRequesterJs(state:VkcomState) {
        this.context = state.context;
        this.js = state.context.getJavaScript();
        this.jsUtils = new JavaScriptUtils(js);
    }

    public function apiCall(method:String, params:Object, onSuccess:Function, onFail:Function):void {
        jsUtils.callSmart("VK.api", method, params, callback);

        function callback(result:Object):void {
            if (("error" in result) && (result.error.error_code == 6)) {
                setTimeout(apiCall, 500, method, params, onSuccess, onFail);
                return;
            }
            context.apiLog({method:method, params:params, result:result});
            if ("response" in result) {
                onSuccess(result);
            } else {
                onFail(result);
            }
        }
    }
}
}

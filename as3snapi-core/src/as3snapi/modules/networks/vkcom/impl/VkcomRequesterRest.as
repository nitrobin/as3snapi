package as3snapi.modules.networks.vkcom.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.core.requester.IFeatureHttpRequester;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomRequester;
import as3snapi.utils.Md5Utils;
import as3snapi.utils.ObjectUtils;

import flash.net.URLRequestMethod;
import flash.utils.setTimeout;

public class VkcomRequesterRest implements IFeatureVkcomRequester {
    private var state:VkcomState;
    private var context:INetworkModuleContext;
    private var requester:IFeatureHttpRequester;

    public function VkcomRequesterRest(state:VkcomState, context:INetworkModuleContext) {
        this.state = state;
        this.context = context;
        this.requester = context.getHttpRequester();
    }

    public function apiCall(method:String, params:Object, onSuccess:Function, onFail:Function):void {
        var requestParams:Object = ObjectUtils.merge(params, {
            method:method,
            api_id:state.api_id,
            format:"JSON",
            v:"3.0"
        });
        requestParams.sig = generateSignature(requestParams);
        requestParams['sid'] = state.sid;

        requester.doRequestJson(state.api_url, requestParams, URLRequestMethod.POST, onSuccess2, onFail);

        function onSuccess2(result:Object):void {
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

    private function generateSignature(params:Object):String {
        var sortedArray:Array = new Array();
        for (var key:String in params) {
            sortedArray.push(key + "=" + params[key]);
        }
        sortedArray.sort();
        var sigData:String = state.viewer_id + sortedArray.join('') + state.secret;
        return Md5Utils.hash(sigData);
    }

}
}

package as3snapi.modules.networks.vkcom.impl {
import as3snapi.feautures.core.requester.IFeatureHttpRequester;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomRequester;

import flash.net.URLRequestMethod;

public class VkcomRequesterRest implements IFeatureVkcomRequester {
    private var state:VkcomState;
    private var requester:IFeatureHttpRequester;

    public function VkcomRequesterRest(state:VkcomState) {
        this.state = state;
        this.requester = state.context.getHttpRequester();
    }

    public function apiCall(method:String, params:Object, onSuccess:Function, onFail:Function):void {
        requester.doRequestJson(state.api_url, params, URLRequestMethod.POST, onSuccess, onFail);
    }
}
}

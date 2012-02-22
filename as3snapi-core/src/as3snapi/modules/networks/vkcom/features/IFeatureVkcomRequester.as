package as3snapi.modules.networks.vkcom.features {
/**
 * Специфичное для vk.com API
 * Произвольный запрос к сети.
 */
public interface IFeatureVkcomRequester {
    function apiCall(method:String, params:Object, onSuccess:Function, onFail:Function):void;
}
}

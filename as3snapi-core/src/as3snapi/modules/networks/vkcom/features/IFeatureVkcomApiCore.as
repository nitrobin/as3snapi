package as3snapi.modules.networks.vkcom.features {
/**
 * Специфичное для vk.com API
 * Запросы к сети.
 */
public interface IFeatureVkcomApiCore {
    function getUserBalance(onSuccess:Function, onError:Function):void;
}
}

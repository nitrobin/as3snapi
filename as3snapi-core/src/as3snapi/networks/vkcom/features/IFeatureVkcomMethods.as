package as3snapi.networks.vkcom.features {
/**
 * Специфичное для vk.com API
 * Вызов метода UI
 */
public interface IFeatureVkcomMethods {
    function callMethod(method:String, ...rest):void;
}
}

package as3snapi.modules.networks.vkcom.features {
/**
 * Специфичное для vk.com API
 * UI-функции. Отображение диалогов.
 */
public interface IFeatureVkcomApiUi {
    function showInviteBox():void ;

    function showPaymentBox(votes:int):void ;
}
}

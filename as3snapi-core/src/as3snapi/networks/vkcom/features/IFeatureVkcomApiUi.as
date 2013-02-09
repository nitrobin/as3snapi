package as3snapi.networks.vkcom.features {
/**
 * Специфичное для vk.com API
 * UI-функции. Отображение диалогов.
 */
public interface IFeatureVkcomApiUi {
    function showInviteBox():void ;

    /**
     * http://vk.com/developers.php?oid=-1&p=%D0%94%D0%B8%D0%B0%D0%BB%D0%BE%D0%B3%D0%BE%D0%B2%D0%BE%D0%B5_%D0%BE%D0%BA%D0%BD%D0%BE_%D0%BF%D0%BB%D0%B0%D1%82%D0%B5%D0%B6%D0%B5%D0%B9_
     * @param type
     * @param votes
     * @param offer_id
     * @param item
     */
    function showOrderBox(params:Object):void ;

    function showOrderBoxVotes(votes:int):void ;

    function showOrderBoxOffers(offer_id:int):void ;

    function showOrderBoxItem(item:String):void ;
}
}

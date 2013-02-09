package as3snapi.networks.vkcom.impl {
import as3snapi.api.feautures.social.invites.IFeatureInvitePopup;
import as3snapi.base.INetworkModuleContext;
import as3snapi.networks.vkcom.features.IFeatureVkcomApiUi;
import as3snapi.networks.vkcom.features.IFeatureVkcomMethods;
import as3snapi.utils.bus.IMutableBus;

/**
 * Функции связанные с интерфейсом. Отображение диалогов.
 */
public class VkcomApiUi implements IFeatureVkcomApiUi,
        IFeatureInvitePopup {
    private var methods:IFeatureVkcomMethods;

    public function VkcomApiUi(state:VkcomState, context:INetworkModuleContext) {
        var bus:IMutableBus = context.getBus();
        this.methods = bus.getFeature(IFeatureVkcomMethods);
    }

    // social

    public function showInvitePopup():void {
        showInviteBox();
    }

    // vk

    public function showInviteBox():void {
        methods.callMethod("showInviteBox");
    }

    public function showOrderBox(params:Object):void {
        methods.callMethod("showOrderBox", params);
    }

    public function showOrderBoxVotes(votes:int):void {
        showOrderBox({"type":"votes", "votes":votes});
    }

    public function showOrderBoxOffers(offer_id:int):void {
        showOrderBox({"type":"offers", "offer_id":offer_id});
    }

    public function showOrderBoxItem(item:String):void {
        showOrderBox({"type":"item", "item":item});
    }
}
}

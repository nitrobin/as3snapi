package as3snapi.modules.networks.vkcom.impl {
import as3snapi.bus.IMutableBus;
import as3snapi.feautures.basic.invites.IFeatureInvitePopup;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomApiUi;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomMethods;

public class VkcomApiUi implements IFeatureVkcomApiUi,
        IFeatureInvitePopup {
    private var methods:IFeatureVkcomMethods;

    public function VkcomApiUi(state:VkcomState) {
        var bus:IMutableBus = state.context.getBus();
        this.methods = bus.getFeature(IFeatureVkcomMethods);
    }

    // basic

    public function showInvitePopup():void {
        showInviteBox();
    }

    // vk

    public function showInviteBox():void {
        methods.callMethod("showInviteBox");
    }

    public function showPaymentBox(votes:int):void {
        methods.callMethod("showPaymentBox", votes);
    }
}
}

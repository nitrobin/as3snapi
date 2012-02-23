package as3snapi.modules.networks.vkcom.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.core.flashvars.FlashVars;
import as3snapi.modules.networks.vkcom.ConfigVkcom;

public class VkcomState {
    internal var context:INetworkModuleContext;
    internal var config:ConfigVkcom;

    internal var api_id:String;
    internal var api_url:String;
    internal var viewer_id:String;
    internal var user_id:String;
    internal var sid:String;
    internal var secret:String;

    public function VkcomState(context:INetworkModuleContext) {
        this.context = context;
        this.config = ConfigVkcom(context.getConfig());

        var flashVars:FlashVars = context.getFlashVars();

        this.api_id = flashVars.getString("api_id");
        this.api_url = flashVars.getString("api_url");
        this.viewer_id = flashVars.getString("viewer_id");
        this.user_id = flashVars.getString("user_id");
        this.sid = flashVars.getString("sid");
        this.secret = flashVars.getString("secret");
        if (this.user_id == "0") {
            this.user_id = null;
        }
    }
}
}

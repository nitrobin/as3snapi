package as3snapi.networks.vkcom.impl {
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.flashvars.FlashVars;
import as3snapi.networks.vkcom.ConfigVkcom;

public class VkcomState {
    private var context:INetworkModuleContext;
    internal var config:ConfigVkcom;

    internal var api_id:String;
    internal var api_url:String;
    internal var viewer_id:String;
    internal var user_id:String;
    internal var sid:String;
    internal var secret:String;
    internal var lc_name:String;

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
        this.lc_name = flashVars.getString("lc_name");
        if (this.user_id == "0") {
            this.user_id = null;
        }
    }
}
}

package as3snapi.modules.networks.mailru.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.core.flashvars.FlashVars;
import as3snapi.modules.networks.mailru.ConfigMailru;

public class MailruState {
    internal var context:INetworkModuleContext;
    internal var config:ConfigMailru;
    internal var appId:String;
    internal var vid:String;
    internal var oid:String;

    public function MailruState(context:INetworkModuleContext) {
        this.context = context;
        this.config = ConfigMailru(context.getConfig());

        var flashVars:FlashVars = context.getFlashVars();

        this.appId = flashVars.getString("app_id");
        this.vid = flashVars.getString("vid");
        this.oid = flashVars.getString("oid");
    }

    public function getConfig():ConfigMailru {
        return config;
    }
}
}

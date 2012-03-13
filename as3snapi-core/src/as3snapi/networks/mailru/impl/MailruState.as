package as3snapi.networks.mailru.impl {
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.flashvars.FlashVars;
import as3snapi.networks.mailru.ConfigMailru;

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

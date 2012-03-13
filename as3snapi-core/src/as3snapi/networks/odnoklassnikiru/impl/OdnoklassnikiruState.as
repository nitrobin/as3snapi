package as3snapi.networks.odnoklassnikiru.impl {
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.flashvars.FlashVars;
import as3snapi.networks.odnoklassnikiru.ConfigOdnoklassnikiru;

public class OdnoklassnikiruState {
    private var context:INetworkModuleContext;
    internal var config:ConfigOdnoklassnikiru;

    internal var logged_user_id:String;
    internal var api_server:String;
    internal var application_key:String;
    internal var session_key:String;
    internal var session_secret_key:String;
    internal var authorized:String;
    internal var apiconnection:String;
    internal var auth_sig:String;
    internal var sig:String;

    internal var refplace:String;
    internal var referer:String;
    internal var custom_args:String;

    public function OdnoklassnikiruState(context:INetworkModuleContext) {
        this.context = context;
        this.config = ConfigOdnoklassnikiru(context.getConfig());

        var flashVars:FlashVars = context.getFlashVars();

        this.logged_user_id = flashVars.getString("logged_user_id");
        this.api_server = flashVars.getString("api_server");
        this.application_key = flashVars.getString("application_key");
        this.session_key = flashVars.getString("session_key");
        this.session_secret_key = flashVars.getString("session_secret_key");
        this.authorized = flashVars.getString("authorized");
        this.apiconnection = flashVars.getString("apiconnection");
        this.auth_sig = flashVars.getString("auth_sig");
        this.sig = flashVars.getString("sig");

        this.refplace = flashVars.getString("refplace");
        this.referer = flashVars.getString("referer");
        this.custom_args = flashVars.getString("custom_args");
    }
}
}

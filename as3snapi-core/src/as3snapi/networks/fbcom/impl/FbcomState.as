package as3snapi.networks.fbcom.impl {
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.flashvars.FlashVars;

public class FbcomState {
    public var userID:String;
    public var accessToken:String;
    private var signedRequest:String;

    public function FbcomState(context:INetworkModuleContext) {
        var flashVars:FlashVars = context.getFlashVars();
        userID = flashVars.getString("userID")
        accessToken = flashVars.getString("accessToken")
        signedRequest = flashVars.getString("signedRequest")
    }
}
}

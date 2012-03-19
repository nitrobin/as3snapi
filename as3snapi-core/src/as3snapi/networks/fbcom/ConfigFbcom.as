package as3snapi.networks.fbcom {
import as3snapi.base.INetworkConfig;
import as3snapi.base.NetworkConfigBase;

public class ConfigFbcom extends NetworkConfigBase implements INetworkConfig {
    private var appId:String;

    /**
     * @param appId опционально если FB.init и FB.login выполняется в iframe
     */
    public function ConfigFbcom(appId:String = null) {
        this.appId = appId;
    }

    public function getAppId():String {
        return appId;
    }
}
}

package as3snapi.networks.odnoklassnikiru {
import as3snapi.base.INetworkConfig;
import as3snapi.base.NetworkConfigBase;

public class ConfigOdnoklassnikiru extends NetworkConfigBase implements INetworkConfig {
    private var secretKey:String;

    public function ConfigOdnoklassnikiru(secretKey:String) {
        this.secretKey = secretKey;
    }

    public function getSecretKey():String {
        return secretKey;
    }
}
}

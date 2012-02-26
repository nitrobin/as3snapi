package as3snapi.modules.networks.odnoklassnikiru {
import as3snapi.core.INetworkConfig;
import as3snapi.modules.networks.NetworkConfigBase;

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

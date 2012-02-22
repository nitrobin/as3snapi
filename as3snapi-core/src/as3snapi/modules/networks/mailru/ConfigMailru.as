package as3snapi.modules.networks.mailru {
import as3snapi.core.INetworkConfig;
import as3snapi.core.NetworkConfigBase;

/**
 * Настройки для mail.ru
 */
public class ConfigMailru extends NetworkConfigBase implements INetworkConfig {
    private var privateKey:String;

    /**
     * @param privateKey ключ для работы с API
     */
    public function ConfigMailru(privateKey:String) {
        this.privateKey = privateKey;
    }

    public function getPrivateKey():String {
        return privateKey;
    }
}
}

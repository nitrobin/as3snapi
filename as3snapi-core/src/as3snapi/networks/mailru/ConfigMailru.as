package as3snapi.networks.mailru {
import as3snapi.base.INetworkConfig;
import as3snapi.base.NetworkConfigBase;

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

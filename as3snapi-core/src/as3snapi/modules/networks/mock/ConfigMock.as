package as3snapi.modules.networks.mock {
import as3snapi.core.INetworkConfig;
import as3snapi.modules.networks.NetworkConfigBase;

/**
 * Настройки для оффлайновой mock-сети на основе заранее подготовленных данных
 */
public class ConfigMock extends NetworkConfigBase implements INetworkConfig {
    private var data:Object;
    private var dataUrl:String;

    public function ConfigMock() {
    }

    public function setData(data:Object):ConfigMock {
        this.data = data;
        return this;
    }

    public function getData():Object {
        return data;
    }

    public function setDataUrl(dataUrl:String):ConfigMock {
        this.dataUrl = dataUrl;
        return this;
    }

    public function getDataUrl():String {
        return dataUrl;
    }


}
}

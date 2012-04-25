package as3snapi.networks.mock {
import as3snapi.base.INetworkConfig;
import as3snapi.base.NetworkConfigBase;

/**
 * Настройки для оффлайновой mock-сети на основе заранее подготовленных данных
 */
public class ConfigMock extends NetworkConfigBase implements INetworkConfig {
    private var snapshot:Object;
    private var snapshotUrl:String;
    private var available:Boolean = true;

    public function ConfigMock() {
    }

    public function setSnapshot(snapshot:Object):ConfigMock {
        this.snapshot = snapshot;
        return this;
    }

    public function getSnapshot():Object {
        return snapshot;
    }

    /**
     * Урл JSON файла со снимком для соц сети
     * @param snapshotUrl
     * @return
     */
    public function setSnapshotUrl(snapshotUrl:String):ConfigMock {
        this.snapshotUrl = snapshotUrl;
        return this;
    }

    public function getDataUrl():String {
        return snapshotUrl;
    }

    public function setAvailable(available:Boolean):ConfigMock {
        this.available = available;
        return this;
    }

    public function isAvailable():Boolean {
        return available;
    }
}
}

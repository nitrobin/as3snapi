package as3snapi.modules.networks {
import as3snapi.core.INetworkConfig;

public class NetworkConfigBase implements INetworkConfig {
    private var values:Object = {};

    public function NetworkConfigBase() {
    }

    public function hasValue(key:String):Boolean {
        return key in values;
    }

    public function getValue(key:String):* {
        return values[key];
    }

    public function setValue(key:String, value:*):INetworkConfig {
        values[key] = value;
        return this;
    }
}
}

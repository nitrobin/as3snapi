package as3snapi.core {
import as3snapi.bus.IBus;

public class SocialityConnection implements ISocialityConnection {
    private var bus:IBus;
    private var config:INetworkConfig;

    public function SocialityConnection(bus:IBus, config:INetworkConfig) {
        this.bus = bus;
        this.config = config;
    }

    public function getBus():IBus {
        return bus;
    }

    public function getConfig():INetworkConfig {
        return config;
    }

    public function getFeature(featureClass:Class):* {
        return bus.getFeature(featureClass);
    }

    public function hasFeature(featureClass:Class):Boolean {
        return bus.hasFeature(featureClass);
    }
}
}

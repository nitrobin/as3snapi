package as3snapi.core {
import as3snapi.bus.IBus;

/**
 * Интерфейс активного подключения к соцсети
 */
public interface INetworkConnection {
    function getBus():IBus;

    function getFeature(featureClass:Class):*;

    function hasFeature(featureClass:Class):Boolean;

    function getConfig():INetworkConfig;

}
}

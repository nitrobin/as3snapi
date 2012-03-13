package as3snapi.api {
import as3snapi.base.INetworkConfig;
import as3snapi.utils.bus.IBus;

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

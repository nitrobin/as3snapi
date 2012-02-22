package as3snapi.core {
import as3snapi.bus.IBus;

public interface ISocialityConnection {
    function getBus():IBus;

    function getFeature(featureClass:Class):*;

    function hasFeature(featureClass:Class):Boolean;

}
}

package as3snapi.bus {
import flash.events.IEventDispatcher;

public interface IBus extends IEventDispatcher {
    function getFeature(featureClass:Class):*;

    function hasFeature(featureClass:Class):Boolean;

    function getFeatures():Array;

}
}

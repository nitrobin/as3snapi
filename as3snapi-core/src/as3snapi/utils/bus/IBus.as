package as3snapi.utils.bus {
import flash.events.IEventDispatcher;

/**
 * Неизменяемая шина для навешивания функций
 */
public interface IBus extends IEventDispatcher {
    function getFeature(featureClass:Class):*;

    function hasFeature(featureClass:Class):Boolean;

    function getFeatures():Array;

}
}

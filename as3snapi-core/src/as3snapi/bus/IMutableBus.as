package as3snapi.bus {
public interface IMutableBus extends IBus {

    function addFeature(featureClass:Class, instance:Object):IMutableBus;

    function addFeatureIfNotExist(featureClass:Class, instance:Object):IMutableBus;

    function disable(featureClass:Class):IMutableBus;

    function getVersion():int;
}
}

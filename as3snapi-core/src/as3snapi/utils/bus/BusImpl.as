package as3snapi.utils.bus {
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

public class BusImpl extends EventDispatcher implements IMutableBus {
    public function BusImpl() {
    }

    private var features:Array = new Array();
    private var delegates:Dictionary = new Dictionary();
    private var version:int = 0;

    private var eventsEnabled:Boolean = true;

    private function changed(event:String, featureClass:Class, delegate:Object = null):void {
        if (eventsEnabled) {
            try {
                eventsEnabled = false;
                dispatchEvent(new BusChangeEvent(event, this, featureClass, delegate));
            } finally {
                eventsEnabled = true;
            }
        }
    }

    public function addFeature(featureClass:Class, delegate:Object):IMutableBus {
        if (!(delegate is featureClass)) {
            var msg:String = "Mixin error. " + getQualifiedClassName(delegate) + " must implement " + getQualifiedClassName(featureClass);
            throw new UnsupportedFeatureError(msg);
        }
        delegates[featureClass] = delegate;
        version++;
        var i:int = features.indexOf(featureClass);
        if (i == -1) {
            features.push(featureClass);
        }
        changed(BusChangeEvent.FEATURE_ADDED, featureClass, delegate);
        return this;
    }

    public function addFeatureIfNotExist(featureClass:Class, instance:Object):IMutableBus {
        if (!hasFeature(featureClass)) {
            addFeature(featureClass, instance)
        }
        return this;
    }

    public function disable(featureClass:Class):IMutableBus {
        if (!(featureClass in delegates)) {
            return this;
        }
        delete delegates[featureClass];
        version++;
        var i:int = features.indexOf(featureClass);
        if (i != -1) {
            features.splice(i, 1);
        }
        changed(BusChangeEvent.FEATURE_DISABLED, featureClass);
        return this;
    }

    public function getFeature(featureClass:Class):* {
        return delegates[featureClass];
    }

    public function hasFeature(featureClass:Class):Boolean {
        return featureClass in delegates;
    }

    public function getVersion():int {
        return version;
    }

    public function getFeatures():Array {
        return features.slice();
    }
}
}

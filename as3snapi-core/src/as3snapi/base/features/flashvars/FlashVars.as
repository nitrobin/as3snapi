package as3snapi.base.features.flashvars {
import as3snapi.utils.JsonUtils;

public class FlashVars {
    private var flashVars:Object;

    public function FlashVars(flashVars:Object) {
        this.flashVars = flashVars;
    }

    public function getString(key:String, defaultValue:String = null):String {
        if (key in flashVars) {
            return  flashVars[key];
        }
        return defaultValue;
    }

    public function getInt(key:String, defaultValue:int = 0):int {
        if (key in flashVars) {
            try {
                return int(flashVars[key]);
            } catch (e:Error) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    public function toString():String {
        return JsonUtils.encode(flashVars);
    }

    public function asObject():Object {
        return flashVars;
    }

    public function isEmpty():Boolean {
        for (var k:String in flashVars) {
            return false;
        }
        return true;
    }


    public static function fromObject(flashVars:*):* {
        return (flashVars is FlashVars ? flashVars : new FlashVars(flashVars));
    }
}
}

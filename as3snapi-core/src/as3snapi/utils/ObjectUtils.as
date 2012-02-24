package as3snapi.utils {
public class ObjectUtils {
    public function ObjectUtils() {
    }

    public static function merge(...rest):Object {
        var r:Object = {};
        for each(var obj:Object in rest) {
            for (var k:String in obj) {
                r[k] = obj[k];
            }
        }
        return r;
    }

    public static function mergeTo(from:Object, to:Object):Object {
        for (var k:String in from) {
            to[k] = from[k];
        }
        return to;
    }
}
}

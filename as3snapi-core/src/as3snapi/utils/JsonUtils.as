package as3snapi.utils {
import com.adobe.serialization.json.JSON;

public class JsonUtils {

    public static function encode(o:Object):String {
        return com.adobe.serialization.json.JSON.encode(o);
    }

    public static function decode(s:String):* {
        return com.adobe.serialization.json.JSON.decode(s);
    }
}
}

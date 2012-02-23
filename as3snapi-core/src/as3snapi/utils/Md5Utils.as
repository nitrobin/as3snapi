package as3snapi.utils {
import com.adobe.crypto.MD5;

public class Md5Utils {
    public static function hash(data:String):String {
        return MD5.hash(data)
    }
}
}

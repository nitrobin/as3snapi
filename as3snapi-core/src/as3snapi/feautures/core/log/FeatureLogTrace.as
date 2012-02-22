package as3snapi.feautures.core.log {
import as3snapi.utils.JsonUtils;

import flash.external.ExternalInterface;

public class FeatureLogTrace implements IFeatureLog {
    private static var useJs:Boolean = true;

    public function FeatureLogTrace() {
    }

    public function log(msg:*):void {
        universalTrace(msg);
    }

    public function apiLog(msg:*):void {
        universalTrace(msg);
    }

    public function eventLog(msg:*):void {
        universalTrace(msg);
    }

    public static function universalTrace(msg:*):void {
        msg = universalDump(msg);
        trace(msg);
        try {
            if (useJs && ExternalInterface.available) {
                ExternalInterface.call("window.console.log", msg);
            }
        } catch (e:Error) {
            useJs = false;
        }
    }

    public static function universalDump(msg:*):String {
        return msg is String ? msg : JsonUtils.encode(msg);
    }
}
}

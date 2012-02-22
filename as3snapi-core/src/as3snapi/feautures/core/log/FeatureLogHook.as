package as3snapi.feautures.core.log {
public class FeatureLogHook implements IFeatureLog {
    private var logHook:Function;
    private var apiLogHook:Function;
    private var eventLogHook:Function;

    public function FeatureLogHook(logHook:Function, apiLogHook:Function, eventLogHook:Function) {
        this.logHook = logHook;
        this.apiLogHook = apiLogHook;
        this.eventLogHook = eventLogHook;
    }

    public function log(msg:*):void {
        logHook(msg);
    }

    public function apiLog(msg:*):void {
        apiLogHook(msg);
    }

    public function eventLog(msg:*):void {
        eventLogHook(msg);
    }
}
}

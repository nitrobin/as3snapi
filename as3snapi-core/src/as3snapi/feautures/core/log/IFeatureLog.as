package as3snapi.feautures.core.log {
public interface IFeatureLog {
    function log(msg:*):void;

    function apiLog(msg:*):void

    function eventLog(msg:*):void
}
}

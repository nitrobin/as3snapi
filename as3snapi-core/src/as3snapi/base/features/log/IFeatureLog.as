package as3snapi.base.features.log {
public interface IFeatureLog {
    function log(msg:*):void;

    function apiLog(msg:*):void

    function eventLog(msg:*):void
}
}

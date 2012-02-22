package as3snapi.core {
public interface ISocialityConnectHandler {
    function onSuccess(connection:ISocialityConnection):void;

    function onFail(result:Object):void;
}
}

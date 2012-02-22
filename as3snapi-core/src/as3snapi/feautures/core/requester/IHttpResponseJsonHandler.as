package as3snapi.feautures.core.requester {
public interface IHttpResponseJsonHandler {
    function onSuccess(result:Object):void;

    function onFail(result:Object):void;
}
}

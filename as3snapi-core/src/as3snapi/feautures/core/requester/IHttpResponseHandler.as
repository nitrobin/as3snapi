package as3snapi.feautures.core.requester {
public interface IHttpResponseHandler {
    function onSuccess(result:String):void;

    function onFail(result:Object):void;
}
}

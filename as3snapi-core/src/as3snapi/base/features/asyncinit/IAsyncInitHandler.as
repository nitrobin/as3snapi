package as3snapi.base.features.asyncinit {
public interface IAsyncInitHandler {
    function onSuccess(result:Object):void;

    function onFail(result:Object):void;
}
}

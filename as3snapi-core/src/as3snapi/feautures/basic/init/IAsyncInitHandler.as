package as3snapi.feautures.basic.init {
public interface IAsyncInitHandler {
    function onSuccess(result:Object):void;

    function onFail(result:Object):void;
}
}

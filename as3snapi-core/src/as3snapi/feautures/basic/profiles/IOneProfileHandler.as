package as3snapi.feautures.basic.profiles {
public interface IOneProfileHandler {
    function onSuccess(profile:IProfile):void;

    function onFail(result:Object):void;
}
}

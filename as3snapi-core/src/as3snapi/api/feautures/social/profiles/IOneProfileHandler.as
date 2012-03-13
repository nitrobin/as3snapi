package as3snapi.api.feautures.social.profiles {
public interface IOneProfileHandler {
    function onSuccess(profile:IProfile):void;

    function onFail(result:Object):void;
}
}

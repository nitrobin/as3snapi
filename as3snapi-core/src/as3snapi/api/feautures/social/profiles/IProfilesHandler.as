package as3snapi.api.feautures.social.profiles {
public interface IProfilesHandler {
    function onSuccess(profiles:Array):void;

    function onFail(result:Object):void;
}
}

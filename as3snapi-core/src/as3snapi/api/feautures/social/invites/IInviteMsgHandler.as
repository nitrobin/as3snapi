package as3snapi.api.feautures.social.invites {
public interface IInviteMsgHandler {
    function onSuccess(result:Object):void;

    function onUnknown(result:Object):void;

    function onFail(result:Object):void;
}
}

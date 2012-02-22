package as3snapi.feautures.basic.invites {
public interface IInviteMsgHandler {
    function onSuccess(result:Object):void;

    function onUnknown(result:Object):void;

    function onFail(result:Object):void;
}
}

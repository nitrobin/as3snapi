package as3snapi.feautures.basic.invites {

public interface IFeatureInviteMsg {
    function sendInviteMessage(msg:IInviteMsg, handler:IInviteMsgHandler):void
}
}

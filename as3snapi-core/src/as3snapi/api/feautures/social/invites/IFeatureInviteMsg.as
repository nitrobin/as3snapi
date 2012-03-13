package as3snapi.api.feautures.social.invites {

public interface IFeatureInviteMsg {
    function sendInviteMessage(msg:IInviteMsg, handler:IInviteMsgHandler):void
}
}

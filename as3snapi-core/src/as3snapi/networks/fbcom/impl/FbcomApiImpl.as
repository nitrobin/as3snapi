package as3snapi.networks.fbcom.impl {
import as3snapi.api.feautures.social.IFeatureNetworkId;
import as3snapi.api.feautures.social.IFeatureUserId;
import as3snapi.api.feautures.social.invites.IFeatureInvitePopup;
import as3snapi.api.feautures.social.profiles.IFeatureProfiles;
import as3snapi.api.feautures.social.profiles.IProfile;
import as3snapi.api.feautures.social.profiles.IProfilesHandler;
import as3snapi.api.feautures.social.profiles.Profile;
import as3snapi.api.feautures.social.uids.IFeatureAppFriendUids;
import as3snapi.api.feautures.social.uids.IFeatureFriendUids;
import as3snapi.api.feautures.social.uids.IIdsHandler;
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.javascript.JavaScriptUtils;
import as3snapi.networks.fbcom.features.IFeatureFbcomApiCore;

public class FbcomApiImpl implements IFeatureFbcomApiCore,
        IFeatureNetworkId,
//        IFeatureAppId,
        IFeatureUserId,
//        IFeatureRefererId,
        IFeatureInvitePopup,
        IFeatureProfiles,
        IFeatureAppFriendUids,
        IFeatureFriendUids
//        IFeatureAsyncInit
{
    //TODO: рефакторинг, оптимизация

    private var shortNetworkId:String;
    private var state:FbcomState;

    private var jsUtils:JavaScriptUtils;

    public function FbcomApiImpl(state:FbcomState, context:INetworkModuleContext, shortNetworkId:String) {
        this.state = state;
        this.jsUtils = context.getJavaScriptUtils();
        this.shortNetworkId = shortNetworkId;
        jsUtils.callSmart("FB.Canvas.setSize");
    }

    public function getShortNetworkId():String {
        return shortNetworkId;
    }

    public function getUserId():String {
        return state.userID;
    }

    public function getProfiles(uids:Array, handler:IProfilesHandler):void {
        if (uids == null || uids.length <= 0) {
            handler.onSuccess([]);
            return;
        }
        jsUtils.callSmart("FB.api", "?ids=" + uids.join(',') + "&fields=id,link,name,gender", function (result:Object, ...rest):void {
            var profiles:Array = [];
            for each(var p:Object in result) {
                profiles.push(parseProfile(p));
            }
            handler.onSuccess(profiles);
        });
// Меделнный вариант, по запросу на каждый профиль
//        var profiles:Array = [];
//
//        function next():void {
//            if (uids != null && uids.length > 0) {
//                var uid:Object = uids.pop();
//                jsUtils.callSmart("FB.api", uid, function (profile:Object, ...rest):void {
//                    profiles.push(parseProfile(profile))
//                    next();
//                });
//            } else {
//                handler.onSuccess(profiles);
//            }
//        }
//
//        next();
    }

    private static const GENDERS:Object = {"male":"m", "female":"f"};

    private function parseProfile(u:Object, ...rest):IProfile {
        var profile:Profile = new Profile();
        profile.userId = u.id;
        profile.profileUrl = u.link;
        profile.fullName = u.name;
        profile.avatar = getImageUrl(profile.userId, 'square');
        profile.photos = [
            getImageUrl(profile.userId, 'small'),
            getImageUrl(profile.userId, 'square'),
            getImageUrl(profile.userId, 'normal'),
            getImageUrl(profile.userId, 'large')
        ];
        profile.gender = GENDERS[u.gender];
        profile.setRawData(u);
        return profile;
    }

    public static var GRAPH_URL:String = 'https://graph.facebook.com';
    public static var API_URL:String = 'https://api.facebook.com';

    protected function getImageUrl(id:String, type:String = null):String {
        return GRAPH_URL
                + '/'
                + id
                + '/picture'
                + (type != null ? '?type=' + type : '');
    }

    public function showInvitePopup():void {
        //TODO: Invite message
        jsUtils.callSmart("FB.ui", {"method":'apprequests', message:"TODO: Invite message in FbcomApiImpl.", filters:['app_non_users']}, callback);

        function callback(result:Object):void {

        }
    }

    public function getFriendUids(handler:IIdsHandler):void {
        jsUtils.callSmart("FB.api", "me/friends", function (friends:Object, ...rest):void {
            handler.onSuccess(friends.data.map(function (it:*, ...rest):* {
                return it.id;
            }));
        });
    }

    public function getAppFriendUids(handler:IIdsHandler):void {
        jsUtils.callSmart("FB.api", {"method":"friends.getAppUsers"}, function (friends:Array, ...rest):void {
            handler.onSuccess(friends);
        });
    }

    public function getInviter():void {
        jsUtils.callSmart("FB.api", "/me/apprequests", function (apprequests:Object, ...rest):void {
            //TODO inviter id
//            try {
//                var reqVar:Object = (apprequests as Array)[0];
//                var requesterId:String = reqVar ? reqVar.from.id : '';
//                callback(requesterId);
//            } catch (e:Error) {
//                callback(null);
//            }
        });
    }
}
}

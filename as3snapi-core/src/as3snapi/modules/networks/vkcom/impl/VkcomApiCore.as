package as3snapi.modules.networks.vkcom.impl {
import as3snapi.bus.IMutableBus;
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.basic.IFeatureAppId;
import as3snapi.feautures.basic.IFeatureNetworkId;
import as3snapi.feautures.basic.IFeatureRefererId;
import as3snapi.feautures.basic.IFeatureUserId;
import as3snapi.feautures.basic.profiles.IFeatureProfilesBase;
import as3snapi.feautures.basic.profiles.IProfile;
import as3snapi.feautures.basic.profiles.IProfilesHandler;
import as3snapi.feautures.basic.profiles.Profile;
import as3snapi.feautures.basic.uids.IFeatureAppFriendUids;
import as3snapi.feautures.basic.uids.IFeatureFriendUids;
import as3snapi.feautures.basic.uids.IIdsHandler;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomApiCore;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomRequester;

public class VkcomApiCore implements IFeatureVkcomApiCore,
        IFeatureNetworkId,
        IFeatureAppId,
        IFeatureUserId,
        IFeatureRefererId,
        IFeatureProfilesBase,
        IFeatureAppFriendUids,
        IFeatureFriendUids {

    private var state:VkcomState;
    private var requester:IFeatureVkcomRequester;

    public function VkcomApiCore(state:VkcomState, context:INetworkModuleContext) {
        this.state = state;
        var bus:IMutableBus = context.getBus();
        this.requester = bus.getFeature(IFeatureVkcomRequester);
    }

    public function getShortNetworkId():String {
        return "vk";
    }

    public function getAppId():String {
        return state.api_id;
    }

    public function getUserId():String {
        return state.viewer_id;
    }

    public function getRefererId():String {
        return state.user_id;
    }

    public function getProfilesChunkSize():int {
        return 150;
    }

    public function getProfilesBase(uids:Array, handler:IProfilesHandler):void {
        var params:Object = {
            'uids':uids.join(","),
            'fields':"first_name,last_name,screen_name,sex,bdate,photo,photo_medium,photo_big,online"
        };
        requester.apiCall("getProfiles", params, onSuccess, onFail);

        function onSuccess(r:Object):void {
            if ("response" in r) {
                var profiles:Array = (r.response as Array).map(parseProfile, null);
                handler.onSuccess(profiles);
            } else {
                handler.onFail(r);
            }
        }

        function onFail(r:Object):void {
            handler.onFail(r);
        }
    }

    private static const GENDERS:Object = {2:"m", 1:"f"};

    private function parseProfile(u:Object, ...rest):IProfile {
        var profile:Profile = new Profile();
        profile.userId = u.uid;
        profile.profileUrl = "http://vk.com/id" + profile.userId;
        profile.fullName = u.first_name + " " + u.last_name;
        profile.avatar = u.photo;
        profile.photos = [u.photo, u.photo_medium, u.photo_big];
        profile.gender = GENDERS[u.sex];
        profile.setRawData(u);
        return profile;
    }


    public function getAppFriendUids(handler:IIdsHandler):void {
        requester.apiCall("friends.getAppUsers", null, onSuccess, onFail);

        function onSuccess(r:Object):void {
            if ("response" in r) {
                handler.onSuccess(r.response);
            } else {
                handler.onFail(r);
            }
        }

        function onFail(r:Object):void {
            handler.onFail(r);
        }
    }


    public function getFriendUids(handler:IIdsHandler):void {
        requester.apiCall("friends.get", null, onSuccess, onFail);

        function onSuccess(r:Object):void {
            if ("response" in r) {
                handler.onSuccess(r.response);
            } else {
                handler.onFail(r);
            }
        }

        function onFail(r:Object):void {
            handler.onFail(r);
        }
    }

    public function getUserBalance(onSuccess:Function, onFail:Function):void {
        requester.apiCall("getUserBalance", null, onSuccess2, onFail2);
        function onSuccess2(r:Object):void {
            onSuccess(r.response);
        }

        function onFail2(r:Object):void {
            onFail(r);
        }
    }
}
}

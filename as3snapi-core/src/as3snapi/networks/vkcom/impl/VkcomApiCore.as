package as3snapi.networks.vkcom.impl {
import as3snapi.api.feautures.social.IFeatureAppId;
import as3snapi.api.feautures.social.IFeatureNetworkId;
import as3snapi.api.feautures.social.IFeatureRefererId;
import as3snapi.api.feautures.social.IFeatureUserId;
import as3snapi.api.feautures.social.profiles.IFeatureProfilesBase;
import as3snapi.api.feautures.social.profiles.IProfile;
import as3snapi.api.feautures.social.profiles.IProfilesHandler;
import as3snapi.api.feautures.social.profiles.Profile;
import as3snapi.api.feautures.social.uids.IFeatureAppFriendUids;
import as3snapi.api.feautures.social.uids.IFeatureFriendUids;
import as3snapi.api.feautures.social.uids.IIdsHandler;
import as3snapi.base.INetworkModuleContext;
import as3snapi.networks.vkcom.features.IFeatureVkcomApiCore;
import as3snapi.networks.vkcom.features.IFeatureVkcomRequester;
import as3snapi.utils.bus.IMutableBus;

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
    private var shortNetworkId:String;

    public function VkcomApiCore(state:VkcomState, context:INetworkModuleContext, shortNetworkId:String) {
        this.state = state;
        this.shortNetworkId = shortNetworkId;
        var bus:IMutableBus = context.getBus();
        this.requester = bus.getFeature(IFeatureVkcomRequester);
    }

    public function getShortNetworkId():String {
        return shortNetworkId;
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
}
}

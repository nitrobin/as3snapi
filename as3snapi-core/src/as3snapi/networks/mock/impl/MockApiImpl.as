package as3snapi.networks.mock.impl {
import as3snapi.api.feautures.social.IFeatureAppId;
import as3snapi.api.feautures.social.IFeatureNetworkId;
import as3snapi.api.feautures.social.IFeatureRefererId;
import as3snapi.api.feautures.social.IFeatureUserId;
import as3snapi.api.feautures.social.profiles.IFeatureProfiles;
import as3snapi.api.feautures.social.profiles.IProfile;
import as3snapi.api.feautures.social.profiles.IProfilesHandler;
import as3snapi.api.feautures.social.profiles.Profile;
import as3snapi.api.feautures.social.uids.IFeatureAppFriendUids;
import as3snapi.api.feautures.social.uids.IFeatureFriendUids;
import as3snapi.api.feautures.social.uids.IIdsHandler;
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.asyncinit.IAsyncInitHandler;
import as3snapi.base.features.asyncinit.IFeatureAsyncInit;
import as3snapi.base.features.requester.IFeatureHttpRequester;
import as3snapi.networks.mock.ConfigMock;
import as3snapi.networks.mock.features.IFeatureMockApi;

import flash.net.URLRequestMethod;

public class MockApiImpl implements IFeatureMockApi,
        IFeatureNetworkId,
        IFeatureAppId,
        IFeatureUserId,
        IFeatureRefererId,
        IFeatureProfiles,
        IFeatureAppFriendUids,
        IFeatureFriendUids,
        IFeatureAsyncInit {
    private var config:ConfigMock;
    private var snapshot:Object;

    private var httpRequester:IFeatureHttpRequester;

    public function MockApiImpl(context:INetworkModuleContext) {
        this.config = ConfigMock(context.getConfig());
        this.snapshot = config.getSnapshot();
        this.httpRequester = context.getHttpRequester();
    }

    public function getShortNetworkId():String {
        return snapshot.shortNetworkId;
    }

    public function getAppId():String {
        return snapshot.appId;
    }

    public function getUserId():String {
        return snapshot.userId;
    }

    public function getRefererId():String {
        return snapshot.refererId;
    }

    public function getProfiles(uids:Array, handler:IProfilesHandler):void {
        if (snapshot.profiles) {
            var profiles:Array = [];
            for each(var uid:String in uids) {
                var u:Object = snapshot.profiles[uid];
                profiles.push(parseProfile(u, uid));
            }
            handler.onSuccess(profiles);
        } else {
            handler.onFail(null);
        }
    }

    private function parseProfile(u:Object, uid:String):IProfile {
        var profile:Profile = new Profile();
        profile.userId = uid;
        if (u != null) {
            profile.avatar = u.avatar;
            profile.photos = u.photos;
            profile.fullName = u.fullName;
            profile.profileUrl = u.profileUrl;
            profile.gender = u.gender;
            profile.setRawData(u);
        } else {
            profile.fullName = uid;
        }
        return profile;
    }

    public function getAppFriendUids(handler:IIdsHandler):void {
        handler.onSuccess(snapshot.appFriendsUids || []);
    }

    public function getFriendUids(handler:IIdsHandler):void {
        handler.onSuccess(snapshot.friendsUids || []);
    }

    public function init(handler:IAsyncInitHandler):void {
        if (snapshot == null) {
            var dataUrl:String = config.getDataUrl();
            if (dataUrl == null) {
                handler.onFail("Empty snapshot")
            } else {
                httpRequester.doRequestJson(dataUrl, null, URLRequestMethod.GET, function (r:Object):void {
                    snapshot = r;
                    handler.onSuccess("ok");
                }, function (r:Object):void {
                    handler.onFail(r);
                });
            }
        } else {
            handler.onSuccess("ok");
        }
    }

    public function getMockSnapshot():Object {
        return snapshot;
    }
}
}

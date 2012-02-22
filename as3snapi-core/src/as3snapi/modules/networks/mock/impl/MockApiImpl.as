package as3snapi.modules.networks.mock.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.basic.IFeatureAppId;
import as3snapi.feautures.basic.IFeatureRefererId;
import as3snapi.feautures.basic.IFeatureUserId;
import as3snapi.feautures.basic.init.IAsyncInitHandler;
import as3snapi.feautures.basic.init.IFeatureAsyncInit;
import as3snapi.feautures.basic.profiles.IFeatureProfiles;
import as3snapi.feautures.basic.profiles.IProfile;
import as3snapi.feautures.basic.profiles.IProfilesHandler;
import as3snapi.feautures.basic.profiles.Profile;
import as3snapi.feautures.basic.uids.IFeatureAppFriendUids;
import as3snapi.feautures.basic.uids.IFeatureFriendUids;
import as3snapi.feautures.basic.uids.IIdsHandler;
import as3snapi.feautures.core.requester.IFeatureHttpRequester;
import as3snapi.modules.networks.mock.ConfigMock;
import as3snapi.modules.networks.mock.features.IFeatureMockApi;

import flash.net.URLRequestMethod;

public class MockApiImpl implements IFeatureMockApi,
        IFeatureAppId,
        IFeatureUserId,
        IFeatureRefererId,
        IFeatureProfiles,
        IFeatureAppFriendUids,
        IFeatureFriendUids,
        IFeatureAsyncInit {
    private var config:ConfigMock;
    private var data:Object;

    private var httpRequester:IFeatureHttpRequester;

    public function MockApiImpl(context:INetworkModuleContext) {
        this.config = ConfigMock(context.getConfig());
        this.data = config.getData();
        this.httpRequester = context.getHttpRequester();
    }


    public function getAppId():String {
        return data.appId;
    }

    public function getUserId():String {
        return data.userId;
    }

    public function getRefererId():String {
        return data.refererId;
    }

    public function getProfiles(uids:Array, handler:IProfilesHandler):void {
        if (data.profiles) {
            var profiles:Array = [];
            for each(var uid:String in uids) {
                var u:Object = data.profiles[uid];
                if (u != null) {
                    profiles.push(parseProfile(u, uid));
                }
            }
            handler.onSuccess(profiles);
        } else {
            handler.onFail(null);
        }
    }

    private function parseProfile(u:Object, uid:String):IProfile {
        var profile:Profile = new Profile();
        profile.userId = uid;
        profile.avatarUrl = u.avatarUrl;
        profile.fullName = u.fullName;
        profile.profileUrl = u.profileUrl;
        profile.sex = u.sex;
        profile.setRawData(u);
        return profile;
    }

    public function getAppFriendUids(handler:IIdsHandler):void {
        handler.onSuccess(data.appFriendsUids || []);
    }

    public function getFriendUids(handler:IIdsHandler):void {
        handler.onSuccess(data.friendsUids || []);
    }

    public function init(handler:IAsyncInitHandler):void {
        if (data == null) {
            var dataUrl:String = config.getDataUrl();
            if (dataUrl == null) {
                handler.onFail("Empty data")
            } else {
                //TODO
                httpRequester.doRequestJson(dataUrl, null, URLRequestMethod.GET, function (r:Object):void {
                    data = r;
                    handler.onSuccess(r);
                }, function (r:Object):void {
                    handler.onFail(r);
                });
            }
        } else {
            handler.onSuccess(null);
        }
    }

    public function getMockaData():Object {
        return data;
    }
}
}

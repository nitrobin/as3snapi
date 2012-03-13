package as3snapi.networks.mock {
import as3snapi.api.feautures.social.IFeatureAppId;
import as3snapi.api.feautures.social.IFeatureNetworkId;
import as3snapi.api.feautures.social.IFeatureRefererId;
import as3snapi.api.feautures.social.IFeatureUserId;
import as3snapi.api.feautures.social.profiles.IFeatureAppFriendsProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureFriendsProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureProfiles;
import as3snapi.api.feautures.social.profiles.IProfile;
import as3snapi.api.feautures.social.profiles.ProfilesHandler;
import as3snapi.utils.JsonUtils;
import as3snapi.utils.bus.IBus;

import flash.net.FileReference;

/**
 * Класс для захвата данных текущего юзера в файл для последующего использования в качестве источника данных в Mock-сети
 * @see ConfigMock
 */
public class MockDataCapture {
    private var bus:IBus;

    private var data:Object = {};

    public function MockDataCapture(bus:IBus) {
        this.bus = bus;
    }

    public function capture(onSuccess:Function, onFail:Function, uids:Array = null):void {
        if (!uids) {
            uids = [];
        }

        if (bus.hasFeature(IFeatureNetworkId)) {
            data.shortNetworkId = IFeatureNetworkId(bus.getFeature(IFeatureNetworkId)).getShortNetworkId();
        }
        if (bus.hasFeature(IFeatureAppId)) {
            data.appId = IFeatureAppId(bus.getFeature(IFeatureAppId)).getAppId();
        }
        if (bus.hasFeature(IFeatureUserId)) {
            data.userId = IFeatureUserId(bus.getFeature(IFeatureUserId)).getUserId();
            if (data.userId) {
                uids.push(data.userId);
            }
        }
        if (bus.hasFeature(IFeatureRefererId)) {
            data.refererId = IFeatureRefererId(bus.getFeature(IFeatureRefererId)).getRefererId();
            if (data.refererId) {
                uids.push(data.refererId);
            }
        }
        var calls:Array = [
            function ():void {
                if (bus.hasFeature(IFeatureProfiles) && uids) {
                    var f:IFeatureProfiles = bus.getFeature(IFeatureProfiles);
                    f.getProfiles(uids, new ProfilesHandler(function (profiles:Array):void {
                        updateProfiles(profiles);
                        next();
                    }, function (result:Object):void {
                        onFail(result);
                    }));
                } else {
                    next();
                }
            },
            function ():void {
                if (bus.hasFeature(IFeatureAppFriendsProfiles)) {
                    var f:IFeatureAppFriendsProfiles = bus.getFeature(IFeatureAppFriendsProfiles);
                    f.getAppFriendsProfiles(new ProfilesHandler(function (profiles:Array):void {
                        updateProfiles(profiles);
                        data.appFriendsUids = profiles.map(function (p:IProfile, ...rest):Object {
                            return p.getUserId();
                        });
                        next();
                    }, function (result:Object):void {
                        onFail(result);
                    }));
                } else {
                    next();
                }
            },
            function ():void {
                if (bus.hasFeature(IFeatureFriendsProfiles)) {
                    var f:IFeatureFriendsProfiles = bus.getFeature(IFeatureFriendsProfiles);
                    f.getFriendsProfiles(new ProfilesHandler(function (profiles:Array):void {
                        updateProfiles(profiles);
                        data.friendsUids = profiles.map(function (p:IProfile, ...rest):Object {
                            return p.getUserId();
                        });
                        next();
                    }, function (result:Object):void {
                        onFail(result);
                    }));
                } else {
                    next();
                }
            },

        ];
        next();

        function next():void {
            if (calls.length > 0) {
                var func:* = calls.shift();
                func();
            }
            else {
                onSuccess(data);
            }
        }
    }

    private function updateProfiles(profiles:Array):void {
        if (!data.profiles) {
            data.profiles = {};
        }
        for each (var p:IProfile in profiles) {
            data.profiles[p.getUserId()] = {
                userId:p.getUserId(),
                fullName:p.getFullName(),
                avatar:p.getAvatar(),
                photos:p.getPhotos(),
                profileUrl:p.getProfileUrl(),
                gender:p.getGender()
            };
        }
    }

    /**
     * Сохранит захваченные данные в файл.
     */
    public function getMockData():Object {
        return data;
    }

    public function saveFile(fname:String = null):void {
        var fileReference:FileReference = new FileReference();
        var encodedData:String = JsonUtils.encode(data);
        var defaultFileName:String = fname || ("user" + data.userId + ".json");
        fileReference.save(encodedData, defaultFileName);
    }

}
}

package as3snapi.networks.odnoklassnikiru.impl {
import as3snapi.api.feautures.social.IFeatureNetworkId;
import as3snapi.api.feautures.social.IFeatureRefererId;
import as3snapi.api.feautures.social.IFeatureUserId;
import as3snapi.api.feautures.social.invites.IFeatureInvitePopup;
import as3snapi.api.feautures.social.profiles.IFeatureProfilesBase;
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
import as3snapi.networks.odnoklassnikiru.features.IFeatureOdnoklassnikiApi;
import as3snapi.utils.Md5Utils;

import com.api.forticom.ForticomAPI;

import flash.net.URLRequestMethod;

public class OdnoklassnikiruApiImpl implements IFeatureOdnoklassnikiApi,
        IFeatureAsyncInit,
        IFeatureNetworkId,
        IFeatureUserId,
        IFeatureRefererId,
        IFeatureInvitePopup,
        IFeatureProfilesBase,
        IFeatureFriendUids,
        IFeatureAppFriendUids {
    private var state:OdnoklassnikiruState;
    private var context:INetworkModuleContext;

    private var requester:IFeatureHttpRequester;
    private var shortNetworkId:String;

    public function OdnoklassnikiruApiImpl(state:OdnoklassnikiruState, context:INetworkModuleContext, shortNetworkId:String) {
        this.state = state;
        this.context = context;
        this.shortNetworkId = shortNetworkId;
        this.requester = context.getHttpRequester();
    }

    public function init(handler:IAsyncInitHandler):void {
        ForticomAPI.connection = state.apiconnection;
        ForticomAPI.addEventListener(ForticomAPI.CONNECTED, function (...rest):void {
            handler.onSuccess("ok");
        });
    }

    public function getShortNetworkId():String {
        return shortNetworkId;
    }

    public function getUserId():String {
        return state.logged_user_id;
    }

    public function getRefererId():String {
        return state.referer;
    }

    public function showInvitePopup():void {
        ForticomAPI.showInvite();
    }


    public function getProfilesChunkSize():int {
        return 100;
    }


    public function getProfilesBase(uids:Array, handler:IProfilesHandler):void {
        apiRequest("/users/getInfo", {
                    uids:uids.join(','),
                    fields:"uid,first_name,last_name,gender,pic_1,pic_2,pic_3,pic_4,url_profile"
                },
                function (r:Object):void {
                    if (handler) {
                        var profiles:Array = (r as Array).map(parseProfile, null);
                        handler.onSuccess(profiles);
                    }
                },
                function (r:Object):void {
                    handler.onFail(r);
                }, false);
    }


    private static const GENDERS:Object = {"male":"m", "female":"f"};

    private function parseProfile(u:Object, ...rest):IProfile {
        var profile:Profile = new Profile();
        profile.userId = u.uid;
        profile.profileUrl = u.url_profile;
        profile.fullName = u.first_name + " " + u.last_name;
        profile.avatar = u.pic_1;
        profile.photos = [u.pic_1, u.pic_2, u.pic_3, u.pic_4];
        profile.gender = GENDERS[u.gender];
        profile.setRawData(u);
        return profile;
    }


    public function getFriendUids(handler:IIdsHandler):void {
        apiRequest("/friends/get", {},
                function (r:Object):void {
                    if (handler) {
                        handler.onSuccess(r as Array || []);
                    }
                },
                function (r:Object):void {
                    handler.onFail(r);
                }, false);
    }

    public function getAppFriendUids(handler:IIdsHandler):void {
        apiRequest("/friends/getAppUsers", {},
                function (r:Object):void {
                    if (handler) {
                        handler.onSuccess(r.uids as Array || []);
                    }
                },
                function (r:Object):void {
                    handler.onFail(r);
                }, false);
    }

    public function apiRequest(method:String, params:Object, onSuccess:Function, onFail:Function, exeption:Boolean = false):void {
        var url:String = state.api_server + "api" + method;
        requester.doRequestJson(url, signRequest(params, exeption), URLRequestMethod.GET, onSuccess, onFail);
    }

    private function signRequest(data:Object, exeption:Boolean = false):Object {
        data["format"] = "JSON";
        data["application_key"] = state.application_key;
        if (data['uid'] == undefined || exeption)
            data["session_key"] = state.session_key;

        var sig:String = '';
        var keys:Array = [], key:String;
        for (key in data) {
            keys.push(key);
        }
        keys.sort();
        var i:int = 0, l:int = keys.length;
        for (i; i < l; i++) {
            sig += keys[i] + "=" + data[keys[i]];
        }
        sig += (data['uid'] != undefined && !exeption) ? state.config.getSecretKey() : state.session_secret_key;

        data["sig"] = Md5Utils.hash(sig).toLowerCase();
        return data;
    }
}
}

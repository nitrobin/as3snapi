package as3snapi.modules.networks.odnoklassnikiru.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.basic.IFeatureNetworkId;
import as3snapi.feautures.basic.IFeatureRefererId;
import as3snapi.feautures.basic.IFeatureUserId;
import as3snapi.feautures.basic.init.IAsyncInitHandler;
import as3snapi.feautures.basic.init.IFeatureAsyncInit;
import as3snapi.feautures.basic.invites.IFeatureInvitePopup;
import as3snapi.feautures.basic.profiles.IFeatureProfilesBase;
import as3snapi.feautures.basic.profiles.IProfile;
import as3snapi.feautures.basic.profiles.IProfilesHandler;
import as3snapi.feautures.basic.profiles.Profile;
import as3snapi.feautures.basic.uids.IFeatureAppFriendUids;
import as3snapi.feautures.basic.uids.IFeatureFriendUids;
import as3snapi.feautures.basic.uids.IIdsHandler;
import as3snapi.feautures.core.requester.IFeatureHttpRequester;
import as3snapi.modules.networks.odnoklassnikiru.features.IFeatureOdnoklassnikiApi;
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

    public function OdnoklassnikiruApiImpl(state:OdnoklassnikiruState, context:INetworkModuleContext) {
        this.state = state;
        this.context = context;
        this.requester = context.getHttpRequester();
    }

    public function init(handler:IAsyncInitHandler):void {
        ForticomAPI.connection = state.apiconnection;
        ForticomAPI.addEventListener(ForticomAPI.CONNECTED, function (...rest):void {
            handler.onSuccess("ok");
        });
    }

    public function getShortNetworkId():String {
        return "ok";
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


    private static const GENDERS:Object = {0:"m", 1:"f"};

    private function parseProfile(u:Object, ...rest):IProfile {
        var profile:Profile = new Profile();
        profile.userId = u.uid;
        profile.profileUrl = u.url_profile;
        profile.fullName = u.first_name + " " + u.last_name;
        profile.avatarUrl = u.pic_1;
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

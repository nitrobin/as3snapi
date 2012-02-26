package as3snapi.modules.networks.odnoklassnikiru.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.basic.IFeatureRefererId;
import as3snapi.feautures.basic.IFeatureUserId;
import as3snapi.feautures.basic.init.IAsyncInitHandler;
import as3snapi.feautures.basic.init.IFeatureAsyncInit;
import as3snapi.feautures.basic.invites.IFeatureInvitePopup;
import as3snapi.feautures.basic.profiles.IFeatureProfilesBase;
import as3snapi.feautures.basic.profiles.IProfilesHandler;
import as3snapi.feautures.core.requester.IFeatureHttpRequester;
import as3snapi.utils.Md5Utils;

import com.api.forticom.ForticomAPI;

import flash.net.URLRequestMethod;

public class OdnoklassnikiruApiImpl implements IFeatureAsyncInit,
        IFeatureUserId,
        IFeatureRefererId,
        IFeatureInvitePopup,
        IFeatureProfilesBase {
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

    public function getUserId():String {
        return state.logged_user_id;
    }

    public function getRefererId():String {
        return state.referer;
    }

    public function showInvitePopup():void {
        ForticomAPI.showInvite();
    }

    public function getProfilesBase(uids:Array, handler:IProfilesHandler):void {
        requester.doRequestJson(state.api_server + "api/users/getInfo",
                signRequest({
                    uids:uids.join(','),
                    fields:"uid,first_name,last_name,gender,pic_1,pic_2,url_profile"
                }, false, "JSON"),
                URLRequestMethod.GET,
                function (r:Object):void {
                    //TODO
                },
                function (r:Object):void {
                });
    }

    public function getProfilesChunkSize():int {
        return 100;
    }

    public function signRequest(data:Object, exeption:Boolean = false, format:String = "XML"):Object {
        data["format"] = format;
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

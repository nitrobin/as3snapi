package as3snapi.modules.networks.mailru.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.basic.IFeatureAppId;
import as3snapi.feautures.basic.IFeatureNetworkId;
import as3snapi.feautures.basic.IFeatureRefererId;
import as3snapi.feautures.basic.IFeatureUserId;
import as3snapi.feautures.basic.init.IAsyncInitHandler;
import as3snapi.feautures.basic.init.IFeatureAsyncInit;
import as3snapi.feautures.basic.invites.IFeatureInvitePopup;
import as3snapi.feautures.basic.profiles.IFeatureAppFriendsProfiles;
import as3snapi.feautures.basic.profiles.IFeatureFriendsProfiles;
import as3snapi.feautures.basic.profiles.IFeatureProfilesBase;
import as3snapi.feautures.basic.profiles.IProfile;
import as3snapi.feautures.basic.profiles.IProfilesHandler;
import as3snapi.feautures.basic.profiles.Profile;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.feautures.core.javascript.JavaScriptUtils;
import as3snapi.modules.networks.mailru.ConfigMailru;
import as3snapi.modules.networks.mailru.features.EventMailru;
import as3snapi.modules.networks.mailru.features.IFeatureMailruApiCore;

import flash.events.IEventDispatcher;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

/**
 * Реализация mail.ru API
 */
public class MailruApiImpl implements IFeatureMailruApiCore,
        IFeatureNetworkId,
        IFeatureAppId,
        IFeatureUserId,
        IFeatureRefererId,
        IFeatureInvitePopup,
        IFeatureProfilesBase,
        IFeatureAppFriendsProfiles,
        IFeatureFriendsProfiles,
        IFeatureAsyncInit {

    private var state:MailruState;
    private var js:IFeatureJavaScript;
    private var jsUtils:JavaScriptUtils;
    private var events:IEventDispatcher;

    private static const CRITICAL_TIMEOUT:int = 10000;
    private var shortNetworkId:String;

    public function MailruApiImpl(state:MailruState, context:INetworkModuleContext, shortNetworkId:String) {
        this.state = state;
        this.shortNetworkId = shortNetworkId;
        this.js = context.getJavaScript();
        //TODO: Баг флэш плеера или Chromium? js.getObjectId() может возвращать null если флэшка загружена на сервер mail.ru
        var objectId:String = js.getObjectId() || "flash-app";
        this.jsUtils = new JavaScriptUtils(js, objectId);
        this.events = state.context.getEventDispatcher();
    }

    public function init(handler:IAsyncInitHandler):void {
        var config:ConfigMailru = state.getConfig();
        var privateKey:String = config.getPrivateKey();
        var objectId:String = js.getObjectId();
        trace(objectId);
        jsUtils.callSmart("mailru.loader.require", "api", function ():void {
            js.call("mailru.app.init", privateKey);// вероятно лишнее
            jsUtils.callSmart("mailru.events.listen", 'event', jsUtils.permanent(onEvent));
            handler.onSuccess("ok");
        });
    }

    private function onEvent(name:String, data:Object, ...rest):void {
        state.context.eventLog({name:name, data:data});
        events.dispatchEvent(new EventMailru(name, data));
    }

    public function getShortNetworkId():String {
        return shortNetworkId;
    }

    public function getAppId():String {
        return state.appId;
    }

    public function getUserId():String {
        return state.vid;
    }

    public function getRefererId():String {
        return state.oid;
    }

    public function showInvitePopup():void {
        js.call("mailru.app.friends.invite", {text:""});
    }


    public function getProfilesBase(uids:Array, handler:IProfilesHandler):void {
        jsUtils.callSmart("mailru.common.users.getInfo", callback, uids.join(","));
        var i:uint = setTimeout(onTimeout, CRITICAL_TIMEOUT);

        function onTimeout():void {
            handler.onFail("getProfilesBase timeout 10 sec");
            handler = null;
        }

        function callback(r:Object, ...rest):void {
            clearTimeout(i);
            if (handler) {
                var profiles:Array = (r as Array).map(parseProfile, null);
                handler.onSuccess(profiles);
            }
        }
    }

    private static const GENDERS:Object = {0:"m", 1:"f"};

    private function parseProfile(u:Object, ...rest):IProfile {
        var profile:Profile = new Profile();
        profile.userId = u.uid;
        profile.profileUrl = u.link;
        profile.fullName = u.first_name + " " + u.last_name;
        profile.avatar = u.pic;
        profile.photos = [u.pic_small, u.pic, u.pic_big];
        profile.gender = GENDERS[u.sex];
        profile.setRawData(u);
        return profile;
    }


    public function getProfilesChunkSize():int {
        return 100;
    }

    public function getAppFriendsProfiles(handler:IProfilesHandler):void {
        jsUtils.callSmart("mailru.common.friends.getAppUsers", callback);
        var i:uint = setTimeout(onTimeout, CRITICAL_TIMEOUT);

        function onTimeout():void {
            handler.onFail("getAppFriendsProfiles timeout 10 sec");
            handler = null;
        }

        function callback(r:Object, ...rest):void {
            clearTimeout(i);
            if (handler) {
                var profiles:Array = (r as Array).map(parseProfile, null);
                handler.onSuccess(profiles);
            }
        }
    }

    public function getFriendsProfiles(handler:IProfilesHandler):void {
        jsUtils.callSmart("mailru.common.friends.getExtended", callback);
        var i:uint = setTimeout(onTimeout, CRITICAL_TIMEOUT);

        function onTimeout():void {
            handler.onFail("getFriendsProfiles timeout 10 sec");
            handler = null;
        }

        function callback(r:Object, ...rest):void {
            clearTimeout(i);
            if (handler) {
                var profiles:Array = (r as Array).map(parseProfile, null);
                handler.onSuccess(profiles);
            }
        }
    }
}
}

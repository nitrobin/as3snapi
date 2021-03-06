package as3snapi {
import as3snapi.api.INetworkConnectHandler;
import as3snapi.api.feautures.IFeatureEventDispatcher;
import as3snapi.api.feautures.social.IFeatureUserId;
import as3snapi.api.feautures.social.profiles.IFeatureAppFriendsProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureFriendsProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureProfilesBase;
import as3snapi.api.feautures.social.profiles.IFeatureSelfProfile;
import as3snapi.api.feautures.social.uids.IFeatureAppFriendUids;
import as3snapi.api.feautures.social.uids.IFeatureFriendUids;
import as3snapi.base.INetworkConfig;
import as3snapi.base.INetworkModule;
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.IFeatureConfigGetter;
import as3snapi.base.features.asyncinit.AsyncInitHandler;
import as3snapi.base.features.asyncinit.IFeatureAsyncInit;
import as3snapi.base.features.flashvars.FlashVars;
import as3snapi.base.features.flashvars.IFeatureFlashVarsGetter;
import as3snapi.base.features.javascript.FeatureJavaScript;
import as3snapi.base.features.javascript.IFeatureJavaScript;
import as3snapi.base.features.log.FeatureLogNULL;
import as3snapi.base.features.log.IFeatureLog;
import as3snapi.base.features.requester.FeatureHttpRequester;
import as3snapi.base.features.requester.IFeatureHttpRequester;
import as3snapi.base.plugins.BusFactoryEvent;
import as3snapi.utils.EnumUtils;
import as3snapi.utils.bus.IMutableBus;

import flash.utils.clearTimeout;
import flash.utils.setTimeout;

public class ConnectionFactory implements IConnectionFactory {

    private static const CRITICAL_TIMEOUT:int = 60000;

    private var flashVars:FlashVars;
    private var networkModules:Vector.<INetworkModule> = new <INetworkModule>[];
    private var networkConfigs:Vector.<INetworkConfig> = new <INetworkConfig>[];
    private var busFactory:IBusFactory;

    /**
     *
     * @param flashVars объект с параметрами полученными приложением от соцсети
     * @param networkConfigs список настроек для доступных соцсетей
     * @param networkModules спсиок модулей для используемых соцсетей
     * @param busModules список модулей для навешивания дополнительных возможностей на шину
     */
    public function ConnectionFactory(flashVars:* = null, networkConfigs:Vector.<INetworkConfig> = null, networkModules:Vector.<INetworkModule> = null, busFactory:IBusFactory = null) {
        if (flashVars != null) {
            setFlashVars(flashVars);
        }
        if (networkConfigs != null) {
            this.networkConfigs = networkConfigs;
        }
        if (networkModules != null) {
            this.networkModules = networkModules;
        }
        this.busFactory = busFactory || new DefaultBusFactory()
    }

    public function setFlashVars(flashVars:*):void {
        this.flashVars = FlashVars.fromObject(flashVars);
    }

    public function getFlashVars():FlashVars {
        return flashVars;
    }

    public function createConnection(handler:INetworkConnectHandler):void {
        var bus:IMutableBus = busFactory.createBus();
        // Add default features
        bus.addFeatureIfNotExist(IFeatureEventDispatcher, new FeatureEventDispatcher());
        bus.addFeatureIfNotExist(IFeatureLog, new FeatureLogNULL());
        bus.addFeatureIfNotExist(IFeatureFlashVarsGetter, new FeatureFlashVarsGetter(flashVars, bus));
        bus.addFeatureIfNotExist(IFeatureHttpRequester, new FeatureHttpRequester(bus));
        bus.addFeatureIfNotExist(IFeatureJavaScript, new FeatureJavaScript(bus));
        bus.dispatchEvent(new BusFactoryEvent(BusFactoryEvent.BASIC_FEATURES_ADDED));
        // log
        logFlashVars(bus);
        // Detect
        for each(var networkModule:INetworkModule in networkModules) {
            for each(var config:INetworkConfig in networkConfigs) {
                var context:INetworkModuleContext = new NetworkModuleContext(bus, config);
                if (networkModule.isAvailable(context)) {
                    bus.addFeatureIfNotExist(IFeatureConfigGetter, new FeatureConfig(config));
                    doConnect(networkModule, context, handler);
                    return;
                }
            }
        }
        handler.onFail("Detection fail");
    }

    private function doConnect(networkModule:INetworkModule, context:INetworkModuleContext, handler:INetworkConnectHandler):void {
        var bus:IMutableBus = context.getBus();

        // Configure network
        networkModule.install(context);

        // Post configure bus
        // Добавляем IFeatureProfiles на основе IFeatureProfilesBase
        implementProfilesIfNotExist(bus);

        bus.dispatchEvent(new BusFactoryEvent(BusFactoryEvent.SOCIAL_NETWORK_FEATURES_ADDED));

        // Добавляем IFeature*Profiles на основе IFeatureProfiles
        implementHelperProfilesIfNotExist(bus);
        bus.dispatchEvent(new BusFactoryEvent(BusFactoryEvent.FEATURES_READY));

        logFeatures(bus);
        var connection:NetworkConnection = new NetworkConnection(bus, context.getConfig());

        // таймаут
        var timerId:uint = setTimeout(onTimeout, CRITICAL_TIMEOUT);

        function onTimeout():void {
            handler.onFail("Connection timeout");
            handler = null;
        }

        var log:IFeatureLog = bus.getFeature(IFeatureLog);
        if (bus.hasFeature(IFeatureAsyncInit)) {
            log.log("IFeatureAsyncInit#init()...");
            var feature:IFeatureAsyncInit = bus.getFeature(IFeatureAsyncInit);
            feature.init(new AsyncInitHandler(onReady, onFail));
            bus.disable(IFeatureAsyncInit);
        } else {
            onReady();
        }

        function onReady(result:Object = null):void {
            clearTimeout(timerId);
            log.log("Init: ready.");
            if (handler != null) {
                handler.onSuccess(connection);
            }
        }

        function onFail(result:Object):void {
            log.log("Init: fail.");
            clearTimeout(timerId);
            if (handler != null) {
                handler.onFail(result);
            }
        }
    }

    private function logFlashVars(bus:IMutableBus):void {
        var log:IFeatureLog = bus.getFeature(IFeatureLog);
        log.log("FlashVars: " + flashVars);
    }

    private function logFeatures(bus:IMutableBus):void {
        var log:IFeatureLog = bus.getFeature(IFeatureLog);
        var features:Array = [];
        for each(var featureClass:Class in bus.getFeatures()) {
            features.push(EnumUtils.getShortClassName(featureClass));
        }
        features.sort();
        log.log("Features: ");
        log.log(features.join("\n"));
    }


    /**
     * Подключить дополнительные возможности на основе уже подключенных базовых возможностей
     * @param bus
     */
    private function implementProfilesIfNotExist(bus:IMutableBus):void {
        var profilesBase:IFeatureProfilesBase = bus.getFeature(IFeatureProfilesBase);
        if (profilesBase != null && !bus.hasFeature(IFeatureProfiles)) {
            bus.addFeature(IFeatureProfiles, new FeatureProfilesHelper(profilesBase));
            bus.disable(IFeatureProfilesBase);
        }
    }

    /**
     * Подключить дополнительные возможности на основе уже подключенных базовых возможностей
     * @param bus
     */
    private function implementHelperProfilesIfNotExist(bus:IMutableBus):void {
        var profiles:IFeatureProfiles = bus.getFeature(IFeatureProfiles);
        var friendsIds:IFeatureFriendUids = bus.getFeature(IFeatureFriendUids);
        var appFriendsIds:IFeatureAppFriendUids = bus.getFeature(IFeatureAppFriendUids);
        var userId:IFeatureUserId = bus.getFeature(IFeatureUserId);

        if (profiles != null) {
            if (friendsIds) {
                bus.addFeatureIfNotExist(IFeatureFriendsProfiles, new FeatureFriendsProfilesHelper(profiles, friendsIds));
            }
            if (appFriendsIds) {
                bus.addFeatureIfNotExist(IFeatureAppFriendsProfiles, new FeatureAppFriendsProfilesHelper(profiles, appFriendsIds));
            }
            if (userId) {
                bus.addFeatureIfNotExist(IFeatureSelfProfile, new FeatureSelfProfileHelper(profiles, userId));
            }
        }
    }

}
}

import as3snapi.api.INetworkConnection;
import as3snapi.api.feautures.IFeatureEventDispatcher;
import as3snapi.api.feautures.social.IFeatureUserId;
import as3snapi.api.feautures.social.profiles.*;
import as3snapi.api.feautures.social.uids.IFeatureAppFriendUids;
import as3snapi.api.feautures.social.uids.IFeatureFriendUids;
import as3snapi.api.feautures.social.uids.IdsHandler;
import as3snapi.base.INetworkConfig;
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.IFeatureConfigGetter;
import as3snapi.base.features.flashvars.FlashVars;
import as3snapi.base.features.flashvars.IFeatureFlashVarsGetter;
import as3snapi.base.features.javascript.IFeatureJavaScript;
import as3snapi.base.features.javascript.JavaScriptUtils;
import as3snapi.base.features.log.FeatureLogTrace;
import as3snapi.base.features.log.IFeatureLog;
import as3snapi.base.features.requester.IFeatureHttpRequester;
import as3snapi.utils.bus.IBus;
import as3snapi.utils.bus.IMutableBus;

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

internal class FeatureConfig implements IFeatureConfigGetter {
    private var config:INetworkConfig;

    public function FeatureConfig(config:INetworkConfig) {
        this.config = config;
    }

    public function getConfig():INetworkConfig {
        return config;
    }
}

internal class FeatureFlashVarsGetter implements IFeatureFlashVarsGetter {
    private var flashVars:FlashVars;

    public function FeatureFlashVarsGetter(flashVars:FlashVars, bus:IMutableBus) {
        this.flashVars = flashVars;
    }

    public function getFlashVars():FlashVars {
        return flashVars;
    }
}

internal class FeatureEventDispatcher extends EventDispatcher implements IFeatureEventDispatcher {
}

//-- profiles


internal class FeatureProfilesHelper implements IFeatureProfiles {
    private var profilesBase:IFeatureProfilesBase;

    public function FeatureProfilesHelper(profilesBase:IFeatureProfilesBase) {
        this.profilesBase = profilesBase;
    }

    public function getProfiles(uids:Array, handler:IProfilesHandler):void {
        var profilesChunkSize:int = profilesBase.getProfilesChunkSize();
        var resultProfiles:Array = [];
        nextRequest();

        function nextRequest():void {
            if (uids == null || uids.length <= 0) {
                handler.onSuccess(resultProfiles);
            } else {
                var uidsPart:Array = uids.splice(0, profilesChunkSize);
                profilesBase.getProfilesBase(uidsPart, new ProfilesHandler(function (profiles:Array):void {
                    resultProfiles = resultProfiles.concat(profiles);
                    nextRequest()
                }, function (result:Object):void {
                    handler.onFail(result);
                }));

            }
        }
    }
}

internal class FeatureAppFriendsProfilesHelper implements IFeatureAppFriendsProfiles {
    private var profiles:IFeatureProfiles;
    private var ids:IFeatureAppFriendUids;

    public function FeatureAppFriendsProfilesHelper(profiles:IFeatureProfiles, ids:IFeatureAppFriendUids) {
        this.profiles = profiles;
        this.ids = ids;
    }

    public function getAppFriendsProfiles(handler:IProfilesHandler):void {
        ids.getAppFriendUids(
                new IdsHandler(function (uids:Array):void {
                    profiles.getProfiles(uids, handler);
                }, function (result:Object):void {
                    handler.onFail(result);
                }));
    }
}

internal class FeatureFriendsProfilesHelper implements IFeatureFriendsProfiles {
    private var profiles:IFeatureProfiles;
    private var ids:IFeatureFriendUids;

    public function FeatureFriendsProfilesHelper(profiles:IFeatureProfiles, ids:IFeatureFriendUids) {
        this.profiles = profiles;
        this.ids = ids;
    }

    public function getFriendsProfiles(handler:IProfilesHandler):void {
        ids.getFriendUids(
                new IdsHandler(function (uids:Array):void {
                    profiles.getProfiles(uids, handler);
                }, function (result:Object):void {
                    handler.onFail(result);
                }));
    }
}

internal class FeatureSelfProfileHelper implements IFeatureSelfProfile {
    private var profiles:IFeatureProfiles;
    private var userId:IFeatureUserId;

    public function FeatureSelfProfileHelper(profiles:IFeatureProfiles, userId:IFeatureUserId) {
        this.profiles = profiles;
        this.userId = userId;
    }

    public function getSelfProfile(handler:IOneProfileHandler):void {
        profiles.getProfiles([userId.getUserId()],
                new ProfilesHandler(function (profiles:Array):void {
                    handler.onSuccess(profiles[0]);
                }, function (result:Object):void {
                    handler.onFail(result);
                }));
    }
}

internal class NetworkConnection implements INetworkConnection {
    private var bus:IBus;
    private var config:INetworkConfig;

    public function NetworkConnection(bus:IBus, config:INetworkConfig) {
        this.bus = bus;
        this.config = config;
    }

    public function getBus():IBus {
        return bus;
    }

    public function getConfig():INetworkConfig {
        return config;
    }

    public function getFeature(featureClass:Class):* {
        return bus.getFeature(featureClass);
    }

    public function hasFeature(featureClass:Class):Boolean {
        return bus.hasFeature(featureClass);
    }
}

internal class NetworkModuleContext implements INetworkModuleContext {
    private var bus:IMutableBus;
    private var config:INetworkConfig;
    private var fFlashVarsGetter:IFeatureFlashVarsGetter;
    private var fLog:IFeatureLog;
    private var fHttpRequester:IFeatureHttpRequester;
    private var fJavaScript:IFeatureJavaScript;
    private var fEventDispatcher:IFeatureEventDispatcher;
    private var jsUtils:JavaScriptUtils;


    public function NetworkModuleContext(bus:IMutableBus, config:INetworkConfig) {
        this.bus = bus;
        this.config = config;
        this.fFlashVarsGetter = bus.getFeature(IFeatureFlashVarsGetter);
        this.fLog = bus.getFeature(IFeatureLog);
        this.fHttpRequester = bus.getFeature(IFeatureHttpRequester);
        this.fJavaScript = bus.getFeature(IFeatureJavaScript);
        this.fEventDispatcher = bus.getFeature(IFeatureEventDispatcher);
    }

    public function getBus():IMutableBus {
        return bus;
    }

    public function getConfig():INetworkConfig {
        return config;
    }

    public function getFlashVars():FlashVars {
        return fFlashVarsGetter ? fFlashVarsGetter.getFlashVars() : new FlashVars(null);
    }

    public function getLog():IFeatureLog {
        return fLog;
    }

    public function getHttpRequester():IFeatureHttpRequester {
        return fHttpRequester;
    }

    public function getJavaScript():IFeatureJavaScript {
        return fJavaScript;
    }

    public function getEventDispatcher():IEventDispatcher {
        return fEventDispatcher;
    }

    public function log(msg:*):void {
        fLog.log(msg);
    }

    public function apiLog(msg:*):void {
        fLog.apiLog("API: " + FeatureLogTrace.universalDump(msg));
    }

    public function eventLog(msg:*):void {
        fLog.eventLog("EVENT: " + FeatureLogTrace.universalDump(msg));
    }

    public function getJavaScriptUtils():JavaScriptUtils {
        if (jsUtils == null) {
            jsUtils = new JavaScriptUtils(fJavaScript);
        }
        return jsUtils;
    }
}
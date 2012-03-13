package as3snapi {
import as3snapi.bus.BusImpl;
import as3snapi.bus.IMutableBus;
import as3snapi.core.BusFactoryEvent;
import as3snapi.core.IBusModule;
import as3snapi.core.INetworkConfig;
import as3snapi.core.INetworkConnectHandler;
import as3snapi.core.INetworkModule;
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.basic.IFeatureConfigGetter;
import as3snapi.feautures.basic.IFeatureUserId;
import as3snapi.feautures.basic.init.AsyncInitHandler;
import as3snapi.feautures.basic.init.IAsyncInitHandler;
import as3snapi.feautures.basic.init.IFeatureAsyncInit;
import as3snapi.feautures.basic.profiles.IFeatureAppFriendsProfiles;
import as3snapi.feautures.basic.profiles.IFeatureFriendsProfiles;
import as3snapi.feautures.basic.profiles.IFeatureProfiles;
import as3snapi.feautures.basic.profiles.IFeatureProfilesBase;
import as3snapi.feautures.basic.profiles.IFeatureSelfProfile;
import as3snapi.feautures.basic.uids.IFeatureAppFriendUids;
import as3snapi.feautures.basic.uids.IFeatureFriendUids;
import as3snapi.feautures.core.event.IFeatureEventDispatcher;
import as3snapi.feautures.core.flashvars.FlashVars;
import as3snapi.feautures.core.flashvars.IFeatureFlashVarsGetter;
import as3snapi.feautures.core.javascript.FeatureJavaScript;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.feautures.core.log.FeatureLogNULL;
import as3snapi.feautures.core.log.IFeatureLog;
import as3snapi.feautures.core.requester.FeatureHttpRequester;
import as3snapi.feautures.core.requester.IFeatureHttpRequester;
import as3snapi.utils.EnumUtils;

public class ConnectionFactory implements IConnectionFactory {

    private var flashVars:FlashVars;
    private var networkModules:Vector.<INetworkModule> = new <INetworkModule>[];
    private var networkConfigs:Vector.<INetworkConfig> = new <INetworkConfig>[];
    private var busModules:Vector.<IBusModule> = new <IBusModule>[];


    /**
     *
     * @param flashVars объект с параметрами полученными приложением от соцсети
     * @param networkConfigs список настроек для доступных соцсетей
     * @param networkModules спсиок модулей для используемых соцсетей
     * @param busModules список модулей для навешивания дополнительных возможностей на шину
     */
    public function ConnectionFactory(flashVars:* = null, networkConfigs:Vector.<INetworkConfig> = null, networkModules:Vector.<INetworkModule> = null, busModules:Vector.<IBusModule> = null) {
        if (flashVars != null) {
            setFlashVars(flashVars);
        }
        if (networkConfigs != null) {
            for each(var config:INetworkConfig in networkConfigs) {
                installNetworkConfig(config);
            }
        }
        if (networkModules != null) {
            for each(var module:INetworkModule in networkModules) {
                installNetworkModule(module);
            }
        }
        if (busModules != null) {
            for each(var busModule:IBusModule in busModules) {
                installBusModule(busModule);
            }
        }
    }

    public function setFlashVars(flashVars:*):void {
        this.flashVars = FlashVars.fromObject(flashVars);
    }

    public function getFlashVars():FlashVars {
        return flashVars;
    }

    public function installBusModule(busModule:IBusModule):void {
        busModules.push(busModule);
    }

    public function installNetworkModule(networkModule:INetworkModule):void {
        networkModules.push(networkModule);
    }

    public function installNetworkConfig(config:INetworkConfig):void {
        networkConfigs.push(config);
    }


    public function createConnection(handler:INetworkConnectHandler):void {
        var bus:IMutableBus = new BusImpl();

        // Pre configure  bus
        var busModue:IBusModule;
        for each (busModue in busModules) {
            busModue.install(bus);
        }

        // Add default features
        bus.addFeatureIfNotExist(IFeatureEventDispatcher, new FeatureEventDispatcher());
        bus.addFeatureIfNotExist(IFeatureLog, new FeatureLogNULL());
        bus.addFeatureIfNotExist(IFeatureFlashVarsGetter, new FeatureFlashVarsGetter(flashVars, bus));
        bus.addFeatureIfNotExist(IFeatureHttpRequester, new FeatureHttpRequester(bus));
        bus.addFeatureIfNotExist(IFeatureJavaScript, new FeatureJavaScript(bus));

        logFlashVars(bus);

        bus.dispatchEvent(new BusFactoryEvent(BusFactoryEvent.BASIC_FEATURES_ADDED));

        // Detect
        for each(var config:INetworkConfig in networkConfigs) {
            for each(var networkModule:INetworkModule in networkModules) {
                var context:INetworkModuleContext = new NetworkModuleContext(bus, config);
                if (networkModule.isAvailable(context)) {
                    bus.addFeatureIfNotExist(IFeatureConfigGetter, new FeatureConfig(config));
                    doConnect(networkModule, context, handler);
                    return;
                }
            }
        }
        handler.onFail("");
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

        //TODO Возможно стоит избавиться от кастинга
        var log:IFeatureLog = bus.getFeature(IFeatureLog);
        if (bus.hasFeature(IFeatureAsyncInit)) {
            log.log("Init: AsyncInit.init()...");
            //TODO: таймаут
            var initHandler:IAsyncInitHandler = new AsyncInitHandler(function (result:Object):void {
                log.log("Init: ready.");
                handler.onSuccess(connection);
            }, function (result:Object):void {
                handler.onFail(result);
            });
            var feature:IFeatureAsyncInit = bus.getFeature(IFeatureAsyncInit);
            feature.init(initHandler);
            bus.disable(IFeatureAsyncInit);
        } else {
            log.log("Init: ready.");
            handler.onSuccess(connection);
        }
    }

    private function logFlashVars(bus:IMutableBus):void {
        var log:IFeatureLog = bus.getFeature(IFeatureLog);
        log.log("FLASHVARS: ");
        log.log("" + flashVars);
    }

    private function logFeatures(bus:IMutableBus):void {
        var log:IFeatureLog = bus.getFeature(IFeatureLog);
        var features:Array = [];
        for each(var featureClass:Class in bus.getFeatures()) {
            features.push(EnumUtils.getShortClassName(featureClass));
        }
        features.sort();
        log.log("FEATURES: ");
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

import as3snapi.bus.IBus;
import as3snapi.bus.IMutableBus;
import as3snapi.core.INetworkConfig;
import as3snapi.core.INetworkConnection;
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.basic.IFeatureConfigGetter;
import as3snapi.feautures.basic.IFeatureUserId;
import as3snapi.feautures.basic.profiles.*;
import as3snapi.feautures.basic.uids.IFeatureAppFriendUids;
import as3snapi.feautures.basic.uids.IFeatureFriendUids;
import as3snapi.feautures.basic.uids.IdsHandler;
import as3snapi.feautures.core.event.IFeatureEventDispatcher;
import as3snapi.feautures.core.flashvars.FlashVars;
import as3snapi.feautures.core.flashvars.IFeatureFlashVarsGetter;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.feautures.core.javascript.JavaScriptUtils;
import as3snapi.feautures.core.log.FeatureLogTrace;
import as3snapi.feautures.core.log.IFeatureLog;
import as3snapi.feautures.core.requester.IFeatureHttpRequester;

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
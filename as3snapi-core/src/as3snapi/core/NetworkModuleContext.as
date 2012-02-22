package as3snapi.core {
import as3snapi.bus.IMutableBus;
import as3snapi.feautures.core.event.IFeatureEventDispatcher;
import as3snapi.feautures.core.flashvars.FlashVars;
import as3snapi.feautures.core.flashvars.IFeatureFlashVarsGetter;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.feautures.core.log.FeatureLogTrace;
import as3snapi.feautures.core.log.IFeatureLog;
import as3snapi.feautures.core.requester.IFeatureHttpRequester;

import flash.events.IEventDispatcher;

public class NetworkModuleContext implements INetworkModuleContext {
    private var bus:IMutableBus;
    private var config:INetworkConfig;
    private var fFlashVarsGetter:IFeatureFlashVarsGetter;
    private var fLog:IFeatureLog;
    private var fHttpRequester:IFeatureHttpRequester;
    private var fJavaScript:IFeatureJavaScript;
    private var fEventDispatcher:IFeatureEventDispatcher;


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
}
}

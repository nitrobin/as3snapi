package as3snapi.base {
import as3snapi.base.features.flashvars.FlashVars;
import as3snapi.base.features.javascript.IFeatureJavaScript;
import as3snapi.base.features.javascript.JavaScriptUtils;
import as3snapi.base.features.log.IFeatureLog;
import as3snapi.base.features.requester.IFeatureHttpRequester;
import as3snapi.utils.bus.IMutableBus;

import flash.events.IEventDispatcher;

/**
 * Контекст для модуля соцсети.
 */
public interface INetworkModuleContext {

    function getBus():IMutableBus;

    function getConfig():INetworkConfig;

    function getFlashVars():FlashVars;

    function getLog():IFeatureLog;

    function getHttpRequester():IFeatureHttpRequester;

    function getJavaScript():IFeatureJavaScript;

    function log(msg:*):void;

    function getEventDispatcher():IEventDispatcher;

    function apiLog(msg:*):void;

    function eventLog(msg:*):void;

    function getJavaScriptUtils():JavaScriptUtils;
}
}

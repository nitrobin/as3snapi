package as3snapi.core {
import as3snapi.bus.IMutableBus;
import as3snapi.feautures.core.flashvars.FlashVars;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.feautures.core.log.IFeatureLog;
import as3snapi.feautures.core.requester.IFeatureHttpRequester;

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
}
}

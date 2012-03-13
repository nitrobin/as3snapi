package as3snapi.networks.vkcom.impl {
import as3snapi.base.INetworkModuleContext;
import as3snapi.networks.vkcom.features.*;

import flash.events.IEventDispatcher;
import flash.events.StatusEvent;
import flash.net.LocalConnection;
import flash.utils.setTimeout;

/**
 * LocalConnection драйвер дря работы с VK API. На основе APIConnection {@link:http://vkontakte.ru/source/APIConnection.zip}
 * {@link:http://vk.com/developers.php?oid=-1&p=Flash-%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D1%8F}
 *
 */
public class VkcomDriverLC implements IFeatureVkcomMethods, IFeatureVkcomRequester {
    private var context:INetworkModuleContext;
    private var dispatcher:IEventDispatcher;

    private var sendingLC:LocalConnection;
    private var receivingLC:LocalConnection;
    private var state:VkcomState;


    private var pendingRequests:Array = [];
    private var loaded:Boolean = false;
    private var apiCallId:Number = 0;
    private var apiCalls:Object = new Object();
    private var connectionName:String;


    public function VkcomDriverLC(state:VkcomState, context:INetworkModuleContext) {
        this.state = state;
        this.context = context;
        this.dispatcher = context.getEventDispatcher();
        this.connectionName = state.lc_name;
    }

    public function init(onInit:Function):void {
        sendingLC = new LocalConnection();
        sendingLC.allowDomain('*');

        receivingLC = new LocalConnection();
        receivingLC.allowDomain('*');
        receivingLC.client = {
            initConnection:initConnection,
            apiCallback:apiCallback,
            customEvent:customEvent
        };

        event("onBalanceChanged");
        event("onSettingsChanged");
        event("onLocationChanged");
        event("onWindowResized");
        event("onApplicationAdded");
        event("onWindowBlur");
        event("onWindowFocus");
        event("onWallPostSave");
        event("onWallPostCancel");
        event("onProfilePhotoSave");
        event("onProfilePhotoCancel");
        event("onMerchantPaymentSuccess");
        event("onMerchantPaymentCancel");
        event("onMerchantPaymentFail");

        try {
            receivingLC.connect("_out_" + connectionName);
        } catch (error:ArgumentError) {
            context.apiLog("Can't connect from App. The connection name is already being used by another SWF");
        }
        sendingLC.addEventListener(StatusEvent.STATUS, onInitStatus);
        sendingLC.send("_in_" + connectionName, "initConnection");

        // internal functions

        function event(event:String):void {
            receivingLC.client[event] = function (...params):void {
                context.eventLog({event:event, params:params});
                dispatcher.dispatchEvent(new EventVkcom(event, params));
            }
        }

        function onInitStatus(e:StatusEvent):void {
            context.apiLog("StatusEvent: " + e.level);
            sendingLC.removeEventListener(StatusEvent.STATUS, onInitStatus);
            if (e.level == "status") {
                initConnection();
            }
        }

        function initConnection():void {
            if (!loaded) {
                loaded = true;
                context.apiLog("Connection initialized.");
                onInit();
                sendPendingRequests();
            }
        }
    }


    public function apiCall(method:String, params:Object, onSuccess:Function, onFail:Function):void {
        var callId:Number = apiCallId++;
        apiCalls[callId] = function (result:Object):void {
            // TODO: вынести setTimeout
            if (("error" in result) && (result.error.error_code == 6)) {
                setTimeout(apiCall, 500, method, params, onSuccess, onFail);
                return;
            }
            context.apiLog({method:method, params:params, result:result});
            if (result.error) {
                onFail(result);
            } else {
                onSuccess(result);
            }
        }
        sendData("api", callId, method, params);
    }


    public function navigateToURL(url:String, window:String = "_self"):void {
        this.callMethod("navigateToURL", url, window);
    }


    public function callMethod(method:String, ...rest):void {
        sendData.apply(this, ["callMethod", method].concat(rest));
    }


    private function customEvent(event:String, ...params):void {
        context.eventLog({event:event, params:params});
        dispatcher.dispatchEvent(new EventVkcom(event, params));
    }

    private function apiCallback(callId:Number, data:Object):void {
        apiCalls[callId](data);
        delete apiCalls[callId];
    }


    private function sendPendingRequests():void {
        while (pendingRequests.length) {
            sendData.apply(this, pendingRequests.shift());
        }
    }

    private function sendData(...params):void {
        var paramsArr:Array = params as Array;
        if (loaded) {
            paramsArr.unshift("_in_" + connectionName);
            sendingLC.send.apply(null, paramsArr);
        } else {
            pendingRequests.push(paramsArr);
        }
    }
}
}

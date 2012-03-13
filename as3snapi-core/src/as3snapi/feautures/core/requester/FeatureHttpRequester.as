package as3snapi.feautures.core.requester {
import as3snapi.bus.IMutableBus;
import as3snapi.utils.JsonUtils;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

public class FeatureHttpRequester implements IFeatureHttpRequester {
    public function FeatureHttpRequester(bus:IMutableBus) {

    }

    public function doRequest(url:String, params:Object, method:String, dataFormat:String, onSuccess:Function, onFail:Function):void {
        var request:URLRequest = new URLRequest(url);
        request.method = method || URLRequestMethod.GET;
        var variables:URLVariables = new URLVariables();
        for (var key:String in params) {
            variables[key] = params[key];
        }
        request.data = variables;
        var loader:URLLoader = new URLLoader();
        loader.dataFormat = dataFormat || URLLoaderDataFormat.TEXT;
        loader.addEventListener(Event.COMPLETE, function (e:Event):void {
            var data:String = String(loader.data);
            onSuccess(data);
        });
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
        loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
        loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onError);
        loader.addEventListener(IOErrorEvent.DISK_ERROR, onError);
        function onError(e:Event):void {
            onFail(e);
        }

        try {
            loader.load(request);
        } catch (error:Error) {
            onFail(error);
        }
    }

    public function doRequestJson(url:String, params:Object, method:String, onSuccess:Function, onFail:Function):void {
        doRequest(url, params, method, URLLoaderDataFormat.TEXT, onSuccess1, onFail);
        function onSuccess1(data:String):void {
            var decode:Object = JsonUtils.decode(data);
            onSuccess(decode);
        }
    }
}
}
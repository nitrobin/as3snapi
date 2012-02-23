package as3snapi.feautures.core.javascript {
import as3snapi.bus.IMutableBus;

import flash.external.ExternalInterface;
import flash.system.Security;

/**
 * Класс обертка над ExternalInterface. Удобен для отладки js вызовов.
 */
public class FeatureJavaScript implements IFeatureJavaScript {
    private var bus:IMutableBus;

    public function FeatureJavaScript(bus:IMutableBus) {
        this.bus = bus;
        Security.allowDomain("*");
    }

    public function isAvailable():Boolean {
        return ExternalInterface.available;
    }

    public function getObjectId():String {
        return ExternalInterface.objectID;
    }

    public function call(functionName:String, ...rest):* {
        for each (var p:* in rest) {
            if (p is Function) {
                throw new Error("Function is not valid parameter type. Use 'JavascriptUtils.callSmart' instead.")
            }
        }
        ///var log:IFeatureLog = bus.getFeature(IFeatureLog)
        //log.log("call:" + functionName)
        var params:Array = rest.slice();
        params.unshift(functionName);
        return ExternalInterface.call.apply(null, params);
    }

    public function addCallback(functionName:String, closure:Function):void {
        ExternalInterface.addCallback(functionName, closure);
    }
}
}

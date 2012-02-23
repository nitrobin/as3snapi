package as3snapi.modules.networks.vkcom.impl {
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.core.javascript.IFeatureJavaScript;
import as3snapi.modules.networks.vkcom.features.*;

public class VkcomMethodsJs implements IFeatureVkcomMethods {
    private var context:INetworkModuleContext;
    private var js:IFeatureJavaScript;

    public function VkcomMethodsJs(state:VkcomState) {
        this.context = state.context;
        this.js = state.context.getJavaScript();
    }

    public function callMethod(method:String, ...rest):void {
        var a:Array = ["VK.callMethod", method].concat(rest);
        js.call.apply(null, a);
    }
}
}

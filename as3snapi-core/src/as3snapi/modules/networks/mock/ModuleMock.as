package as3snapi.modules.networks.mock {
import as3snapi.bus.IMutableBus;
import as3snapi.core.INetworkModule;
import as3snapi.core.INetworkModuleContext;
import as3snapi.feautures.FeaturesHelper;
import as3snapi.feautures.core.flashvars.FlashVars;
import as3snapi.modules.networks.mock.features.IFeatureMockApi;
import as3snapi.modules.networks.mock.impl.MockApiImpl;

/**
 * Модуль поддержки API vk.com
 */
public class ModuleMock implements INetworkModule {
    public static const SHORT_NETWORK_ID:String = "mock";

    private var shortNetworkId:String;

    public function ModuleMock(shortNetworkId:String = null) {
        this.shortNetworkId = shortNetworkId || SHORT_NETWORK_ID;
    }


    public function isAvailable(context:INetworkModuleContext):Boolean {
        var flashVars:FlashVars = context.getFlashVars();
        return flashVars.isEmpty() && (context.getConfig() is ConfigMock);
    }

    public function install(context:INetworkModuleContext):void {
        var bus:IMutableBus = context.getBus();

        var api:MockApiImpl = new MockApiImpl(context, shortNetworkId);
        bus.addFeature(IFeatureMockApi, api);
        FeaturesHelper.installBasicFeatures(bus, api);
    }
}
}

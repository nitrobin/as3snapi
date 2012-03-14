package as3snapi.networks.mock {
import as3snapi.api.feautures.social.SocialFeaturesInstallHelper;
import as3snapi.base.INetworkModule;
import as3snapi.base.INetworkModuleContext;
import as3snapi.base.features.asyncinit.IFeatureAsyncInit;
import as3snapi.base.features.flashvars.FlashVars;
import as3snapi.networks.mock.features.IFeatureMockApi;
import as3snapi.networks.mock.impl.MockApiImpl;
import as3snapi.utils.bus.IMutableBus;

/**
 * Модуль поддержки API vk.com
 */
public class ModuleMock implements INetworkModule {

    public function ModuleMock() {
    }

    public function isAvailable(context:INetworkModuleContext):Boolean {
        var flashVars:FlashVars = context.getFlashVars();
        return flashVars.isEmpty() && (context.getConfig() is ConfigMock);
    }

    public function install(context:INetworkModuleContext):void {
        var bus:IMutableBus = context.getBus();

        var api:MockApiImpl = new MockApiImpl(context);
        bus.addFeature(IFeatureMockApi, api);
        SocialFeaturesInstallHelper.installBasicFeatures(bus, api);
        bus.addFeature(IFeatureAsyncInit, api);
    }
}
}

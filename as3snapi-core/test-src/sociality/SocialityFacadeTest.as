package as3snapi {
import as3snapi.ISocialityConnection;
import as3snapi.base.INetworkModule;
import as3snapi.base.INetworkModuleContext;
import as3snapi.api.INetworkConnectHandler;
import as3snapi.api.INetworkConnection;
import as3snapi.base.features.flashvars.FlashVars;

import flash.events.Event;

//[Test]
public class SocialityFacadeTest {

//    [Before(async, timeout=5000)]
    public function prepareMockolates():void {
        Async.proceedOnEvent(this,
                prepare(INetworkConfig, INetworkModule, INetworkConnectHandler),
                Event.COMPLETE);
    }

    [Test]
    public function testStub():void {

    }

//    [Test]
    public function testFacadeSuccess():void {
        var facade:IConnectionFactory = new ConnectionFactory();
        var config:INetworkConfig = nice(INetworkConfig);
        var module:INetworkModule = nice(INetworkModule);
        var handler:INetworkConnectHandler = nice(INetworkConnectHandler);

        mock(module).method("check").returns(true);

        facade.installNetworkConfig(config);
        facade.installNetworkModule(module);

        // FlashVars test

        assertEquals(facade.getFlashVars(), null);
        var flashVars:FlashVars = new FlashVars({"test":"test"});
        facade.setFlashVars(flashVars);
        assertEquals(facade.getFlashVars(), flashVars);

        // Connect test

        facade.createConnection(handler);

        // Methods check

        assertThat(module, received().method('check').args(instanceOf(INetworkModuleContext)).once());
        assertThat(module, received().method('configure').args(instanceOf(INetworkModuleContext)).once());

        assertThat(handler, received().method('onSuccess').args(facade, instanceOf(INetworkConnection)).once());
        assertThat(handler, received().method('onFail').never());
    }

//    [Test]
    public function testFacadeFail():void {
        var facade:IConnectionFactory = new ConnectionFactory();
        var config:INetworkConfig = nice(INetworkConfig);
        var module:INetworkModule = nice(INetworkModule);
        var handler:INetworkConnectHandler = nice(INetworkConnectHandler);

        mock(module).method("check").returns(false);

        facade.installNetworkConfig(config);
        facade.installNetworkModule(module);

        // FlashVars test

        assertEquals(facade.getFlashVars(), null);
        var flashVars:FlashVars = new FlashVars({"test":"test"});
        facade.setFlashVars(flashVars);
        assertEquals(facade.getFlashVars(), flashVars);

        // Connect test

        facade.createConnection(handler);

        // Methods check

        assertThat(module, received().method('check').args(instanceOf(INetworkModuleContext)).once());
        assertThat(module, received().method('configure').args(instanceOf(INetworkModuleContext)).never());

        assertThat(handler, received().method('onSuccess').never());
        assertThat(handler, received().method('onFail').args(facade, anything()).once());
    }
}
}

package {
import as3snapi.ConnectionFactory;
import as3snapi.IConnectionFactory;
import as3snapi.api.INetworkConnection;
import as3snapi.api.NetworkConnectHandler;
import as3snapi.api.feautures.social.profiles.IFeatureSelfProfile;
import as3snapi.api.feautures.social.profiles.IProfile;
import as3snapi.api.feautures.social.profiles.OneProfileHandler;
import as3snapi.base.INetworkConfig;
import as3snapi.base.INetworkModule;
import as3snapi.base.plugins.IBusModule;
import as3snapi.base.plugins.logs.BusModuleLogTrace;
import as3snapi.networks.mock.ConfigMock;
import as3snapi.networks.mock.ModuleMock;
import as3snapi.networks.vkcom.ConfigVkcom;
import as3snapi.networks.vkcom.ModuleVkcom;
import as3snapi.utils.JsonUtils;

import flash.display.Sprite;
import flash.text.TextField;

// HelloWorld.as
public class HelloWorld extends Sprite {
    private var tf:TextField = new TextField();

    public function HelloWorld() {
        tf.width = 500;
        tf.height = 500;
        tf.wordWrap = true;
        addChild(tf);

        // Подключение и настройка требуемых соцсетей
        var factory:IConnectionFactory = new ConnectionFactory(
                stage.loaderInfo.parameters, // Передача FlashVars
                new <INetworkConfig>[ // Настройки соцсетей
                    new ConfigVkcom(),
                    new ConfigMock().setData(MOCK_DATA), // Указываем снимок данных
                ],
                new <INetworkModule>[ // Подключение модулей соцсетей
                    new ModuleVkcom(),
                    new ModuleMock(),
                ],
                new <IBusModule>[ // Подключение дополнительных модуле
                    new BusModuleLogTrace() // Включаем выдачу внутренних логов через trace
                ]
        );

        // Подключаемся к API
        factory.createConnection(new NetworkConnectHandler(onSuccess, onFail));

        function onFail(result:Object):void {
            trace("FAIL");// Неудача
        }

        function onSuccess(connection:INetworkConnection):void {
            trace("READY");// API готово
            // Получаем фичу для загрузки своего профиля
            var feature:IFeatureSelfProfile = connection.getFeature(IFeatureSelfProfile)
            if (feature != null) {
                // фича доступна, загружаем профиль
                feature.getSelfProfile(
                        new OneProfileHandler(function (profile:IProfile):void {
                            // Обрабатываем полученный профиль
                            tf.text = "Hello, " + profile.getFullName() + "!\n" +
                                    "Your profile: " + JsonUtils.encode(profile);
                        }, function (result:Object):void {
                            // Ошибка при получении профиля
                            trace("FAIL: " + JsonUtils.encode(result));
                        }));
            } else {
                // фича недоступна.. :(
                trace("IFeatureSelfProfile - UNSUPPORTED");
            }
        }
    }

    // Фиксированные данные для выдачи через Mock API
    private static const MOCK_DATA:Object = {
        shortNetworkId:"mock",
        userId:1,
        inviterId:2,
        appId:123,
        profiles:{1:{fullName:"Jimmy"}, 2:{fullName:"Pavel"}, 3:{fullName:"Mark"}},
        appFriendsUids:[2],
        friendsUids:[2, 3]
    };
}
}

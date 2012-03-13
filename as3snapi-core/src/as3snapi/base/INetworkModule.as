package as3snapi.base {
/**
 * Интерфейс модуль подключения API конкретной соцсети
 */
public interface INetworkModule {
    /**
     * Поддержка API доступна
     * @param context
     * @return
     */
    function isAvailable(context:INetworkModuleContext):Boolean;

    /**
     * Активация поддержки API
     * @param context
     */
    function install(context:INetworkModuleContext):void;
}
}

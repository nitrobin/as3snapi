package as3snapi.core {
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

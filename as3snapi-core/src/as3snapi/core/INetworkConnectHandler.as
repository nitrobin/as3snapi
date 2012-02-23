package as3snapi.core {
/**
 * Обработчик создания нового подключения к соцсети
 * @see IConnectionFactory, INetworkConnection
 */
public interface INetworkConnectHandler {
    function onSuccess(connection:INetworkConnection):void;

    function onFail(result:Object):void;
}
}

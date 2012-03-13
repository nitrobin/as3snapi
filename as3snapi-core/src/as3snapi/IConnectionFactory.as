package as3snapi {
import as3snapi.api.INetworkConnectHandler;

/**
 * Фасадный интерфейс для as3snapi
 */
public interface IConnectionFactory {

    /**
     * Создать подключение к соцсети.
     * @param handler
     */
    function createConnection(handler:INetworkConnectHandler):void;

}
}

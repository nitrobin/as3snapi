package as3snapi {
import as3snapi.core.ISocialityConnectHandler;

/**
 * Фасадный интерфейс для as3snapi
 */
public interface IConnectionFactory {

    function createConnection(handler:ISocialityConnectHandler):void;

}
}

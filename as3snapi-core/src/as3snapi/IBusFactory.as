/**
 * @author nitrobin
 */
package as3snapi {
import as3snapi.utils.bus.IMutableBus;

public interface IBusFactory {
    function createBus():IMutableBus;
}
}

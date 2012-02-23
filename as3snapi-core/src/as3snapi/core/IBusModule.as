package as3snapi.core {
import as3snapi.bus.IMutableBus;

/**
 * Модуль для навешивания на шину дополнительных функций, либо замены уже подключенных
 * @see IMutableBus, BusEvent
 */
public interface IBusModule {

    /**
     * Подключить новые функции к шине
     * @param bus
     */
    function install(bus:IMutableBus):void;

}
}

package as3snapi.core {
public interface INetworkConfig {
    function hasValue(key:String):Boolean;

    function getValue(key:String):*;

    /**
     * Привязка дополнительных данных к конфигу сети.
     * @param key
     * @param value
     * @return
     */
    function setValue(key:String, value:*):INetworkConfig;
}
}

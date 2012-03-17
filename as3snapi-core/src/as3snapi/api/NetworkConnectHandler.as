/**
 * @author nitrobin
 */
package as3snapi.api {
public class NetworkConnectHandler implements INetworkConnectHandler {
    private var _onSuccess:Function;
    private var _onFail:Function;

    public function NetworkConnectHandler(_onSuccess:Function = null, _onFail:Function = null) {
        this._onSuccess = _onSuccess;
        this._onFail = _onFail;
    }

    public function onSuccess(connection:INetworkConnection):void {
        if (_onSuccess != null)_onSuccess(connection)
    }

    public function onFail(result:Object):void {
        if (_onFail != null)_onFail(result);
    }
}
}

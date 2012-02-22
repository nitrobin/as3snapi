/**
 * @author nitrobin
 */
package as3snapi.feautures.basic.init {

public class AsyncInitHandler implements IAsyncInitHandler {
    private var _onSuccess:Function;
    private var _onFail:Function;

    public function AsyncInitHandler(onSuccess:Function, onFail:Function) {
        this._onSuccess = onSuccess;
        this._onFail = onFail;
    }

    public function onSuccess(result:Object):void {
        _onSuccess(result);
    }

    public function onFail(result:Object):void {
        _onFail(result);
    }
}
}

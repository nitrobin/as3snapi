package as3snapi.feautures.basic.uids {
public class IdsHandler implements IIdsHandler {

    private var _onSuccess:Function;
    private var _onFail:Function;

    public function IdsHandler(_onSuccess:Function = null, _onFail:Function = null) {
        this._onSuccess = _onSuccess;
        this._onFail = _onFail;
    }

    public function onSuccess(uids:Array):void {
        if (_onSuccess != null)_onSuccess(uids);
    }

    public function onFail(result:Object):void {
        if (_onFail != null)_onFail(result);
    }

}
}

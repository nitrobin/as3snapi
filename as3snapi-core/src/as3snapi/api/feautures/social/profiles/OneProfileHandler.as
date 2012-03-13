package as3snapi.api.feautures.social.profiles {
public class OneProfileHandler implements IOneProfileHandler {
    private var _onSuccess:Function;
    private var _onFail:Function;

    public function OneProfileHandler(_onSuccess:Function = null, _onFail:Function = null) {
        this._onSuccess = _onSuccess;
        this._onFail = _onFail;
    }

    public function onSuccess(profile:IProfile):void {
        if (_onSuccess != null)_onSuccess(profile);
    }

    public function onFail(result:Object):void {
        if (_onFail != null)_onFail(result);
    }
}
}

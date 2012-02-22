package as3snapi.feautures.basic.profiles {
public class ProfilesHandler implements IProfilesHandler {
    private var _onSuccess:Function;
    private var _onFail:Function;

    public function ProfilesHandler(_onSuccess:Function = null, _onFail:Function = null) {
        this._onSuccess = _onSuccess;
        this._onFail = _onFail;
    }

    public function onSuccess(profiles:Array):void {
        if (_onSuccess != null)_onSuccess(profiles);
    }

    public function onFail(result:Object):void {
        if (_onFail != null)_onFail(result);
    }
}
}

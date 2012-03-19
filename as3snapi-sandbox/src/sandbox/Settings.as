package sandbox {
import flash.net.SharedObject;

public dynamic class Settings {
    private static const SO_NAME:String = "as3snapi-sandbox";

    public var MAILRU_PRIVATE_KEY:String;
    public var ODNOKLASSNIKI_SECRET_KEY:String;
    public var FACEBOOK_APP_ID:String;

    public var keys:Array = [
        "MAILRU_PRIVATE_KEY",
        "ODNOKLASSNIKI_SECRET_KEY",
        "FACEBOOK_APP_ID",
    ];

    public function Settings() {
        load();
    }

    public function load():void {
        var so:SharedObject = SharedObject.getLocal(SO_NAME);
        for each(var k:String in keys) {
            this[k] = so.data[k];
        }
        so.close();
    }


    public function save():void {
        var so:SharedObject = SharedObject.getLocal(SO_NAME);
        for each (var k:String in keys) {
            so.data[k] = this[k];
        }
        so.flush();
        so.close();
    }

}
}

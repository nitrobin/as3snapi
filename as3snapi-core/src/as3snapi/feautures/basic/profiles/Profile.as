package as3snapi.feautures.basic.profiles {

public class Profile implements IProfile {
    public var userId:String;
    public var profileUrl:String;
    public var fullName:String;
    public var avatarUrl:String;
    public var sex:String;
    private var rawData:Object;

    public function Profile() {
    }

    public function getUserId():String {
        return userId;
    }

    public function getProfileUrl():String {
        return profileUrl;
    }

    public function getFullName():String {
        return fullName;
    }

    public function getAvatarUrl():String {
        return avatarUrl;
    }

    public function getSex():String {
        return sex;
    }

    public function getRawData():Object {
        return rawData;
    }

    public function setRawData(rawData:Object):void {
        this.rawData = rawData;
    }
}
}

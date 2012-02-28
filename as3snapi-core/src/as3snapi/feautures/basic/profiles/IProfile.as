package as3snapi.feautures.basic.profiles {
public interface IProfile {
    //TODO: больше полей
    function getUserId():String;

    function getProfileUrl():String;

    function getFullName():String;

    function getAvatarUrl():String;

    function getGender():String;

    function getRawData():Object;
}
}

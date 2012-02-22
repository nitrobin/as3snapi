package as3snapi.feautures.basic.profiles {
public interface IFeatureProfilesBase {
    function getProfilesBase(uids:Array, handler:IProfilesHandler):void;

    function getProfilesChunkSize():int;
}
}

package as3snapi.api.feautures.social.profiles {
public interface IFeatureProfilesBase {
    function getProfilesChunkSize():int;

    function getProfilesBase(uids:Array, handler:IProfilesHandler):void;

}
}

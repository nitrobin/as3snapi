package as3snapi.feautures.basic.profiles {
public interface IFeatureProfilesBase {
    function getProfilesChunkSize():int;

    function getProfilesBase(uids:Array, handler:IProfilesHandler):void;

}
}

package as3snapi.networks.fbcom.features {
public interface IFeatureFbcomApiCore {
    function getSignedRequest():String;

    function getAccessToken():String;

    function getExpiresIn():Number;
}
}

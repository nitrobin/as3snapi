package as3snapi.api {
import as3snapi.api.feautures.social.IFeatureAppId;
import as3snapi.api.feautures.social.IFeatureNetworkId;
import as3snapi.api.feautures.social.IFeatureUserId;
import as3snapi.api.feautures.social.invites.IFeatureInvitePopup;
import as3snapi.api.feautures.social.profiles.IFeatureAppFriendsProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureFriendsProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureSelfProfile;
import as3snapi.base.INetworkConfig;
import as3snapi.utils.bus.IBus;

public class SocialFeaturesWrapper {
    private var connection:INetworkConnection;
    private var bus:IBus;

    public function SocialFeaturesWrapper(connection:INetworkConnection) {
        this.connection = connection;
        this.bus = connection.getBus();
    }

    public function getConfig():INetworkConfig {
        return connection.getConfig();
    }

    public function hasAppIdFeature():Boolean {
        return bus.hasFeature(IFeatureAppId);
    }

    public function getAppId():String {
        var f:IFeatureAppId = bus.getFeature(IFeatureAppId);
        return f.getAppId();
    }

    public function hasUserIdFeature():Boolean {
        return bus.hasFeature(IFeatureUserId);
    }

    public function getUserId():String {
        var f:IFeatureUserId = bus.getFeature(IFeatureUserId);
        return f.getUserId();
    }

    public function hasNetworkIdFeature():Boolean {
        return bus.hasFeature(IFeatureNetworkId);
    }

    public function getNetworkId():String {
        var f:IFeatureNetworkId = bus.getFeature(IFeatureNetworkId);
        return f.getShortNetworkId();
    }

    public function hasSelfProfileFeature():Boolean {
        return bus.hasFeature(IFeatureSelfProfile);
    }

    public function getSelfProfileFeature():IFeatureSelfProfile {
        return bus.getFeature(IFeatureSelfProfile);
    }

    public function hasProfilesFeature():Boolean {
        return bus.hasFeature(IFeatureProfiles);
    }

    public function getProfilesFeature():IFeatureProfiles {
        return bus.getFeature(IFeatureProfiles);
    }

    public function hasAppFriendsProfilesFeature():Boolean {
        return bus.hasFeature(IFeatureAppFriendsProfiles);
    }

    public function getAppFriendsProfilesFeature():IFeatureAppFriendsProfiles {
        return bus.getFeature(IFeatureAppFriendsProfiles);
    }

    public function hasFriendsProfilesFeature():Boolean {
        return bus.hasFeature(IFeatureFriendsProfiles);
    }

    public function getFriendsProfilesFeature():IFeatureFriendsProfiles {
        return bus.getFeature(IFeatureFriendsProfiles);
    }

    public function hasInvitePopupFeature():Boolean {
        return bus.hasFeature(IFeatureInvitePopup);
    }

    public function getInvitePopupFeature():IFeatureInvitePopup {
        return bus.getFeature(IFeatureInvitePopup);
    }
}
}

package as3snapi.api.feautures.social {
import as3snapi.api.feautures.social.invites.IFeatureInviteMsg;
import as3snapi.api.feautures.social.invites.IFeatureInvitePopup;
import as3snapi.api.feautures.social.profiles.IFeatureAppFriendsProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureFriendsProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureProfilesBase;
import as3snapi.api.feautures.social.profiles.IFeatureSelfProfile;
import as3snapi.api.feautures.social.uids.IFeatureAppFriendUids;
import as3snapi.api.feautures.social.uids.IFeatureFriendUids;
import as3snapi.utils.bus.IMutableBus;

public class SocialFeaturesInstallHelper {
    private static const FEATURES:Array = [
        IFeatureNetworkId,
        IFeatureAppId,
        IFeatureUserId,
        IFeatureRefererId,

        IFeatureFriendUids,
        IFeatureAppFriendUids,

        IFeatureSelfProfile,
        IFeatureProfilesBase,
        IFeatureProfiles,
        IFeatureFriendsProfiles,
        IFeatureAppFriendsProfiles,

        IFeatureInvitePopup,
        IFeatureInviteMsg,
    ];

    /**
     * Подключить базовые возможности из доступных в объекте delegate
     * @param bus
     * @param delegate объект для сканирования
     */
    public static function installBasicFeatures(bus:IMutableBus, delegate:Object):void {
        for each(var feature:Class in FEATURES) {
            if (delegate is feature) {
                bus.addFeature(feature, delegate);
            }
        }
    }

}
}


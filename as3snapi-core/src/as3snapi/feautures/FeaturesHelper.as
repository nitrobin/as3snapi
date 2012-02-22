package as3snapi.feautures {
import as3snapi.bus.IMutableBus;
import as3snapi.feautures.basic.*;
import as3snapi.feautures.basic.init.IFeatureAsyncInit;
import as3snapi.feautures.basic.invites.IFeatureInviteMsg;
import as3snapi.feautures.basic.invites.IFeatureInvitePopup;
import as3snapi.feautures.basic.profiles.IFeatureAppFriendsProfiles;
import as3snapi.feautures.basic.profiles.IFeatureFriendsProfiles;
import as3snapi.feautures.basic.profiles.IFeatureProfiles;
import as3snapi.feautures.basic.profiles.IFeatureProfilesBase;
import as3snapi.feautures.basic.profiles.IFeatureSelfProfile;
import as3snapi.feautures.basic.uids.IFeatureAppFriendUids;
import as3snapi.feautures.basic.uids.IFeatureFriendUids;

public class FeaturesHelper {
    private static const FEATURES:Array = [
        IFeatureAsyncInit,
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


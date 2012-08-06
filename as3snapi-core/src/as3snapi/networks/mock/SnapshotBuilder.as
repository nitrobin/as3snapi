/**
 * @author nitrobin
 */
package as3snapi.networks.mock {

public class SnapshotBuilder {
    private var snapshot:Object;

    public function SnapshotBuilder(snapshot:Object = null) {
        this.snapshot = snapshot || {};
    }

    public function build():Object {
        return snapshot;
    }

    public function setShortNetworkId(shortNetworkId:String):SnapshotBuilder {
        snapshot.shortNetworkId = shortNetworkId;
        return this;
    }

    public function setUserId(userId:String):SnapshotBuilder {
        snapshot.userId = userId;
        setProfile(userId);
        return this;
    }

    public function setRefererId(refererId:String):SnapshotBuilder {
        snapshot.refererId = refererId;
        setProfile(refererId);
        return this;
    }

    public function setFlashVars(flashVars:Object):SnapshotBuilder {
        snapshot.flashVars = flashVars;
        return this;
    }

    public function setAppId(appId:String):SnapshotBuilder {
        snapshot.appId = appId;
        return this;
    }

    public function setAppFriendsUids(appFriendsUids:Array):SnapshotBuilder {
        snapshot.appFriendsUids = appFriendsUids;
        for each(var uid:String in appFriendsUids) {
            setProfile(uid);
        }
        return this;
    }

    public function addAppFriend(userId:String, fullName:String = null):SnapshotBuilder {
        var appFriendsUids:Array = snapshot.appFriendsUids || [];
        appFriendsUids.push(userId);
        setProfile(userId, fullName);
        snapshot.appFriendsUids = appFriendsUids;
        return this;
    }

    public function setFriendsUids(friendsUids:Array):SnapshotBuilder {
        snapshot.friendsUids = friendsUids;
        for each(var uid:String in friendsUids) {
            setProfile(uid);
        }
        return this;
    }

    public function addFriend(userId:String, fullName:String = null):SnapshotBuilder {
        var friendsUids:Array = snapshot.friendsUids || [];
        friendsUids.push(userId);
        setProfile(userId, fullName);
        snapshot.friendsUids = friendsUids;
        return this;
    }

    public function setProfile(userId:String, fullName:String = null, avatar:String = null, photos:Array = null, profileUrl:String = null, gender:String = null):SnapshotBuilder {
        var profiles:Object = snapshot.profiles || {};
        profiles[userId] = {
            userId:userId,
            fullName:fullName || ("user" + userId),
            avatar:avatar,
            photos:photos,
            profileUrl:profileUrl,
            gender:gender
        };
        snapshot.profiles = profiles;
        return this;
    }

    public static function helloWorld():SnapshotBuilder {
        return new SnapshotBuilder()
                .setShortNetworkId("mock")
                .setAppId("0")
                .setUserId("1")
                .setRefererId("2")
                .setFriendsUids(["2", "3", "4"])
                .setAppFriendsUids(["2", "3"]);
    }

}
}

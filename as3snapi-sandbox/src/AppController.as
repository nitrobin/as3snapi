package {
import as3snapi.ConnectionFactory;
import as3snapi.IConnectionFactory;
import as3snapi.core.IBusModule;
import as3snapi.core.INetworkConfig;
import as3snapi.core.INetworkModule;
import as3snapi.core.ISocialityConnectHandler;
import as3snapi.core.ISocialityConnection;
import as3snapi.feautures.basic.IFeatureAppId;
import as3snapi.feautures.basic.IFeatureNetworkId;
import as3snapi.feautures.basic.IFeatureRefererId;
import as3snapi.feautures.basic.IFeatureUserId;
import as3snapi.feautures.basic.invites.IFeatureInvitePopup;
import as3snapi.feautures.basic.profiles.IFeatureAppFriendsProfiles;
import as3snapi.feautures.basic.profiles.IFeatureFriendsProfiles;
import as3snapi.feautures.basic.profiles.IFeatureProfiles;
import as3snapi.feautures.basic.profiles.IFeatureSelfProfile;
import as3snapi.feautures.basic.profiles.IProfile;
import as3snapi.feautures.basic.profiles.OneProfileHandler;
import as3snapi.feautures.basic.profiles.ProfilesHandler;
import as3snapi.feautures.basic.uids.IFeatureAppFriendUids;
import as3snapi.feautures.basic.uids.IFeatureFriendUids;
import as3snapi.feautures.basic.uids.IdsHandler;
import as3snapi.feautures.core.log.FeatureLogTrace;
import as3snapi.modules.bus.BusModuleLogHook;
import as3snapi.modules.networks.mailru.ConfigMailru;
import as3snapi.modules.networks.mailru.NetworkModuleMailru;
import as3snapi.modules.networks.mock.ConfigMock;
import as3snapi.modules.networks.mock.MockDataCapture;
import as3snapi.modules.networks.mock.NetworkModuleMock;
import as3snapi.modules.networks.vkcom.ConfigVkcom;
import as3snapi.modules.networks.vkcom.NetworkModuleVkcom;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomApiCore;
import as3snapi.modules.networks.vkcom.features.IFeatureVkcomApiUi;

import flash.events.MouseEvent;

import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.events.CloseEvent;

import spark.components.Button;

public class AppController implements ISocialityConnectHandler {
    private var app:SandboxMain;
    private var connection:ISocialityConnection;

    public function AppController(app:SandboxMain) {
        this.app = app;
    }

    public function connect():void {
        log("configuring..");
        var mockData:Object = {
            shortNetworkId:"mock",
            userId:1,
            inviterId:2,
            asppId:123,
            profiles:{1:{fullName:"test1"}, 2:{fullName:"test1"}, 3:{fullName:"test1"}},
            appFriendsUids:[2],
            friendsUids:[2, 3]
        };
        var factory:IConnectionFactory = new ConnectionFactory(
                app.parameters,
                new <INetworkConfig>[
                    new ConfigVkcom(),
                    new ConfigMailru("6cb13ffe86243b89c815376cb1bd1495"),
                    new ConfigMock().setData(null).setDataUrl("mock.json.html"),
                ],
                new <INetworkModule>[
                    new NetworkModuleVkcom(),
                    new NetworkModuleMailru(),
                    new NetworkModuleMock(),
                ],
                new <IBusModule>[
                    new BusModuleLogHook(app.log, app.apiLog, app.eventLog)
                ]
        );
        log("try connecting...");
        logLine();
        try {
            factory.createConnection(this);
        } catch (e:Error) {
            log(e.getStackTrace());
        }
        app.profilesLoadBtn.addEventListener(MouseEvent.CLICK, loadProfile)
    }

    private function loadProfile(event:MouseEvent):void {
        if (connection && connection.hasFeature(IFeatureProfiles)) {
            var profiles:IFeatureProfiles = connection.getFeature(IFeatureProfiles);
            profiles.getProfiles(app.profilesUserIdTI.text.split(','), new ProfilesHandler(function (profiles:Array):void {
                for each(var p:IProfile in profiles) {
                    app.profiles.addItemAt(p, 0);
                }
            }, function (result:Object):void {
                log(result);
            }));
        }
    }

    private function log(msg:*):void {
        app.log(msg);
    }

    private function logLine():void {
        log("-------------------");
    }

    public function onFail(result:Object):void {
        logLine();
        log("FAIL");
        log(result);
    }

    public function onSuccess(connection:ISocialityConnection):void {
        this.connection = connection;
        logLine();
        log("READY");
        logLine();
        try {
            addBtn("Capture mock data", function (e:MouseEvent):void {
                var mockCapture:MockDataCapture = new MockDataCapture(connection.getBus());
                mockCapture.capture(function (data:Object):void {
                    Alert.show("Captured", "Mock data", Alert.OK, app, function (e:CloseEvent):void {
                        mockCapture.saveFile();
                    });
                }, function (r:Object):void {
                    log(r);
                });
            });
            testBus(connection);
        } catch (e:Error) {
            log(e.getStackTrace());
        }
    }

    private function testBus(connection:ISocialityConnection):void {

        var fNetworkInfo:IFeatureNetworkId = connection.getFeature(IFeatureNetworkId)
        if (fNetworkInfo != null) {
            log("IFeatureNetworkId: " + fNetworkInfo.getShortNetworkId());
        } else {
            log("IFeatureNetworkId - UNSUPPORTED");
        }

        var fAppId:IFeatureAppId = connection.getFeature(IFeatureAppId)
        if (fAppId != null) {
            log("IFeatureAppId: " + fAppId.getAppId());
        } else {
            log("IFeatureAppId - UNSUPPORTED");
        }

        var fUserId:IFeatureUserId = connection.getFeature(IFeatureUserId)
        if (fUserId != null) {
            log("IFeatureUserId: " + fUserId.getUserId());
            app.profilesUserIdTI.text = fUserId.getUserId();
        } else {
            log("IFeatureUserId - UNSUPPORTED");
        }

        var fRefererId:IFeatureRefererId = connection.getFeature(IFeatureRefererId)
        if (fRefererId != null) {
            log("IFeatureRefererId: " + fRefererId.getRefererId());
        } else {
            log("IFeatureRefererId - UNSUPPORTED");
        }

        var fInviteBox:IFeatureInvitePopup = connection.getFeature(IFeatureInvitePopup)
        if (fInviteBox != null) {
            log("IFeatureInvitePopup - AVAILABLE");
            addBtn("IFeatureInvitePopup", function (e:MouseEvent):void {
                fInviteBox.showInvitePopup();
            })
        } else {
            log("IFeatureInvitePopup - UNSUPPORTED");
        }

        var fVkUiApi:IFeatureVkcomApiUi = connection.getFeature(IFeatureVkcomApiUi)
        if (fVkUiApi != null) {
            log("IFeatureVkUiApi - AVAILABLE");
            addBtn("IFeatureVkUiApi.showPaymentBox", function (e:MouseEvent):void {
                fVkUiApi.showPaymentBox(10);
            })
        } else {
            //log("IFeatureVkUiApi - UNSUPPORTED");
        }

        var asyncs:Array = [
            function ():void {
                var feature:IFeatureSelfProfile = connection.getFeature(IFeatureSelfProfile)
                if (feature != null) {
                    log("IFeatureSelfProfile... ");
                    feature.getSelfProfile(
                            new OneProfileHandler(function (profile:IProfile):void {
                                log("IFeatureSelfProfile: " + FeatureLogTrace.universalDump(profile));
                                next();
                            }, function (result:Object):void {
                                log("IFeatureSelfProfile: FAIL " + FeatureLogTrace.universalDump(result));
                                next();
                            }));
                } else {
                    log("IFeatureSelfProfile - UNSUPPORTED");
                    next();
                }
            },
            function ():void {
                var feature:IFeatureProfiles = connection.getFeature(IFeatureProfiles)
                if (feature != null) {
                    log("IFeatureProfiles... Requesting self profile.");
                    feature.getProfiles([fUserId.getUserId()],
                            new ProfilesHandler(function (profiles:Array):void {
//                                    log("IFeatureProfiles: " + FeatureLogTrace.universalDump(profiles));
                                log("IFeatureProfiles: " + profiles.length + " item(s)");
                                next();
                            }, function (result:Object):void {
                                log("IFeatureProfiles: FAIL " + FeatureLogTrace.universalDump(result));
                                next();
                            }));
                } else {
                    log("IFeatureProfiles - UNSUPPORTED");
                    next();
                }
            },
            function ():void {
                var feature:IFeatureFriendUids = connection.getFeature(IFeatureFriendUids)
                if (feature != null) {
                    log("IFeatureFriendUids...");
                    feature.getFriendUids(
                            new IdsHandler(function (uids:Array):void {
//                                    log("IFeatureFriendUids: " + FeatureLogTrace.universalDump(uids));
                                log("IFeatureFriendUids: " + uids.length + " item(s)");
                                next();
                            }, function (result:Object):void {
                                log("IFeatureFriendUids: FAIL " + FeatureLogTrace.universalDump(result));
                                next();
                            }));
                } else {
                    log("IFeatureFriendUids - UNSUPPORTED");
                    next();
                }
            },
            function ():void {
                var feature:IFeatureAppFriendUids = connection.getFeature(IFeatureAppFriendUids)
                if (feature != null) {
                    log("IFeatureAppFriendUids...");
                    feature.getAppFriendUids(
                            new IdsHandler(function (uids:Array):void {
//                                    log("IFeatureAppFriendUids: " + FeatureLogTrace.universalDump(uids));
                                log("IFeatureAppFriendUids: " + uids.length + " item(s)");
                                next();
                            }, function (result:Object):void {
                                log("IFeatureAppFriendUids: FAIL " + FeatureLogTrace.universalDump(result));
                                next();
                            }));
                } else {
                    log("IFeatureAppFriendUids - UNSUPPORTED");
                    next();
                }
            },
            function ():void {
                var feature:IFeatureFriendsProfiles = connection.getFeature(IFeatureFriendsProfiles)
                if (feature != null) {
                    log("IFeatureFriendsProfiles...");
                    feature.getFriendsProfiles(
                            new ProfilesHandler(function (profiles:Array):void {
//                                    log("IFeatureFriendsProfiles: " + FeatureLogTrace.universalDump(profiles));
                                log("IFeatureFriendsProfiles: " + profiles.length + " item(s)");
                                app.friendsProfiles = new ArrayList(profiles);
                                next();
                            }, function (result:Object):void {
                                log("IFeatureFriendsProfiles: FAIL " + FeatureLogTrace.universalDump(result));
                                next();
                            }));
                } else {
                    log("IFeatureFriendsProfiles - UNSUPPORTED");
                    next();
                }
            },
            function ():void {
                var feature:IFeatureAppFriendsProfiles = connection.getFeature(IFeatureAppFriendsProfiles)
                if (feature != null) {
                    log("IFeatureAppFriendsProfiles...");
                    feature.getAppFriendsProfiles(
                            new ProfilesHandler(function (profiles:Array):void {
//                                    log("IFeatureAppFriendsProfiles: " + FeatureLogTrace.universalDump(profiles));
                                log("IFeatureAppFriendsProfiles: " + profiles.length + " item(s)");
                                app.appFriendsProfiles = new ArrayList(profiles);
                                next();
                            }, function (result:Object):void {
                                log("IFeatureAppFriendsProfiles: FAIL " + FeatureLogTrace.universalDump(result));
                                next();
                            }));
                } else {
                    log("IFeatureAppFriendsProfiles - UNSUPPORTED");
                    next();
                }
            },
            function ():void {
                var feature:IFeatureVkcomApiCore = connection.getFeature(IFeatureVkcomApiCore);
                if (feature != null) {
                    log("IFeatureVkCoreApi.getUserBalance...");
                    feature.getUserBalance(
                            function (ballance:Object):void {
//                                    log("IFeatureAppFriendsProfiles: " + FeatureLogTrace.universalDump(profiles));
                                log("IFeatureVkCoreApi.getUserBalance: " + ballance);
                                next();
                            }, function (result:Object):void {
                                log("IFeatureVkCoreApi.getUserBalance: FAIL " + FeatureLogTrace.universalDump(result));
                                next();
                            });
                } else {
                    //log("IFeatureVkCoreApi - UNSUPPORTED");
                    next();
                }
            },
        ];

        function next():void {
            logLine();
            if (asyncs.length > 0) {
                var func:Function = asyncs.shift();
                func();
            }
        }

        next();
    }

    private function addBtn(label:String, clickHandler:Function):void {
        var b:Button = new Button();
        b.label = label;
        b.addEventListener(MouseEvent.CLICK, clickHandler);
        app.btns.addElement(b);
    }
}
}

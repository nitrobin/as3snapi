package sandbox {
import as3snapi.ConnectionFactory;
import as3snapi.IConnectionFactory;
import as3snapi.api.INetworkConnectHandler;
import as3snapi.api.INetworkConnection;
import as3snapi.api.feautures.social.IFeatureAppId;
import as3snapi.api.feautures.social.IFeatureNetworkId;
import as3snapi.api.feautures.social.IFeatureRefererId;
import as3snapi.api.feautures.social.IFeatureUserId;
import as3snapi.api.feautures.social.invites.IFeatureInvitePopup;
import as3snapi.api.feautures.social.profiles.IFeatureAppFriendsProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureFriendsProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureProfiles;
import as3snapi.api.feautures.social.profiles.IFeatureSelfProfile;
import as3snapi.api.feautures.social.profiles.IProfile;
import as3snapi.api.feautures.social.profiles.OneProfileHandler;
import as3snapi.api.feautures.social.profiles.ProfilesHandler;
import as3snapi.api.feautures.social.uids.IFeatureAppFriendUids;
import as3snapi.api.feautures.social.uids.IFeatureFriendUids;
import as3snapi.api.feautures.social.uids.IdsHandler;
import as3snapi.base.INetworkConfig;
import as3snapi.base.INetworkModule;
import as3snapi.base.features.log.FeatureLogTrace;
import as3snapi.base.plugins.IBusModule;
import as3snapi.base.plugins.logs.BusModuleLogHook;
import as3snapi.networks.fbcom.ConfigFbcom;
import as3snapi.networks.fbcom.ModuleFbcom;
import as3snapi.networks.fbcom.features.IFeatureFbcomApiCore;
import as3snapi.networks.mailru.ConfigMailru;
import as3snapi.networks.mailru.ModuleMailru;
import as3snapi.networks.mock.ConfigMock;
import as3snapi.networks.mock.MockDataCapture;
import as3snapi.networks.mock.ModuleMock;
import as3snapi.networks.odnoklassnikiru.ConfigOdnoklassnikiru;
import as3snapi.networks.odnoklassnikiru.ModuleOdnoklassnikiru;
import as3snapi.networks.vkcom.ConfigVkcom;
import as3snapi.networks.vkcom.ModuleVkcom;
import as3snapi.networks.vkcom.features.IFeatureVkcomApiCore;
import as3snapi.networks.vkcom.features.IFeatureVkcomApiUi;

import flash.events.MouseEvent;

import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.events.CloseEvent;

import sandbox.ui.MainPanel;

import spark.components.Button;

public class AppController implements INetworkConnectHandler {
    private var view:MainPanel;
    private var connection:INetworkConnection;
    private var mockData:Object = {
        shortNetworkId:"mock",
        userId:1,
        inviterId:2,
        asppId:123,
        profiles:{1:{fullName:"test1"}, 2:{fullName:"test1"}, 3:{fullName:"test1"}},
        appFriendsUids:[2],
        friendsUids:[2, 3]
    };

    public function AppController(view:MainPanel) {
        this.view = view;
    }

    public function connect():void {
        log("configuring..");
        var props:Settings = new Settings();
        var factory:IConnectionFactory = new ConnectionFactory(
                FlexGlobals.topLevelApplication.parameters,
                new <INetworkConfig>[
                    new ConfigVkcom(),
                    new ConfigMailru(props.MAILRU_PRIVATE_KEY),
                    new ConfigOdnoklassnikiru(props.ODNOKLASSNIKI_SECRET_KEY),
                    new ConfigFbcom(props.FACEBOOK_APP_ID),
                    new ConfigMock().setData(mockData)//.setDataUrl("mock.json.html"),
                ],
                new <INetworkModule>[
                    new ModuleVkcom(),
                    new ModuleMailru(),
                    new ModuleOdnoklassnikiru(),
                    new ModuleFbcom(),
                    new ModuleMock(),
                ],
                new <IBusModule>[
                    new BusModuleLogHook(view.log, view.apiLog, view.eventLog)
                ]
        );
        log("try connecting...");
        logLine();
        try {
            factory.createConnection(this);
        } catch (e:Error) {
            log(e.getStackTrace());
        }
        view.profilesLoadBtn.addEventListener(MouseEvent.CLICK, loadProfile)
    }

    private function loadProfile(event:MouseEvent):void {
        if (connection && connection.hasFeature(IFeatureProfiles)) {
            var profiles:IFeatureProfiles = connection.getFeature(IFeatureProfiles);
            profiles.getProfiles(view.profilesUserIdTI.text.split(','), new ProfilesHandler(function (profiles:Array):void {
                for each(var p:IProfile in profiles) {
                    view.profiles.addItemAt(p, 0);
                }
            }, function (result:Object):void {
                log(result);
            }));
        }
    }

    private function log(msg:*):void {
        view.log(msg);
    }

    private function logLine():void {
        log("-------------------");
    }

    public function onFail(result:Object):void {
        logLine();
        log(result);
        log("FAIL");
        log("Check 'WARNINGS' in log.");
        log("Click 'settings' and check application keys.");
    }

    public function onSuccess(connection:INetworkConnection):void {
        this.connection = connection;
        logLine();
        log("READY");
        logLine();
        try {
            testBus(connection);
        } catch (e:Error) {
            log(e.getStackTrace());
        }
    }

    private function testBus(connection:INetworkConnection):void {
        //TODO: Привести в более компактный/читабельный вид

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
            view.profilesUserIdTI.text = fUserId.getUserId();
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

        var fFbApi:IFeatureFbcomApiCore = connection.getFeature(IFeatureFbcomApiCore)
        if (fFbApi != null) {
            log("IFeatureFbcomApiCore.getAccessToken: " + fFbApi.getAccessToken());
            log("IFeatureFbcomApiCore.getSignedRequest: " + fFbApi.getSignedRequest());
            log("IFeatureFbcomApiCore.getExpiresIn: " + fFbApi.getExpiresIn());
        } else {
//            log("IFeatureFbcomApiCore - UNSUPPORTED");
        }

        log("Start async tests..");

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
                                view.friendsProfiles = new ArrayList(profiles);
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
                                view.appFriendsProfiles = new ArrayList(profiles);
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
            } else {
                log("Async test finished.");
            }
        }

        next();
    }

    private function addBtn(label:String, clickHandler:Function):void {
        var b:Button = new Button();
        b.label = label;
        b.addEventListener(MouseEvent.CLICK, clickHandler);
        view.btns.addElement(b);
    }

    public function captureMockSnapshot():void {
        if (connection == null) {
            Alert.show("Network not detected.\nData not available.");
        } else {
            var mockCapture:MockDataCapture = new MockDataCapture(connection.getBus());
            mockCapture.capture(function (data:Object):void {
                Alert.show("Captured", "Mock data", Alert.OK, view,
                        function (e:CloseEvent):void {
                            mockCapture.saveFile();
                        });
            }, function (r:Object):void {
                log(r);
            });
        }
    }
}
}

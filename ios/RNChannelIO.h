//
//  RNChannelIO.h
//  RNExample
//
//  Created by Haeun Chung on 28/09/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@import ChannelIO;

NS_ASSUME_NONNULL_BEGIN

@interface RNChannelIO : RCTEventEmitter <RCTBridgeModule, ChannelPluginDelegate>
@end

// event key
static NSString * const KEY_EVENT = @"Event";
static NSString * const KEY_EVENT_ON_BADGE_CHANGED = @"ON_BADGE_CHANGED";
static NSString * const KEY_EVENT_ON_PROFILE_CHANGED = @"ON_PROFILE_CHANGED";
static NSString * const KEY_EVENT_ON_POPUP_DATA_RECEIVED = @"ON_POPUP_DATA_RECEIVED";
static NSString * const KEY_EVENT_ON_SHOW_MESSENGER = @"ON_SHOW_MESSENGER";
static NSString * const KEY_EVENT_ON_HIDE_MESSENGER = @"ON_HIDE_MESSENGER";
static NSString * const KEY_EVENT_ON_CHAT_CREATED = @"ON_CHAT_CREATED";
static NSString * const KEY_EVENT_ON_PRE_URL_CLICKED = @"ON_PRE_URL_CLICKED";
static NSString * const KEY_EVENT_ON_URL_CLICKED = @"ON_URL_CLICKED";
static NSString * const KEY_EVENT_ON_PUSH_NOTIFICATION_CLICKED = @"ON_PUSH_NOTIFICATION_CLICKED";

// event
static NSString * const EVENT_ON_BADGE_CHANGED = @"ChannelIO:Event:OnBadgeChanged";
static NSString * const EVENT_ON_PROFILE_CHANGED = @"ChannelIO:Event:OnProfileChanged";
static NSString * const EVENT_ON_POPUP_DATA_RECEIVED = @"ChannelIO:Event:OnPopupDataReceive";
static NSString * const EVENT_ON_SHOW_MESSENGER = @"ChannelIO:Event:OnShowMessenger";
static NSString * const EVENT_ON_HIDE_MESSENGER = @"ChannelIO:Event:OnHideMessenger";
static NSString * const EVENT_ON_CHAT_CREATED = @"ChannelIO:Event:OnChatCreated";
static NSString * const EVENT_ON_PRE_URL_CLICKED = @"ChannelIO:Event:OnPreUrlClicked";
static NSString * const EVENT_ON_URL_CLICKED = @"ChannelIO:Event:OnUrlClicked";
static NSString * const EVENT_ON_PUSH_NOTIFICATION_CLICKED = @"ChannelIO:Event:OnPushNotificationClicked";

// language key
static NSString * const KEY_LANGUAGE_KOREAN = @"korean";
static NSString * const KEY_LANGUAGE_ENGLISH = @"english";
static NSString * const KEY_LANGUAGE_JAPANESE = @"japanese";
static NSString * const KEY_LANGUAGE_DEVICE = @"device";

// BootStatus key
static NSString * const KEY_BOOT_STATUS = @"BootStatus";
static NSString * const KEY_BOOT_STATUS_SUCCESS = @"success";
static NSString * const KEY_BOOT_STATUS_NOT_INITIALIZED = @"notInitialized";
static NSString * const KEY_BOOT_STATUS_NETWORK_TIMEOUT = @"networkTimeout";
static NSString * const KEY_BOOT_STATUS_NOT_AVAILABLE_VERSION = @"notAvailableVersion";
static NSString * const KEY_BOOT_STATUS_SERVICE_UNDER_CONSTRUCTION = @"serviceUnderConstruction";
static NSString * const KEY_BOOT_STATUS_REQUIRE_PAYMENT = @"requirePayment";
static NSString * const KEY_BOOT_STATUS_ACCESS_DENIED = @"accessDenied";
static NSString * const KEY_BOOT_STATUS_UNKNOWN_ERROR = @"unknownError";

// error
static NSString * const ERROR_UNKNOWN = @"UNKNOWN_ERROR";

static NSString * const KEY_CHANNEL_BUTTON_POSITION = @"ChannelButtonPosition";

static NSString * const KEY_STATUS = @"status";
static NSString * const KEY_CHAT_ID = @"chatId";
static NSString * const KEY_COUNT = @"count";
static NSString * const KEY_URL = @"url";
static NSString * const KEY_POPUP = @"popup";
static NSString * const KEY_PROFILE_ONCE = @"profileOnce";
static NSString * const KEY_PROFILE_KEY = @"key";
static NSString * const KEY_PROFILE_VALUE = @"value";
static NSString * const KEY_USER = @"user";
static NSString * const KEY_ERROR = @"error";
static NSString * const KEY_TAGS = @"tags";

// deprecated

// event key
static NSString * const KEY_EVENT_ON_CHANGE_BADGE = @"ON_BADGE_CHANGED";
static NSString * const KEY_EVENT_ON_RECEIVE_PUSH = @"ON_PROFILE_CHANGED";
static NSString * const KEY_EVENT_WILL_SHOW_MESSENGER = @"ON_POPUP_DATA_RECEIVED";
static NSString * const KEY_EVENT_WILL_HIDE_MESSENGER = @"ON_SHOW_MESSENGER";
static NSString * const KEY_EVENT_ON_CLICK_CHAT_LINK = @"ON_HIDE_MESSENGER";
static NSString * const KEY_EVENT_ON_CHANGE_PROFILE = @"ON_CHANGE_PROFILE";

// event
static NSString * const EVENT_ON_CHANGE_BADGE = @"ChannelIO:Event:OnChangeBadge";
static NSString * const EVENT_ON_RECEIVE_PUSH = @"ChannelIO:Event:OnReceivePush";
static NSString * const EVENT_WILL_SHOW_MESSENGER = @"ChannelIO:Event:WillShowMessenger";
static NSString * const EVENT_WILL_HIDE_MESSENGER = @"ChannelIO:Event:WillHideMessenger";
static NSString * const EVENT_ON_CLICK_CHAT_LINK = @"ChannelIO:Event:OnClickChatLink";
static NSString * const EVENT_ON_CHANGE_PROFILE = @"ChannelIO:Event:OnChangeProfile";

static NSString * const KEY_CHANNEL_PLUGIN_COMPLETION_STATUS = @"ChannelPluginCompletionStatus";
static NSString * const KEY_LAUNCHER_POSITION = @"LauncherPosition";

NS_ASSUME_NONNULL_END


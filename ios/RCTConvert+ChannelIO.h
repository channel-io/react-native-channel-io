//
//  RNChannelModels.h
//  RNExample
//
//  Created by Haeun Chung on 28/09/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTConvert.h>
#import <ChannelIOFront/ChannelIOFront-swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTConvert (ChannelIO)
+ (BootConfig *)bootConfig:(id)json;
+ (Profile *)profile:(id)json;
+ (ChannelButtonOption *)channelButtonOption:(id)json;
@end

// LanguageOption
static NSString * const LANGUAGE_OPTION_KO = @"ko";
static NSString * const LANGUAGE_OPTION_EN = @"en";
static NSString * const LANGUAGE_OPTION_JA = @"ja";
static NSString * const LANGUAGE_OPTION_DEVICE = @"device";

// BootStatus
static NSString * const BOOT_STATUS_SUCCESS = @"SUCCESS";
static NSString * const BOOT_STATUS_NOT_INITIALIZED = @"NOT_INITIALIZED";
static NSString * const BOOT_STATUS_NETWORK_TIMEOUT = @"NETWORK_TIMEOUT";
static NSString * const BOOT_STATUS_NOT_AVAILABLE_VERSION = @"NOT_AVAILABLE_VERSION";
static NSString * const BOOT_STATUS_SERVICE_UNDER_CONSTRUCTION = @"SERVICE_UNDER_CONSTRUCTION";
static NSString * const BOOT_STATUS_REQUIRE_PAYMENT = @"REQUIRE_PAYMENT";
static NSString * const BOOT_STATUS_ACCESS_DENIED = @"ACCESS_DENIED";
static NSString * const BOOT_STATUS_UNKNOWN_ERROR = @"UNKNOWN_ERROR";

// ChannelButtonOptionIcon
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_CHANNEL = @"channel";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_FILLED = @"chatBubbleFilled";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS_FILLED = @"chatProgressFilled";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION_FILLED = @"chatQuestionFilled";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_LIGHTNING_FILLED = @"chatLightningFilled";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT_FILLED = @"chatBubbleAltFilled";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_SMS_FILLED = @"smsFilled";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_COMMENT_FILLED = @"commentFilled";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD_FILLED = @"sendForwardFilled";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_HELP_FILLED = @"helpFilled";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS = @"chatProgress";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION = @"chatQuestion";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT = @"chatBubbleAlt";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_SMS = @"sms";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_COMMENT = @"comment";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD = @"sendForward";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_COMMUNICATION = @"communication";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_ICON_HEADSET = @"headset";

// ChannelButtonOptionPosition
static NSString * const KEY_CHANNEL_BUTTON_OPTION_POSITION_RIGHT = @"right";
static NSString * const KEY_CHANNEL_BUTTON_OPTION_POSITION_LEFT = @"left";

// ChannelButtonOption
static NSString * const CHANNEL_BUTTON_OPTION_ICON = @"icon";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_CHANNEL = @"channel";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_FILLED = @"chatBubbleFilled";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS_FILLED = @"chatProgressFilled";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION_FILLED = @"chatQuestionFilled";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_CHAT_LIGHTNING_FILLED = @"chatLightningFilled";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT_FILLED = @"chatBubbleAltFilled";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_SMS_FILLED = @"smsFilled";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_COMMENT_FILLED = @"commentFilled";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD_FILLED = @"sendForwardFilled";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_HELP_FILLED = @"helpFilled";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS = @"chatProgress";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION = @"chatQuestion";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT = @"chatBubbleAlt";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_SMS = @"sms";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_COMMENT = @"comment";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD = @"sendForward";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_COMMUNICATION = @"communication";
static NSString * const CHANNEL_BUTTON_OPTION_ICON_HEADSET = @"headset";
static NSString * const CHANNEL_BUTTON_OPTION_POSITION = @"position";
static NSString * const CHANNEL_BUTTON_OPTION_POSITION_RIGHT = @"right";
static NSString * const CHANNEL_BUTTON_OPTION_POSITION_LEFT = @"left";
static NSString * const CHANNEL_BUTTON_OPTION_X_MARGIN = @"xMargin";
static NSString * const CHANNEL_BUTTON_OPTION_Y_MARGIN = @"yMargin";

// BubblePostition
static NSString * const KEY_BUBBLE_POSITION_TOP = @"top";
static NSString * const KEY_BUBBLE_POSITION_BOTTOM = @"bottom";

// Appearance
static NSString * const APPEARANCE_SYSTEM = @"system";
static NSString * const APPEARANCE_LIGHT = @"light";
static NSString * const APPEARANCE_DARK = @"dark";

// BubbleOption
static NSString * const BUBBLE_OPTION_POSITION = @"position";
static NSString * const BUBBLE_OPTION_POSITION_TOP = @"top";
static NSString * const BUBBLE_OPTION_POSITION_BOTTOM = @"bottom";
static NSString * const BUBBLE_OPTION_Y_MARGIN = @"yMargin";

static NSString * const KEY_PLUGIN_KEY = @"pluginKey";
static NSString * const KEY_MEMBER_HASH = @"memberHash";
static NSString * const KEY_HIDE_POPUP = @"hidePopup";
static NSString * const KEY_TRACK_DEFAULT_EVENT = @"trackDefaultEvent";
static NSString * const KEY_CHANNEL_BUTTON_OPTION = @"channelButtonOption";
static NSString * const KEY_BUBBLE_OPTION = @"bubbleOption";
static NSString * const KEY_UNSUBSCRIBE_EMAIL = @"unsubscribeEmail";
static NSString * const KEY_UNSUBSCRIBE_TEXTING = @"unsubscribeTexting";
static NSString * const KEY_APPEARANCE = @"appearance";

static NSString * const KEY_MEMBER_ID = @"memberId";
static NSString * const KEY_LANGUAGE = @"language";
static NSString * const KEY_PROFILE = @"profile";

// deprecated
static NSString * const KEY_HIDE_DEFAULT_IN_APP_PUSH = @"hideDefaultInAppPush";
static NSString * const KEY_ENABLED_TRACK_DEFAULT_EVENT = @"enabledTrackDefaultEvent";
static NSString * const KEY_LAUNCHER_CONFIG = @"launcherConfig";

static NSString * const KEY_USER_ID = @"userId";
static NSString * const KEY_LOCALE = @"locale";

NS_ASSUME_NONNULL_END

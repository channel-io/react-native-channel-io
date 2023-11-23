//
//  RNChannelIO.m
//  RNExample
//
//  Created by Haeun Chung on 28/09/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

#import "RNChannelIO.h"
#import "RCTConvert+ChannelIO.h"

#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>

@implementation RNChannelIO
{
  BOOL hasListeners;
  BOOL handleChatLink;
}

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    ChannelIO.delegate = self;
  }
  return self;
}

- (void)dealloc
{
  ChannelIO.delegate = nil;
}

// Will be called when this module's first listener is added.
-(void)startObserving {
  hasListeners = YES;
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
  hasListeners = NO;
}

- (NSDictionary *)constantsToExport {
  return @{
    EVENT: @{
        KEY_EVENT_ON_BADGE_CHANGED: EVENT_ON_BADGE_CHANGED,
        KEY_EVENT_ON_FOLLOW_UP_CHANGED: EVENT_ON_FOLLOW_UP_CHANGED,
        KEY_EVENT_ON_POPUP_DATA_RECEIVED: EVENT_ON_POPUP_DATA_RECEIVED,
        KEY_EVENT_ON_SHOW_MESSENGER: EVENT_ON_SHOW_MESSENGER,
        KEY_EVENT_ON_HIDE_MESSENGER: EVENT_ON_HIDE_MESSENGER,
        KEY_EVENT_ON_CHAT_CREATED: EVENT_ON_CHAT_CREATED,
        KEY_EVENT_ON_PRE_URL_CLICKED: EVENT_ON_PRE_URL_CLICKED,
        KEY_EVENT_ON_URL_CLICKED: EVENT_ON_URL_CLICKED
    },
    LANGUAGE: @{
        KEY_LANGUAGE_KOREAN: @(LanguageOptionKorean),
        KEY_LANGUAGE_ENGLISH: @(LanguageOptionEnglish),
        KEY_LANGUAGE_JAPANESE: @(LanguageOptionJapanese),
        KEY_LANGUAGE_DEVICE: @(LanguageOptionDevice)
    },
    BOOT_STATUS: @{
        KEY_BOOT_STATUS_SUCCESS: @(BootStatusSuccess),
        KEY_BOOT_STATUS_NOT_INITIALIZED: @(BootStatusNotInitialized),
        KEY_BOOT_STATUS_NETWORK_TIMEOUT: @(BootStatusNetworkTimeout),
        KEY_BOOT_STATUS_NOT_AVAILABLE_VERSION: @(BootStatusNotAvailableVersion),
        KEY_BOOT_STATUS_SERVICE_UNDER_CONSTRUCTION: @(BootStatusServiceUnderConstruction),
        KEY_BOOT_STATUS_REQUIRE_PAYMENT: @(BootStatusRequirePayment),
        KEY_BOOT_STATUS_ACCESS_DENIED: @(BootStatusAccessDenied),
        KEY_BOOT_STATUS_UNKNOWN_ERROR: @(BootStatusUnknown)
    },
    CHANNEL_BUTTON_ICON: @{
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHANNEL: @(ChannelButtonIconChannel),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_FILLED: @(ChannelButtonIconChatBubbleFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS_FILLED: @(ChannelButtonIconChatProgressFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION_FILLED: @(ChannelButtonIconChatQuestionFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_LIGHTNING_FILLED: @(ChannelButtonIconChatLightningFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT_FILLED: @(ChannelButtonIconChatBubbleAltFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_SMS_FILLED: @(ChannelButtonIconSmsFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_COMMENT_FILLED: @(ChannelButtonIconCommentFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD_FILLED: @(ChannelButtonIconSendForwardFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_HELP_FILLED: @(ChannelButtonIconHelpFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS: @(ChannelButtonIconChatProgress),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION: @(ChannelButtonIconChatQuestion),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT: @(ChannelButtonIconChatBubbleAlt),
      KEY_CHANNEL_BUTTON_OPTION_ICON_SMS: @(ChannelButtonIconSms),
      KEY_CHANNEL_BUTTON_OPTION_ICON_COMMENT: @(ChannelButtonIconComment),
      KEY_CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD: @(ChannelButtonIconSendForward),
      KEY_CHANNEL_BUTTON_OPTION_ICON_COMMUNICATION: @(ChannelButtonIconCommunication),
      KEY_CHANNEL_BUTTON_OPTION_ICON_HEADSET: @(ChannelButtonIconHeadset)
    },
    CHANNEL_BUTTON_POSITION: @{
        KEY_CHANNEL_BUTTON_OPTION_POSITION_RIGHT: @(ChannelButtonPositionRight),
        KEY_CHANNEL_BUTTON_OPTION_POSITION_LEFT: @(ChannelButtonPositionLeft)
    },
    CHANNEL_APPEARANCE: @{
      KEY_APPEARANCE_SYSTEM: @(AppearanceSystem),
      KEY_APPEARANCE_DARK: @(AppearanceDark),
      KEY_APPEARANCE_LIGHT: @(AppearanceLight)
    },
  };
}

- (NSArray<NSString *> *)supportedEvents {
  return @[
    EVENT_ON_BADGE_CHANGED,
    EVENT_ON_CHAT_CREATED,
    EVENT_ON_HIDE_MESSENGER,
    EVENT_ON_SHOW_MESSENGER,
    EVENT_ON_PRE_URL_CLICKED,
    EVENT_ON_URL_CLICKED,
    EVENT_ON_FOLLOW_UP_CHANGED,
    EVENT_ON_POPUP_DATA_RECEIVED
  ];
}

RCT_EXPORT_METHOD(boot:(id)bootConfig
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  BootConfig * config = [RCTConvert bootConfig:bootConfig];

  [ChannelIO bootWith:config completion:^(BootStatus status, User *user) {
    NSString * stringStatus = BOOT_STATUS_UNKNOWN_ERROR;
    switch (status) {
      case BootStatusSuccess:
        stringStatus = BOOT_STATUS_SUCCESS;
        break;
      case BootStatusNotInitialized:
        stringStatus = BOOT_STATUS_NOT_INITIALIZED;
        break;
      case BootStatusNetworkTimeout:
        stringStatus = BOOT_STATUS_NETWORK_TIMEOUT;
        break;
      case BootStatusNotAvailableVersion:
        stringStatus = BOOT_STATUS_NOT_AVAILABLE_VERSION;
        break;
      case BootStatusServiceUnderConstruction:
        stringStatus = BOOT_STATUS_SERVICE_UNDER_CONSTRUCTION;
        break;
      case BootStatusRequirePayment:
        stringStatus = BOOT_STATUS_REQUIRE_PAYMENT;
        break;
      case BootStatusAccessDenied:
        stringStatus = BOOT_STATUS_ACCESS_DENIED;
        break;
      default:
        stringStatus = BOOT_STATUS_UNKNOWN_ERROR;
        break;
    }
    
    if (status == BootStatusSuccess && user != nil) {
      resolve(@{KEY_STATUS: stringStatus, KEY_USER: user.toJson});
    } else {
      resolve(@{KEY_STATUS: stringStatus});
    }
  }];
}

RCT_EXPORT_METHOD(sleep) {
  [ChannelIO sleep];
}

RCT_EXPORT_METHOD(shutdown) {
  [ChannelIO shutdown];
}

RCT_EXPORT_METHOD(isBooted:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  resolve(@(ChannelIO.isBooted));
}

RCT_EXPORT_METHOD(initPushToken:(NSString *)token) {
  if (token == nil || [token isEqualToString: @""]) {
    return;
  }
  [ChannelIO initPushTokenWithTokenString:token];
}

RCT_EXPORT_METHOD(showChannelButton) {
  [ChannelIO showChannelButton];
}

RCT_EXPORT_METHOD(hideChannelButton) {
  [ChannelIO hideChannelButton];
}

RCT_EXPORT_METHOD(showMessenger) {
  [ChannelIO showMessenger];
}

RCT_EXPORT_METHOD(hideMessenger) {
  [ChannelIO hideMessenger];
}

RCT_EXPORT_METHOD(openChat:(NSString *)chatId message:(id)payload) {
  [ChannelIO openChatWith:chatId message:payload];
}

RCT_EXPORT_METHOD(track:(NSString *)name eventProperty:(NSDictionary *)properties) {
  [ChannelIO trackWithEventName:name eventProperty:properties];
}

RCT_EXPORT_METHOD(isChannelPushNotification:(NSDictionary *)userInfo
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  if ([ChannelIO isChannelPushNotification:userInfo]) {
    resolve(@(YES));
  } else {
    resolve(@(NO));
  }
}

RCT_EXPORT_METHOD(hasStoredPushNotification:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  resolve(@([ChannelIO hasStoredPushNotification]));
}

RCT_EXPORT_METHOD(receivePushNotification:(NSDictionary *)userInfo
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  [ChannelIO receivePushNotification:userInfo completion:^{
    resolve(@(YES));
  }];
}

#pragma mark Property setters

RCT_EXPORT_METHOD(updateUser:(NSDictionary<NSString *, id> *)userData
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  UpdateUserParamObjcBuilder *builder = [[UpdateUserParamObjcBuilder alloc] init];
  
  if ([[userData allKeys] containsObject:KEY_LANGUAGE]) {
    NSString *language = [RCTConvert NSString:userData[KEY_LANGUAGE]];
    if ([language isEqualToString:LANGUAGE_OPTION_KO]) {
      [builder withLanguage:LanguageOptionKorean];
    } else if ([language isEqualToString:LANGUAGE_OPTION_JA]) {
      [builder withLanguage:LanguageOptionJapanese];
    } else if ([language isEqualToString:LANGUAGE_OPTION_EN]) {
      [builder withLanguage:LanguageOptionEnglish];
    } else {
      [builder withLanguage:LanguageOptionDevice];
    }
  } else if ([[userData allKeys] containsObject:KEY_LOCALE]) {
    NSString *locale = [RCTConvert NSString:userData[KEY_LOCALE]];
    if ([locale isEqualToString:LANGUAGE_OPTION_KO]) {
      [builder withLanguage:LanguageOptionKorean];
    } else if ([locale isEqualToString:LANGUAGE_OPTION_JA]) {
      [builder withLanguage:LanguageOptionJapanese];
    } else if ([locale isEqualToString:LANGUAGE_OPTION_EN]) {
      [builder withLanguage:LanguageOptionEnglish];
    } else {
      [builder withLanguage:LanguageOptionDevice];
    }
  }
  
  if ([[userData allKeys] containsObject:KEY_PROFILE]) {
    if (userData[KEY_PROFILE] == NSNull.null) {
      [builder setProfileNil];
    } else {
      NSDictionary<NSString *, id> *profile = [RCTConvert NSDictionary:userData[KEY_PROFILE]];
      for (id key in profile) {
        [builder withProfileKey:key value:[profile objectForKey:key]];
      }
    }
  }
  
  if ([[userData allKeys] containsObject:KEY_PROFILE_ONCE]) {
    if (userData[KEY_PROFILE_ONCE] == NSNull.null) {
      [builder setProfileOnceNil];
    } else {
      NSDictionary<NSString *, id> *profileOnce = [RCTConvert NSDictionary:userData[KEY_PROFILE_ONCE]];
      for (id key in profileOnce) {
        [builder withProfileOnceKey:key value:[profileOnce objectForKey:key]];
      }
    }
  }
  
  if ([[userData allKeys] containsObject:KEY_TAGS]) {
    if (userData[KEY_TAGS] == NSNull.null) {
      [builder withTags:[NSArray array]];
    } else {
      [builder withTags:[RCTConvert NSArray:userData[KEY_TAGS]]];
    }
  }

  [ChannelIO updateUserWithParam:[builder build] completion:^(NSError *error, User *user) {
    NSMutableDictionary<NSString *, id> *result = [NSMutableDictionary dictionary];
    
    if (user != nil) {
      [result setValue:user.toJson forKey:KEY_USER];
    }
    
    if (error != nil) {
      [result setValue:error.description forKey:KEY_ERROR];
    }
    
    if ([[result allKeys] count] == 0) {
      [result setValue:ERROR_UNKNOWN forKey:KEY_ERROR];
    }
    
    resolve(result);
  }];
}

RCT_EXPORT_METHOD(addTags:(NSArray<NSString *> *)tags
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  [ChannelIO addTags:tags completion:^(NSError *error, User *user) {
    NSMutableDictionary<NSString *, id> *result = [NSMutableDictionary dictionary];
    
    if (user != nil) {
      [result setValue:user.toJson forKey:KEY_USER];
    }
    
    if (error != nil) {
      [result setValue:error.description forKey:KEY_ERROR];
    }
    
    if ([[result allKeys] count] == 0) {
      [result setValue:ERROR_UNKNOWN forKey:KEY_ERROR];
    }
    
    resolve(result);
  }];
}

RCT_EXPORT_METHOD(removeTags:(NSArray<NSString *> *)tags
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  [ChannelIO removeTags:tags completion:^(NSError *error, User *user) {
    NSMutableDictionary<NSString *, id> *result = [NSMutableDictionary dictionary];
    
    if (user != nil) {
      [result setValue:user.toJson forKey:KEY_USER];
    }
    
    if (error != nil) {
      [result setValue:error.description forKey:KEY_ERROR];
    }
    
    if ([[result allKeys] count] == 0) {
      [result setValue:ERROR_UNKNOWN forKey:KEY_ERROR];
    }
    
    resolve(result);
  }];
}

RCT_EXPORT_METHOD(setDebugMode:(BOOL)enable) {
  [ChannelIO setDebugModeWith:enable];
}

RCT_EXPORT_METHOD(openStoredPushNotification) {
  [ChannelIO openStoredPushNotification];
}

RCT_EXPORT_METHOD(handleUrlClicked:(NSURL *)url) {
  [CrossPlatformUtils openBrowserWithUrl:url];
}

RCT_EXPORT_METHOD(setPage:(NSString *)page) {
  [ChannelIO setPage:page];
}

RCT_EXPORT_METHOD(resetPage) {
  [ChannelIO resetPage];
}

RCT_EXPORT_METHOD(setAppearance:(NSString *)appearance) {
  if (appearance != nil) {
    if ([appearance isEqualToString:APPEARANCE_SYSTEM]) {
      [ChannelIO setAppearance:AppearanceSystem];
    } else if ([appearance isEqualToString:APPEARANCE_LIGHT]) {
      [ChannelIO setAppearance:AppearanceLight];
    } else if ([appearance isEqualToString:APPEARANCE_DARK]) {
      [ChannelIO setAppearance:AppearanceDark];
    }
  }
}

#pragma mark ChannelPluginDelegate
- (void)onBadgeChangedWithUnread:(NSInteger)unread alert:(NSInteger)alert {
  if (hasListeners) {
    [self sendEventWithName:EVENT_ON_BADGE_CHANGED body:@{KEY_UNREAD: @(unread), KEY_ALERT: @(alert)}];
  }
}

- (void)onPopupDataReceivedWithEvent:(PopupData *)event {
  if (hasListeners) {
    [self sendEventWithName:EVENT_ON_POPUP_DATA_RECEIVED body:@{KEY_POPUP: event.toJson}];
  }
}

- (BOOL)onUrlClickedWithUrl:(NSURL *)url {
  if (hasListeners) {
    [self sendEventWithName:EVENT_ON_PRE_URL_CLICKED body:@{KEY_URL: url.absoluteString}];
  }
  return true;
}

- (void)onFollowUpChangedWithData:(NSDictionary<NSString *,id> *)data {
  if (hasListeners) {
    [self sendEventWithName:EVENT_ON_FOLLOW_UP_CHANGED body:data];
  }
}

- (void)onShowMessenger {
  if (hasListeners) {
    [self sendEventWithName:EVENT_ON_SHOW_MESSENGER body:nil];
  }
}

- (void)onHideMessenger {
  if (hasListeners) {
    [self sendEventWithName:EVENT_ON_HIDE_MESSENGER body:nil];
  }
}

- (void)onChatCreatedWithChatId:(NSString *)chatId {
  if (hasListeners) {
    [self sendEventWithName:EVENT_ON_CHAT_CREATED body:@{KEY_CHAT_ID: chatId}];
  }
}

@end

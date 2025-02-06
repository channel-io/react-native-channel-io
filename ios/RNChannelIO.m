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
      KEY_LANGUAGE_KOREAN: @(CHTLanguageOptionKorean),
      KEY_LANGUAGE_ENGLISH: @(CHTLanguageOptionEnglish),
      KEY_LANGUAGE_JAPANESE: @(CHTLanguageOptionJapanese),
      KEY_LANGUAGE_DEVICE: @(CHTLanguageOptionDevice)
    },
    BOOT_STATUS: @{
      KEY_BOOT_STATUS_SUCCESS: @(CHTBootStatusSuccess),
      KEY_BOOT_STATUS_NOT_INITIALIZED: @(CHTBootStatusNotInitialized),
      KEY_BOOT_STATUS_NETWORK_TIMEOUT: @(CHTBootStatusNetworkTimeout),
      KEY_BOOT_STATUS_NOT_AVAILABLE_VERSION: @(CHTBootStatusNotAvailableVersion),
      KEY_BOOT_STATUS_SERVICE_UNDER_CONSTRUCTION: @(CHTBootStatusServiceUnderConstruction),
      KEY_BOOT_STATUS_REQUIRE_PAYMENT: @(CHTBootStatusRequirePayment),
      KEY_BOOT_STATUS_ACCESS_DENIED: @(CHTBootStatusAccessDenied),
      KEY_BOOT_STATUS_UNKNOWN_ERROR: @(CHTBootStatusUnknown)
    },
    CHANNEL_BUTTON_ICON: @{
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHANNEL: @(CHTChannelButtonIconChannel),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_FILLED: @(CHTChannelButtonIconChatBubbleFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS_FILLED: @(CHTChannelButtonIconChatProgressFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION_FILLED: @(CHTChannelButtonIconChatQuestionFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_LIGHTNING_FILLED: @(CHTChannelButtonIconChatLightningFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT_FILLED: @(CHTChannelButtonIconChatBubbleAltFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_SMS_FILLED: @(CHTChannelButtonIconSmsFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_COMMENT_FILLED: @(CHTChannelButtonIconCommentFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD_FILLED: @(CHTChannelButtonIconSendForwardFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_HELP_FILLED: @(CHTChannelButtonIconHelpFilled),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS: @(CHTChannelButtonIconChatProgress),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION: @(CHTChannelButtonIconChatQuestion),
      KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT: @(CHTChannelButtonIconChatBubbleAlt),
      KEY_CHANNEL_BUTTON_OPTION_ICON_SMS: @(CHTChannelButtonIconSms),
      KEY_CHANNEL_BUTTON_OPTION_ICON_COMMENT: @(CHTChannelButtonIconComment),
      KEY_CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD: @(CHTChannelButtonIconSendForward),
      KEY_CHANNEL_BUTTON_OPTION_ICON_COMMUNICATION: @(CHTChannelButtonIconCommunication),
      KEY_CHANNEL_BUTTON_OPTION_ICON_HEADSET: @(CHTChannelButtonIconHeadset)
    },
    CHANNEL_BUTTON_POSITION: @{
      KEY_CHANNEL_BUTTON_OPTION_POSITION_RIGHT: @(CHTChannelButtonPositionRight),
      KEY_CHANNEL_BUTTON_OPTION_POSITION_LEFT: @(CHTChannelButtonPositionLeft)
    },
    CHANNEL_APPEARANCE: @{
      KEY_APPEARANCE_SYSTEM: @(CHTAppearanceSystem),
      KEY_APPEARANCE_DARK: @(CHTAppearanceDark),
      KEY_APPEARANCE_LIGHT: @(CHTAppearanceLight)
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
  CHTBootConfig * config = [RCTConvert bootConfig:bootConfig];
  
  [ChannelIO bootWith:config completion:^(CHTBootStatus status, CHTUser *user) {
    NSString * stringStatus = BOOT_STATUS_UNKNOWN_ERROR;
    switch (status) {
      case CHTBootStatusSuccess:
        stringStatus = BOOT_STATUS_SUCCESS;
        break;
      case CHTBootStatusNotInitialized:
        stringStatus = BOOT_STATUS_NOT_INITIALIZED;
        break;
      case CHTBootStatusNetworkTimeout:
        stringStatus = BOOT_STATUS_NETWORK_TIMEOUT;
        break;
      case CHTBootStatusNotAvailableVersion:
        stringStatus = BOOT_STATUS_NOT_AVAILABLE_VERSION;
        break;
      case CHTBootStatusServiceUnderConstruction:
        stringStatus = BOOT_STATUS_SERVICE_UNDER_CONSTRUCTION;
        break;
      case CHTBootStatusRequirePayment:
        stringStatus = BOOT_STATUS_REQUIRE_PAYMENT;
        break;
      case CHTBootStatusAccessDenied:
        stringStatus = BOOT_STATUS_ACCESS_DENIED;
        break;
      default:
        stringStatus = BOOT_STATUS_UNKNOWN_ERROR;
        break;
    }
    
    if (status == CHTBootStatusSuccess && user != nil) {
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

RCT_EXPORT_METHOD(openWorkflow:(NSString *)workflowId) {
  [ChannelIO openWorkflowWith:workflowId];
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
  CHTUpdateUserParamObjcBuilder *builder = [[CHTUpdateUserParamObjcBuilder alloc] init];
  
  if ([[userData allKeys] containsObject:KEY_LANGUAGE]) {
    NSString *language = [RCTConvert NSString:userData[KEY_LANGUAGE]];
    if ([language isEqualToString:LANGUAGE_OPTION_KO]) {
      [builder withLanguage:CHTLanguageOptionKorean];
    } else if ([language isEqualToString:LANGUAGE_OPTION_JA]) {
      [builder withLanguage:CHTLanguageOptionJapanese];
    } else if ([language isEqualToString:LANGUAGE_OPTION_EN]) {
      [builder withLanguage:CHTLanguageOptionEnglish];
    } else {
      [builder withLanguage:CHTLanguageOptionDevice];
    }
  } else if ([[userData allKeys] containsObject:KEY_LOCALE]) {
    NSString *locale = [RCTConvert NSString:userData[KEY_LOCALE]];
    if ([locale isEqualToString:LANGUAGE_OPTION_KO]) {
      [builder withLanguage:CHTLanguageOptionKorean];
    } else if ([locale isEqualToString:LANGUAGE_OPTION_JA]) {
      [builder withLanguage:CHTLanguageOptionJapanese];
    } else if ([locale isEqualToString:LANGUAGE_OPTION_EN]) {
      [builder withLanguage:CHTLanguageOptionEnglish];
    } else {
      [builder withLanguage:CHTLanguageOptionDevice];
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
  
  [ChannelIO updateUserWithParam:[builder build] completion:^(NSError *error, CHTUser *user) {
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
  [ChannelIO addTags:tags completion:^(NSError *error, CHTUser *user) {
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
  [ChannelIO removeTags:tags completion:^(NSError *error, CHTUser *user) {
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
  [ChannelIO setPage:page profile:[[NSDictionary alloc] init]];
}

RCT_EXPORT_METHOD(setPage:(NSString *)page profile:(NSDictionary<NSString *, id> *)profile) {
  [ChannelIO setPage:page profile:profile];
}

RCT_EXPORT_METHOD(resetPage) {
  [ChannelIO resetPage];
}

RCT_EXPORT_METHOD(setAppearance:(NSString *)appearance) {
  if (appearance != nil) {
    if ([appearance isEqualToString:APPEARANCE_SYSTEM]) {
      [ChannelIO setAppearance:CHTAppearanceSystem];
    } else if ([appearance isEqualToString:APPEARANCE_LIGHT]) {
      [ChannelIO setAppearance:CHTAppearanceLight];
    } else if ([appearance isEqualToString:APPEARANCE_DARK]) {
      [ChannelIO setAppearance:CHTAppearanceDark];
    }
  }
}

RCT_EXPORT_METHOD(hidePopup) {
  [ChannelIO hidePopup];
}

#pragma mark ChannelPluginDelegate
- (void)onBadgeChangedWithUnread:(NSInteger)unread alert:(NSInteger)alert {
  if (hasListeners) {
    [self sendEventWithName:EVENT_ON_BADGE_CHANGED body:@{KEY_UNREAD: @(unread), KEY_ALERT: @(alert)}];
  }
}

- (void)onPopupDataReceivedWithEvent:(CHTPopupData *)event {
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

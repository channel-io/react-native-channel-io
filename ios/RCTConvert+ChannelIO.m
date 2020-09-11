//
//  RNChannelModels.m
//  RNExample
//
//  Created by Haeun Chung on 28/09/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

#import "RCTConvert+ChannelIO.h"

@implementation RCTConvert (ChannelIOEnums)

RCT_ENUM_CONVERTER(
  LanguageOption,
  (@{LANGUAGE_OPTION_KO: @(LanguageOptionKorean),
    LANGUAGE_OPTION_EN: @(LanguageOptionEnglish),
    LANGUAGE_OPTION_JA: @(LanguageOptionJapanese),
    LANGUAGE_OPTION_DEVICE: @(LanguageOptionDevice)
  }),
  LanguageOptionDevice,
  integerValue
)

RCT_ENUM_CONVERTER(
  BootStatus,
  (@{BOOT_STATUS_SUCCESS: @(BootStatusSuccess),
    BOOT_STATUS_NOT_INITIALIZED: @(BootStatusNotInitialized),
    BOOT_STATUS_NETWORK_TIMEOUT: @(BootStatusNetworkTimeout),
    BOOT_STATUS_NOT_AVAILABLE_VERSION: @(BootStatusNotAvailableVersion),
    BOOT_STATUS_SERVICE_UNDER_CONSTRUCTION: @(BootStatusServiceUnderConstruction),
    BOOT_STATUS_REQUIRE_PAYMENT: @(BootStatusRequirePayment),
    BOOT_STATUS_ACCESS_DENIED: @(BootStatusAccessDenied),
    BOOT_STATUS_UNKNOWN_ERROR: @(BootStatusUnknown)
  }),
  BootStatusNotInitialized,
  integerValue
)

RCT_ENUM_CONVERTER(
  ChannelButtonPosition,
  (@{CHANNEL_BUTTON_OPTION_POSITION_RIGHT: @(ChannelButtonPositionRight),
    CHANNEL_BUTTON_OPTION_POSITION_LEFT: @(ChannelButtonPositionLeft)
  }),
  ChannelButtonPositionRight,
  integerValue
)

@end

@implementation RCTConvert (ChannelIO)

+ (BootConfig *)bootConfig:(id)json {
  BootConfig *settings = [[BootConfig alloc] init];
  settings.pluginKey = [RCTConvert NSString:json[KEY_PLUGIN_KEY]];
  settings.memberHash = [RCTConvert NSString:json[KEY_MEMBER_HASH]];
  settings.hidePopup = json[KEY_HIDE_POPUP] == nil
    ? [RCTConvert BOOL:json[KEY_HIDE_DEFAULT_IN_APP_PUSH]] : [RCTConvert BOOL:json[KEY_HIDE_POPUP]];
  settings.trackDefaultEvent = json[KEY_TRACK_DEFAULT_EVENT] == nil
    ? [RCTConvert BOOL:json[KEY_ENABLED_TRACK_DEFAULT_EVENT]]
    : [RCTConvert BOOL:json[KEY_TRACK_DEFAULT_EVENT]];
  
  if (json[KEY_LAUNCHER_CONFIG] == nil && json[KEY_CHANNEL_BUTTON_OPTION] != nil) {
    settings.channelButtonOption = [RCTConvert channelButtonOption:json[KEY_CHANNEL_BUTTON_OPTION]];
  } else if (json[KEY_LAUNCHER_CONFIG] != nil && json[KEY_CHANNEL_BUTTON_OPTION] == nil) {
    settings.channelButtonOption = [RCTConvert channelButtonOption:json[KEY_LAUNCHER_CONFIG]];
  }
  
  if (json[KEY_MEMBER_ID] == nil && json[KEY_USER_ID] != nil) {
    settings.memberId = [RCTConvert NSString:json[KEY_USER_ID]];
  } else {
    settings.memberId = [RCTConvert NSString:json[KEY_MEMBER_ID]];
  }
  
  NSString *language = [RCTConvert NSString:json[KEY_LANGUAGE]];
  NSString *locale = [RCTConvert NSString:json[KEY_LOCALE]];
  if (json[KEY_LOCALE] != nil) {
    if ([locale isEqualToString:LANGUAGE_OPTION_KO]) {
      settings.language = LanguageOptionKorean;
    } else if ([locale isEqualToString:LANGUAGE_OPTION_JA]) {
      settings.language = LanguageOptionJapanese;
    } else if ([locale isEqualToString:LANGUAGE_OPTION_EN]) {
      settings.language = LanguageOptionEnglish;
    } else {
      settings.language = LanguageOptionDevice;
    }
  } else {
    if ([language isEqualToString:LANGUAGE_OPTION_KO]) {
      settings.language = LanguageOptionKorean;
    } else if ([language isEqualToString:LANGUAGE_OPTION_JA]) {
      settings.language = LanguageOptionJapanese;
    } else if ([language isEqualToString:LANGUAGE_OPTION_EN]) {
      settings.language = LanguageOptionEnglish;
    } else {
      settings.language = LanguageOptionDevice;
    }
  }
  
  if (json[KEY_PROFILE] != nil) {
    settings.profile = [RCTConvert profile:json[KEY_PROFILE]];
  }
  
  return settings;
}

+ (Profile *)profile:(NSDictionary *)json {
  if (json == nil) {
    return nil;
  }
  
  Profile *profile = [[Profile alloc] init];
  [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id obj, BOOL * _Nonnull stop) {
    [profile setWithPropertyKey:key value:obj];
  }];
  
  return profile;
}

+ (ChannelButtonOption *)channelButtonOption:(id)json {
  if (json == nil) {
    return nil;
  }
  
  ChannelButtonOption *config = [[ChannelButtonOption alloc] init];
  
  config.xMargin = [RCTConvert float:json[CHANNEL_BUTTON_OPTION_X_MARGIN]];
  config.yMargin = [RCTConvert float:json[CHANNEL_BUTTON_OPTION_Y_MARGIN]];
  NSString *position = [RCTConvert NSString:json[CHANNEL_BUTTON_OPTION_POSITION]];
  if ([position isEqualToString:CHANNEL_BUTTON_OPTION_POSITION_LEFT]) {
    config.position = ChannelButtonPositionLeft;
  } else {
    config.position = ChannelButtonPositionRight;
  }
  return config;
}

@end


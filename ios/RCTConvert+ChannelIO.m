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

RCT_ENUM_CONVERTER(
  BubblePosition,
  (@{BUBBLE_OPTION_POSITION_TOP: @(BubblePositionTop),
     BUBBLE_OPTION_POSITION_BOTTOM: @(BubblePositionBottom)
  }),
  BubblePositionTop,
  integerValue
)

RCT_ENUM_CONVERTER(
  Appearance,
  (@{APPEARANCE_SYSTEM: @(AppearanceSystem),
     APPEARANCE_DARK: @(AppearanceDark),
     APPEARANCE_LIGHT: @(AppearanceLight)
  }),
  AppearanceSystem,
  integerValue
)

@end

@implementation RCTConvert (ChannelIO)

+ (BootConfig *)bootConfig:(id)json {
  BootConfig *config = [[BootConfig alloc] init];
  config.pluginKey = [RCTConvert NSString:json[KEY_PLUGIN_KEY]];
  config.memberHash = [RCTConvert NSString:json[KEY_MEMBER_HASH]];
  config.hidePopup = json[KEY_HIDE_POPUP] != nil
    ? [RCTConvert BOOL:json[KEY_HIDE_POPUP]] : [RCTConvert BOOL:json[KEY_HIDE_DEFAULT_IN_APP_PUSH]];
  config.trackDefaultEvent = json[KEY_TRACK_DEFAULT_EVENT] != nil
    ? [RCTConvert BOOL:json[KEY_TRACK_DEFAULT_EVENT]] : [RCTConvert BOOL:json[KEY_ENABLED_TRACK_DEFAULT_EVENT]];
  config.bubbleOption = [RCTConvert bubbleOption:json[KEY_BUBBLE_OPTION]];

  if (json[KEY_UNSUBSCRIBE_EMAIL] != nil) {
    [config setWithUnsubscribeEmail: [RCTConvert BOOL:json[KEY_UNSUBSCRIBE_EMAIL]]];
  }

  if (json[KEY_UNSUBSCRIBE_TEXTING] != nil) {
    [config setWithUnsubscribeTexting: [RCTConvert BOOL:json[KEY_UNSUBSCRIBE_TEXTING]]];
  }

  if (json[KEY_CHANNEL_BUTTON_OPTION] != nil) {
    config.channelButtonOption = [RCTConvert channelButtonOption:json[KEY_CHANNEL_BUTTON_OPTION]];
  } else if (json[KEY_LAUNCHER_CONFIG] != nil) {
    config.channelButtonOption = [RCTConvert channelButtonOption:json[KEY_LAUNCHER_CONFIG]];
  }
  
  if (json[KEY_MEMBER_ID] != nil) {
    config.memberId = [RCTConvert NSString:json[KEY_MEMBER_ID]];
  } else if (json[KEY_USER_ID] != nil) {
    config.memberId = [RCTConvert NSString:json[KEY_USER_ID]];
  }
  
  NSString *language = [RCTConvert NSString:json[KEY_LANGUAGE]];
  NSString *locale = [RCTConvert NSString:json[KEY_LOCALE]];
  if (json[KEY_LOCALE] != nil) {
    if ([locale isEqualToString:LANGUAGE_OPTION_KO]) {
      config.language = LanguageOptionKorean;
    } else if ([locale isEqualToString:LANGUAGE_OPTION_JA]) {
      config.language = LanguageOptionJapanese;
    } else if ([locale isEqualToString:LANGUAGE_OPTION_EN]) {
      config.language = LanguageOptionEnglish;
    } else {
      config.language = LanguageOptionDevice;
    }
  } else {
    if ([language isEqualToString:LANGUAGE_OPTION_KO]) {
      config.language = LanguageOptionKorean;
    } else if ([language isEqualToString:LANGUAGE_OPTION_JA]) {
      config.language = LanguageOptionJapanese;
    } else if ([language isEqualToString:LANGUAGE_OPTION_EN]) {
      config.language = LanguageOptionEnglish;
    } else {
      config.language = LanguageOptionDevice;
    }
  }
  
  if (json[KEY_PROFILE] != nil) {
    config.profile = [RCTConvert profile:json[KEY_PROFILE]];
  }
  
  NSString *appearance = [RCTConvert NSString:json[KEY_APPEARANCE]];
  if (json[KEY_APPEARANCE] != nil) {
    if ([appearance isEqualToString:APPEARANCE_SYSTEM]) {
      [config setWithAppearance:AppearanceSystem];
    } else if ([appearance isEqualToString:APPEARANCE_LIGHT]) {
      [config setWithAppearance:AppearanceLight];
    } else if ([appearance isEqualToString:APPEARANCE_DARK]) {
      [config setWithAppearance:AppearanceDark];
    }
  }
  
  return config;
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
  
  ChannelButtonOption *option = [[ChannelButtonOption alloc] init];
  
  option.xMargin = [RCTConvert float:json[CHANNEL_BUTTON_OPTION_X_MARGIN]];
  option.yMargin = [RCTConvert float:json[CHANNEL_BUTTON_OPTION_Y_MARGIN]];
  NSString *position = [RCTConvert NSString:json[CHANNEL_BUTTON_OPTION_POSITION]];
  if ([position isEqualToString:CHANNEL_BUTTON_OPTION_POSITION_LEFT]) {
    option.position = ChannelButtonPositionLeft;
  } else {
    option.position = ChannelButtonPositionRight;
  }
  return option;
}

+ (BubbleOption *)bubbleOption:(id)json {
  if (json == nil) {
    return nil;
  }
  
  BubbleOption *option = [[BubbleOption alloc] init];
  
  option.yMargin = [RCTConvert NSNumber:json[BUBBLE_OPTION_Y_MARGIN]];
  NSString *position = [RCTConvert NSString:json[BUBBLE_OPTION_POSITION]];
  if ([position isEqualToString:BUBBLE_OPTION_POSITION_TOP]) {
    option.position = BubblePositionTop;
  } else {
    option.position = BubblePositionBottom;
  }
  return option;
}

@end

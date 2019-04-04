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
  CHLocale,
  (@{@"ko": @(CHLocaleKorean),
    @"en": @(CHLocaleEnglish),
    @"ja": @(CHLocaleJapanese),
    @"device": @(CHLocaleDevice)
  }),
  CHLocaleDevice,
  integerValue
)

RCT_ENUM_CONVERTER(
  ChannelPluginCompletionStatus,
  (@{@"SUCCESS": @(ChannelPluginCompletionStatusSuccess),
    @"UNKNOWN_ERROR": @(ChannelPluginCompletionStatusUnknown),
    @"ACCESS_DENIED": @(ChannelPluginCompletionStatusAccessDenied),
    @"NETWORK_TIMEOUT": @(ChannelPluginCompletionStatusNetworkTimeout),
    @"REQUIRE_PAYMENT": @(ChannelPluginCompletionStatusRequirePayment),
    @"NOT_INITIALIZED": @(ChannelPluginCompletionStatusNotInitialized),
    @"SERVICE_UNDER_CONSTRUCTION": @(ChannelPluginCompletionStatusServiceUnderConstruction)
  }),
  ChannelPluginCompletionStatusNotInitialized,
  integerValue
)

RCT_ENUM_CONVERTER(
  LauncherPosition,
  (@{@"right": @(LauncherPositionRight),
    @"left": @(LauncherPositionLeft)
  }),
  LauncherPositionRight,
  integerValue
)

@end

@implementation RCTConvert (ChannelIO)

+ (ChannelPluginSettings *)settings:(id)json {
  ChannelPluginSettings *settings = [[ChannelPluginSettings alloc] init];
  settings.pluginKey = [RCTConvert NSString:json[@"pluginKey"]];
  settings.debugMode = [RCTConvert BOOL:json[@"debugMode"]];
  settings.hideDefaultInAppPush = [RCTConvert BOOL:json[@"hideDefaultInAppPush"]];
  settings.launcherConfig = [RCTConvert launcherConfig:json[@"launcherConfig"]];
  settings.userId = [RCTConvert NSString:json[@"userId"]];
  
  NSString *locale = [RCTConvert NSString:json[@"locale"]];
  if ([locale isEqualToString:@"ko"]) {
    settings.locale = CHLocaleKorean;
  } else if ([locale isEqualToString:@"ja"]) {
    settings.locale = CHLocaleJapanese;
  } else if ([locale isEqualToString:@"en"]) {
    settings.locale = CHLocaleEnglish;
  } else {
    settings.locale = CHLocaleDevice;
  }
  return settings;
}

+ (Profile *)profile:(NSDictionary *)json {
  if (json == nil) {
    return nil;
  }
  
  Profile *profile = [[Profile alloc] init];
  [profile setWithName:[RCTConvert NSString:json[@"name"]]];
  [profile setWithEmail:[RCTConvert NSString:json[@"email"]]];
  [profile setWithAvatarUrl:[RCTConvert NSString:json[@"avatarUrl"]]];
  [profile setWithMobileNumber:[RCTConvert NSString:json[@"mobileNumber"]]];
  
  [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    if (![key isEqual:@"name"] &&
        ![key isEqual:@"email"] &&
        ![key isEqual:@"avatarUrl"] &&
        ![key isEqual:@"mobileNumber"]) {
      [profile setWithPropertyKey:key value:obj];
    }
  }];
  
  return profile;
}

+ (LauncherConfig *)launcherConfig:(id)json {
  if (json == nil) {
    return nil;
  }
  
  LauncherConfig *config = [[LauncherConfig alloc] init];
  
  config.xMargin = [RCTConvert float:json[@"xMargin"]];
  config.yMargin = [RCTConvert float:json[@"yMargin"]];
  NSString *position = [RCTConvert NSString:@"position"];
  if ([position isEqualToString:@"left"]) {
    config.position = LauncherPositionLeft;
  } else {
    config.position = LauncherPositionRight;
  }
  return config;
}

@end


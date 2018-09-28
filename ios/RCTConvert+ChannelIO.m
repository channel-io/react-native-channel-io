//
//  RNChannelModels.m
//  RNExample
//
//  Created by Haeun Chung on 28/09/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RCTConvert+ChannelIO.h"

@implementation RCTConvert (ChannelIOEnums)

RCT_ENUM_CONVERTER(
  CHLocale,
  (@{@"korean": @(CHLocaleKorean),
    @"english": @(CHLocaleEnglish),
    @"japanese": @(CHLocaleJapanese),
    @"device": @(CHLocaleDevice)
  }),
  CHLocaleDevice,
  integerValue
)

RCT_ENUM_CONVERTER(
  ChannelPluginCompletionStatus,
  (@{@"success": @(ChannelPluginCompletionStatusSuccess),
    @"unknown": @(ChannelPluginCompletionStatusUnknown),
    @"accessDenied": @(ChannelPluginCompletionStatusAccessDenied),
    @"timeout": @(ChannelPluginCompletionStatusNetworkTimeout),
    @"requirePayment": @(ChannelPluginCompletionStatusRequirePayment),
    @"notInitialized": @(ChannelPluginCompletionStatusNotInitialized)
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
  //settings.locale = [RCTConvert int:json[@"locale"]];
  settings.launcherConfig = [RCTConvert launcherConfig:json[@"launcherConfig"]];
  settings.userId = [RCTConvert NSString:json[@"userId"]];
  
  return settings;
}

+ (Profile *)profile:(id)json {
  if (json == nil) {
    return nil;
  }
  
  Profile *profile = [[Profile alloc] init];
  [profile setWithName:[RCTConvert NSString:json[@"name"]]];
  [profile setWithEmail:[RCTConvert NSString:json[@"email"]]];
  [profile setWithAvatarUrl:[RCTConvert NSString:json[@"avatarUrl"]]];
  [profile setWithMobileNumber:[RCTConvert NSString:json[@"mobileNumber"]]];
  
  NSDictionary *otherParams = [RCTConvert NSDictionary:json[@"property"]];
  [otherParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    [profile setWithPropertyKey:key value:obj];
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
  config.position = [RCTConvert int:json[@"position"]];
  return config;
}

@end


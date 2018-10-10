//
//  RNChannelIO.m
//  RNExample
//
//  Created by Haeun Chung on 28/09/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RNChannelIO.h"
#import "RCTConvert+ChannelIO.h"

#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>

@implementation RNChannelIO

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (NSDictionary *)constantsToExport {
  return @{
     @"Event": @{
         @"ON_CHANGE_BADGE": ON_CHANGE_BADGE,
         @"ON_RECEIVE_PUSH": ON_RECEIVE_PUSH,
         @"WILL_OPEN_MESSENGER": WILL_OPEN_MESSENGER,
         @"WILL_CLOSE_MESSENGER": WILL_CLOSE_MESSENGER,
         @"ON_CLICK_CHAT_LINK": ON_CLICK_CHAT_LINK
     },
     @"Locale": @{
         @"korean": @(CHLocaleKorean),
         @"japanese": @(CHLocaleJapanese),
         @"english": @(CHLocaleEnglish),
         @"device": @(CHLocaleDevice)
     },
     @"BootStatus": @{
         @"success": @(ChannelPluginCompletionStatusSuccess),
         @"unknown": @(ChannelPluginCompletionStatusUnknown),
         @"accessDenied": @(ChannelPluginCompletionStatusAccessDenied),
         @"timeout": @(ChannelPluginCompletionStatusNetworkTimeout),
         @"requirePayment": @(ChannelPluginCompletionStatusRequirePayment),
         @"notInitialized": @(ChannelPluginCompletionStatusNotInitialized)
     },
     @"LauncherPosition": @{
         @"right": @(LauncherPositionRight),
         @"left": @(LauncherPositionLeft)
     }
  };
}

RCT_EXPORT_METHOD(boot:(id)settings
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  ChannelPluginSettings * pluginSettings = [RCTConvert settings:settings];
  Profile *userProfile = [RCTConvert profile:settings[@"profile"]];
  [ChannelIO bootWith:pluginSettings profile:userProfile completion:^(ChannelPluginCompletionStatus status, Guest *guest) {
    resolve(@{@"status": @(status), @"guest": guest == nil ? guest : NSNull.null });
  }];
}

RCT_EXPORT_METHOD(shutdown) {
  [ChannelIO shutdown];
}

RCT_EXPORT_METHOD(initPushToken:(NSData *)tokenData) {
  [ChannelIO initPushTokenWithDeviceToken:tokenData];
}

RCT_EXPORT_METHOD(show:(BOOL)animated) {
  [ChannelIO showWithAnimated:animated];
}

RCT_EXPORT_METHOD(hide:(BOOL)animated) {
  [ChannelIO hideWithAnimated:animated];
}

RCT_EXPORT_METHOD(open:(BOOL)animated) {
  [ChannelIO openWithAnimated:animated];
}

RCT_EXPORT_METHOD(close:(BOOL)animated) {
  [ChannelIO closeWithAnimated:animated completion:^{}];
}

RCT_EXPORT_METHOD(openChat:(NSString *)chatId animated:(BOOL)animated) {
  [ChannelIO openChatWith:chatId animated:animated];
}

RCT_EXPORT_METHOD(track:(NSString *)name eventProperty:(NSDictionary *)properties) {
  [ChannelIO trackWithEventName:name eventProperty:properties];
}

RCT_EXPORT_METHOD(isChannelPushNotification:(NSDictionary *)userInfo
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseResolveBlock)reject) {
  if ([ChannelIO isChannelPushNotification:userInfo]) {
    resolve(@(YES));
  } else {
    resolve(@(NO));
  }
}

RCT_EXPORT_METHOD(handlePushNotification:(NSDictionary *)userInfo) {
  [ChannelIO handlePushNotification:userInfo];
}

@end

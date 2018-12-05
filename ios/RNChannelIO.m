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
     @"Event": @{
         @"ON_CHANGE_BADGE": ON_CHANGE_BADGE,
         @"ON_RECEIVE_PUSH": ON_RECEIVE_PUSH,
         @"WILL_SHOW_MESSENGER": WILL_SHOW_MESSENGER,
         @"WILL_HIDE_MESSENGER": WILL_HIDE_MESSENGER,
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

- (NSArray<NSString *> *)supportedEvents {
  return @[
     ON_CHANGE_BADGE,
     ON_RECEIVE_PUSH,
     WILL_SHOW_MESSENGER,
     WILL_HIDE_MESSENGER,
     ON_CLICK_CHAT_LINK
  ];
}


RCT_EXPORT_METHOD(boot:(id)settings
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  ChannelPluginSettings * pluginSettings = [RCTConvert settings:settings];
  Profile *userProfile = [RCTConvert profile:settings[@"profile"]];
  [ChannelIO bootWith:pluginSettings profile:userProfile completion:^(ChannelPluginCompletionStatus status, Guest *guest) {
    resolve(@{@"status": @(status), @"guest": guest != nil ? guest.toJson : NSNull.null });
  }];
}

RCT_EXPORT_METHOD(shutdown) {
  [ChannelIO shutdown];
}

RCT_EXPORT_METHOD(initPushToken:(NSString *)token) {
  if (token == nil || [token isEqualToString: @""]) {
    return;
  }
  NSData *data = [token dataUsingEncoding:NSUTF8StringEncoding];
  [ChannelIO initPushTokenWithDeviceToken:data];
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
                  rejecter:(RCTPromiseRejectBlock)reject) {
  if ([ChannelIO isChannelPushNotification:userInfo]) {
    resolve(@(YES));
  } else {
    resolve(@(NO));
  }
}

RCT_EXPORT_METHOD(handlePushNotification:(NSDictionary *)userInfo
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  [ChannelIO handlePushNotification:userInfo completion:^{
    resolve(@(YES));
  }];
}

RCT_EXPORT_METHOD(setLinkHandle:(BOOL)handle) {
  handleChatLink = handle;
}

#pragma mark ChannelPluginDelegate

- (void)onChangeBadgeWithCount:(NSInteger)count {
  if (hasListeners) {
    [self sendEventWithName:ON_CHANGE_BADGE body:@{@"count": @(count)}];
  }
}

- (void)onReceivePushWithEvent:(PushEvent *)event {
  if (hasListeners) {
    [self sendEventWithName:ON_RECEIVE_PUSH body:@{@"push": event.toJson}];
  }
}

- (BOOL)onClickChatLinkWithUrl:(NSURL *)url {
  if (hasListeners) {
    [self sendEventWithName:ON_CLICK_CHAT_LINK body:@{@"link": url.absoluteString}];
    return handleChatLink;
  }
  return handleChatLink;
}

- (void)willOpenMessenger {
  if (hasListeners) {
    [self sendEventWithName:WILL_SHOW_MESSENGER body:nil];
  }
}

- (void)willCloseMessenger {
  if (hasListeners) {
    [self sendEventWithName:WILL_HIDE_MESSENGER body:nil];
  }
}

@end

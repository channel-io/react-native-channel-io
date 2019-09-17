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

static NSString * const ON_CHANGE_BADGE = @"ChannelIO:Event:OnChangeBadge";
static NSString * const ON_RECEIVE_PUSH = @"ChannelIO:Event:OnReceivePush";
static NSString * const WILL_SHOW_MESSENGER = @"ChannelIO:Event:WillShowMessenger";
static NSString * const WILL_HIDE_MESSENGER = @"ChannelIO:Event:WillHideMessenger";
static NSString * const ON_CLICK_CHAT_LINK = @"ChannelIO:Event:OnClickChatLink";
static NSString * const ON_CLICK_REDIRECT_LINK = @"ChannelIO:Event:OnClickRedirectLink";
static NSString * const ON_CHANGE_PROFILE = @"ChannelIO:Event:OnChangeProfile";

NS_ASSUME_NONNULL_END


//
//  RNChannelEventEmitter.h
//  RNExample
//
//  Created by Haeun Chung on 28/09/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <ChannelIO/ChannelIO-Swift.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNChannelEventEmitter: RCTEventEmitter <RCTBridgeModule, ChannelPluginDelegate>
@end

NS_ASSUME_NONNULL_END

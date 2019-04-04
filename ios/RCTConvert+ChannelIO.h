//
//  RNChannelModels.h
//  RNExample
//
//  Created by Haeun Chung on 28/09/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTConvert.h>
#import <ChannelIO/ChannelIO-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTConvert (ChannelIO)
+ (ChannelPluginSettings *)settings:(id)json;
+ (Profile *)profile:(id)json;
+ (LauncherConfig *)launcherConfig:(id)json;
@end

NS_ASSUME_NONNULL_END

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
                   CHTLanguageOption,
                   (@{LANGUAGE_OPTION_KO: @(CHTLanguageOptionKorean),
                      LANGUAGE_OPTION_EN: @(CHTLanguageOptionEnglish),
                      LANGUAGE_OPTION_JA: @(CHTLanguageOptionJapanese),
                      LANGUAGE_OPTION_DEVICE: @(CHTLanguageOptionDevice)
                    }),
                   CHTLanguageOptionDevice,
                   integerValue
                   )

RCT_ENUM_CONVERTER(
                   CHTBootStatus,
                   (@{BOOT_STATUS_SUCCESS: @(CHTBootStatusSuccess),
                      BOOT_STATUS_NOT_INITIALIZED: @(CHTBootStatusNotInitialized),
                      BOOT_STATUS_NETWORK_TIMEOUT: @(CHTBootStatusNetworkTimeout),
                      BOOT_STATUS_NOT_AVAILABLE_VERSION: @(CHTBootStatusNotAvailableVersion),
                      BOOT_STATUS_SERVICE_UNDER_CONSTRUCTION: @(CHTBootStatusServiceUnderConstruction),
                      BOOT_STATUS_REQUIRE_PAYMENT: @(CHTBootStatusRequirePayment),
                      BOOT_STATUS_ACCESS_DENIED: @(CHTBootStatusAccessDenied),
                      BOOT_STATUS_UNKNOWN_ERROR: @(CHTBootStatusUnknown)
                    }),
                   CHTBootStatusNotInitialized,
                   integerValue
                   )

RCT_ENUM_CONVERTER(
                   CHTChannelButtonIcon,
                   (@{CHANNEL_BUTTON_OPTION_ICON_CHANNEL: @(CHTChannelButtonIconChannel),
                      CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_FILLED: @(CHTChannelButtonIconChatBubbleFilled),
                      CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS_FILLED: @(CHTChannelButtonIconChatProgressFilled),
                      CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION_FILLED: @(CHTChannelButtonIconChatQuestionFilled),
                      CHANNEL_BUTTON_OPTION_ICON_CHAT_LIGHTNING_FILLED: @(CHTChannelButtonIconChatLightningFilled),
                      CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT_FILLED: @(CHTChannelButtonIconChatBubbleAltFilled),
                      CHANNEL_BUTTON_OPTION_ICON_SMS_FILLED: @(CHTChannelButtonIconSmsFilled),
                      CHANNEL_BUTTON_OPTION_ICON_COMMENT_FILLED: @(CHTChannelButtonIconCommentFilled),
                      CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD_FILLED: @(CHTChannelButtonIconSendForwardFilled),
                      CHANNEL_BUTTON_OPTION_ICON_HELP_FILLED: @(CHTChannelButtonIconHelpFilled),
                      CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS: @(CHTChannelButtonIconChatProgress),
                      CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION: @(CHTChannelButtonIconChatQuestion),
                      CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT: @(CHTChannelButtonIconChatBubbleAlt),
                      CHANNEL_BUTTON_OPTION_ICON_SMS: @(CHTChannelButtonIconSms),
                      CHANNEL_BUTTON_OPTION_ICON_COMMENT: @(CHTChannelButtonIconComment),
                      CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD: @(CHTChannelButtonIconSendForward),
                      CHANNEL_BUTTON_OPTION_ICON_COMMUNICATION: @(CHTChannelButtonIconCommunication),
                      CHANNEL_BUTTON_OPTION_ICON_HEADSET: @(CHTChannelButtonIconHeadset)
                    }),
                   CHTChannelButtonIconChannel,
                   integerValue
                   )

RCT_ENUM_CONVERTER(
                   CHTChannelButtonPosition,
                   (@{CHANNEL_BUTTON_OPTION_POSITION_RIGHT: @(CHTChannelButtonPositionRight),
                      CHANNEL_BUTTON_OPTION_POSITION_LEFT: @(CHTChannelButtonPositionLeft)
                    }),
                   CHTChannelButtonPositionRight,
                   integerValue
                   )

RCT_ENUM_CONVERTER(
                   CHTBubblePosition,
                   (@{BUBBLE_OPTION_POSITION_TOP: @(CHTBubblePositionTop),
                      BUBBLE_OPTION_POSITION_BOTTOM: @(CHTBubblePositionBottom)
                    }),
                   CHTBubblePositionTop,
                   integerValue
                   )

RCT_ENUM_CONVERTER(
                   CHTAppearance,
                   (@{APPEARANCE_SYSTEM: @(CHTAppearanceSystem),
                      APPEARANCE_DARK: @(CHTAppearanceDark),
                      APPEARANCE_LIGHT: @(CHTAppearanceLight)
                    }),
                   CHTAppearanceSystem,
                   integerValue
                   )

@end

@implementation RCTConvert (ChannelIO)

+ (CHTBootConfig *)bootConfig:(id)json {
  CHTBootConfig *config = [[CHTBootConfig alloc] init];
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
      config.language = CHTLanguageOptionKorean;
    } else if ([locale isEqualToString:LANGUAGE_OPTION_JA]) {
      config.language = CHTLanguageOptionJapanese;
    } else if ([locale isEqualToString:LANGUAGE_OPTION_EN]) {
      config.language = CHTLanguageOptionEnglish;
    } else {
      config.language = CHTLanguageOptionDevice;
    }
  } else {
    if ([language isEqualToString:LANGUAGE_OPTION_KO]) {
      config.language = CHTLanguageOptionKorean;
    } else if ([language isEqualToString:LANGUAGE_OPTION_JA]) {
      config.language = CHTLanguageOptionJapanese;
    } else if ([language isEqualToString:LANGUAGE_OPTION_EN]) {
      config.language = CHTLanguageOptionEnglish;
    } else {
      config.language = CHTLanguageOptionDevice;
    }
  }
  
  if (json[KEY_PROFILE] != nil) {
    config.profile = [RCTConvert profile:json[KEY_PROFILE]];
  }
  
  NSString *appearance = [RCTConvert NSString:json[KEY_APPEARANCE]];
  if (json[KEY_APPEARANCE] != nil) {
    if ([appearance isEqualToString:APPEARANCE_SYSTEM]) {
      [config setWithAppearance:CHTAppearanceSystem];
    } else if ([appearance isEqualToString:APPEARANCE_LIGHT]) {
      [config setWithAppearance:CHTAppearanceLight];
    } else if ([appearance isEqualToString:APPEARANCE_DARK]) {
      [config setWithAppearance:CHTAppearanceDark];
    }
  }
  
  return config;
}

+ (CHTProfile *)profile:(NSDictionary *)json {
  if (json == nil) {
    return nil;
  }
  
  CHTProfile *profile = [[CHTProfile alloc] init];
  [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id obj, BOOL * _Nonnull stop) {
    [profile setWithPropertyKey:key value:obj];
  }];
  
  return profile;
}

+ (CHTChannelButtonOption *)channelButtonOption:(id)json {
  if (json == nil) {
    return nil;
  }
  
  CHTChannelButtonOption *option = [[CHTChannelButtonOption alloc] init];
  
  option.xMargin = [RCTConvert float:json[CHANNEL_BUTTON_OPTION_X_MARGIN]];
  option.yMargin = [RCTConvert float:json[CHANNEL_BUTTON_OPTION_Y_MARGIN]];
  
  NSString *icon = [RCTConvert NSString:json[CHANNEL_BUTTON_OPTION_ICON]];
  if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_FILLED]) {
    option.icon = CHTChannelButtonIconChatBubbleFilled;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION_FILLED]) {
    option.icon = CHTChannelButtonIconChatQuestionFilled;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_CHAT_LIGHTNING_FILLED]) {
    option.icon = CHTChannelButtonIconChatLightningFilled;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT_FILLED]) {
    option.icon = CHTChannelButtonIconChatBubbleAltFilled;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_SMS_FILLED]) {
    option.icon = CHTChannelButtonIconSmsFilled;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_COMMENT_FILLED]) {
    option.icon = CHTChannelButtonIconCommentFilled;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD_FILLED]) {
    option.icon = CHTChannelButtonIconSendForwardFilled;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_HELP_FILLED]) {
    option.icon = CHTChannelButtonIconHelpFilled;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS]) {
    option.icon = CHTChannelButtonIconChatProgress;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION]) {
    option.icon = CHTChannelButtonIconChatQuestion;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT]) {
    option.icon = CHTChannelButtonIconChatBubbleAlt;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_SMS]) {
    option.icon = CHTChannelButtonIconSms;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_COMMENT]) {
    option.icon = CHTChannelButtonIconComment;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD]) {
    option.icon = CHTChannelButtonIconSendForward;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_COMMUNICATION]) {
    option.icon = CHTChannelButtonIconCommunication;
  } else if ([icon isEqualToString:CHANNEL_BUTTON_OPTION_ICON_HEADSET]) {
    option.icon = CHTChannelButtonIconHeadset;
  } else {
    option.icon = CHTChannelButtonIconChannel;
  }
  
  NSString *position = [RCTConvert NSString:json[CHANNEL_BUTTON_OPTION_POSITION]];
  if ([position isEqualToString:CHANNEL_BUTTON_OPTION_POSITION_LEFT]) {
    option.position = CHTChannelButtonPositionLeft;
  } else {
    option.position = CHTChannelButtonPositionRight;
  }
  return option;
}

+ (CHTBubbleOption *)bubbleOption:(id)json {
  if (json == nil) {
    return nil;
  }
  
  CHTBubbleOption *option = [[CHTBubbleOption alloc] init];
  
  option.yMargin = [RCTConvert NSNumber:json[BUBBLE_OPTION_Y_MARGIN]];
  NSString *position = [RCTConvert NSString:json[BUBBLE_OPTION_POSITION]];
  if ([position isEqualToString:BUBBLE_OPTION_POSITION_TOP]) {
    option.position = CHTBubblePositionTop;
  } else {
    option.position = CHTBubblePositionBottom;
  }
  return option;
}

@end

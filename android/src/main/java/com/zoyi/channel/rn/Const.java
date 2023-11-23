package com.zoyi.channel.rn;

/**
 * Created by jerry on 2018. 10. 12..
 */

public class Const {

  public static final String MODULE_NAME = "RNChannelIO";

  public static final String USER = "user";

  public static final String KEY_PLUGIN_KEY = "pluginKey";
  public static final String KEY_MEMBER_ID = "memberId";
  public static final String KEY_MEMBER_HASH = "memberHash";
  public static final String KEY_PROFILE = "profile";
  public static final String KEY_LANGUAGE = "language";
  public static final String KEY_UNSUBSCRIBED_EMAIL = "unsubscribedEmail";
  public static final String KEY_UNSUBSCRIBED_TEXTING = "unsubscribedTexting";
  public static final String KEY_TRACK_DEFAULT_EVENT = "trackDefaultEvent";
  public static final String KEY_HIDE_POPUP = "hidePopup";
  public static final String KEY_CHANNEL_BUTTON_OPTION = "channelButtonOption";
  public static final String KEY_BUBBLE_OPTION = "bubbleOption";
  public static final String KEY_TAGS = "tags";
  public static final String KEY_PROFILE_ONCE = "profileOnce";
  public static final String KEY_ID = "id";
  public static final String KEY_ALERT = "alert";
  public static final String KEY_UNREAD = "unread";
  public static final String KEY_NAME = "name";
  public static final String KEY_EMAIL = "email";
  public static final String KEY_MOBILE_NUMBER = "mobileNumber";
  public static final String KEY_AVATAR_URL = "avatarUrl";
  public static final String KEY_CHAT_ID = "chatId";
  public static final String KEY_MESSAGE = "message";
  public static final String KEY_APPEARANCE = "appearance";

  // Legacy
  public static final String KEY_USER_ID = "userId";
  public static final String KEY_LOCALE = "locale";
  public static final String KEY_ENABLED_TRACK_DEFAULT_EVENT = "enabledTrackDefaultEvent";
  public static final String KEY_HIDE_DEFAULT_IN_APP_PUSH = "hideDefaultInAppPush";
  public static final String KEY_LAUNCHER_CONFIG = "launcherConfig";

  // ChannelButtonOption
  public static final String KEY_ICON = "icon";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_FILLED = "chatBubbleFilled";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS_FILLED = "chatProgressFilled";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION_FILLED = "chatQuestionFilled";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_LIGHTNING_FILLED = "chatLightningFilled";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT_FILLED = "chatBubbleAltFilled";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_SMS_FILLED = "smsFilled";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_COMMENT_FILLED = "commentFilled";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD_FILLED = "sendForwardFilled";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_HELP_FILLED = "helpFilled";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_PROGRESS = "chatProgress";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_QUESTION = "chatQuestion";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_CHAT_BUBBLE_ALT = "chatBubbleAlt";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_SMS = "sms";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_COMMENT = "comment";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_SEND_FORWARD = "sendForward";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_COMMUNICATION = "communication";
  public static final String KEY_CHANNEL_BUTTON_OPTION_ICON_HEADSET = "headset";
  public static final String KEY_POSITION = "position";
  public static final String KEY_CHANNEL_BUTTON_OPTION_POSITION_LEFT = "left";
  public static final String KEY_X_MARGIN = "xMargin";
  public static final String KEY_Y_MARGIN = "yMargin";

  // BubbleOption
  public static final String KEY_BUBBLE_POSITION_TOP = "top";
  public static final String KEY_BUBBLE_POSITION_BOTTOM = "bottom";

  // Appearance
  public static final String KEY_APPEARANCE_SYSTEM = "system";
  public static final String KEY_APPEARANCE_LIGHT = "light";
  public static final String KEY_APPEARANCE_DARK = "dark";

  // Result
  public static final String RESULT_KEY_STATUS = "status";
  public static final String RESULT_KEY_ERROR = "error";
  public static final String RESULT_KEY_USER = "user";

  // Error
  public static final String ERROR_UNKNOWN = "UNKNOWN_ERROR";

  // Event
  public static final String KEY_EVENT = "Event";

  public static final String KEY_EVENT_USER_ID = "userId";
  public static final String KEY_EVENT_CHAT_ID = "chatId";
  public static final String KEY_EVENT_COUNT = "count";
  public static final String KEY_EVENT_URL = "url";
  public static final String KEY_EVENT_POPUP = "popup";

  public static final String KEY_ON_BADGE_CHANGED = "ON_BADGE_CHANGED";
  public static final String KEY_ON_FOLLOW_UP_CHANGED = "ON_FOLLOW_UP_CHANGED";
  public static final String KEY_ON_POPUP_DATA_RECEIVED = "ON_POPUP_DATA_RECEIVED";
  public static final String KEY_ON_SHOW_MESSENGER = "ON_SHOW_MESSENGER";
  public static final String KEY_ON_HIDE_MESSENGER = "ON_HIDE_MESSENGER";
  public static final String KEY_ON_CHAT_CREATED = "ON_CHAT_CREATED";
  public static final String KEY_ON_URL_CLICKED = "ON_URL_CLICKED";
  public static final String KEY_ON_PRE_URL_CLICKED = "ON_PRE_URL_CLICKED";
  public static final String KEY_ON_PUSH_NOTIFICATION_CLICKED = "ON_PUSH_NOTIFICATION_CLICKED";

  public static final String EVENT_ON_BADGE_CHANGED = "ChannelIO:Event:OnBadgeChanged";
  public static final String EVENT_ON_FOLLOW_UP_CHANGED = "ChannelIO:Event:OnFollowUpChanged";
  public static final String EVENT_ON_POPUP_DATA_RECEIVED = "ChannelIO:Event:OnPopupDataReceive";
  public static final String EVENT_ON_SHOW_MESSENGER = "ChannelIO:Event:OnShowMessenger";
  public static final String EVENT_ON_HIDE_MESSENGER = "ChannelIO:Event:OnHideMessenger";
  public static final String EVENT_ON_CHAT_CREATED = "ChannelIO:Event:OnChatCreated";
  public static final String EVENT_ON_URL_CLICKED = "ChannelIO:Event:OnUrlClicked";
  public static final String EVENT_ON_PRE_URL_CLICKED = "ChannelIO:Event:OnPreUrlClicked";
  public static final String EVENT_ON_PUSH_NOTIFICATION_CLICKED = "ChannelIO:Event:OnPushNotificationClicked";

  // Extra
  public static final String EXTRA_CHAT_ID = "chatId";
  public static final String EXTRA_PERSON_TYPE = "personType";
  public static final String EXTRA_PERSON_ID = "personId";
}

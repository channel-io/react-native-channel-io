package com.zoyi.channel.rn;

/**
 * Created by jerry on 2018. 10. 12..
 */

public class Const {

  public static final String MODULE_NAME = "RNChannelIO";

  // Boot
  public static final String KEY_PLUGIN_KEY = "pluginKey";
  public static final String KEY_MEMBER_ID = "memberId";
  public static final String KEY_MEMBER_HASH = "memberHash";
  public static final String KEY_USER_ID = "userId";
  public static final String KEY_LOCALE = "locale";
  public static final String KEY_LANGUAGE = "language";
  public static final String KEY_ENABLED_TRACK_DEFAULT_EVENT = "enabledTrackDefaultEvent";
  public static final String KEY_HIDE_DEFAULT_IN_APP_PUSH = "hideDefaultInAppPush";
  public static final String KEY_UNSUBSCRIBED = "unsubscribed";
  public static final String KEY_LAUNCHER_CONFIG = "launcherConfig";
  public static final String KEY_STATUS = "status";

  // UpdateUser
  public static final String KEY_UPDATE_LOCALE = "locale";
  public static final String KEY_UPDATE_LANGUAGE = "language";
  public static final String KEY_UPDATE_TAGS = "tags";
  public static final String KEY_UPDATE_PROFILE = "profile";
  public static final String KEY_UPDATE_PROFILE_ONCE = "profileOnce";
  public static final String KEY_UPDATE_UNSUBSCRIBED = "unsubscribed";

  // Exception

  public static final String KEY_EXCEPTION = "exception";

  // Guest
  public static final String KEY_ID = "id";
  public static final String KEY_ALERT = "alert";
  public static final String KEY_PROFILE = "profile";
  public static final String KEY_GUEST = "guest";

  // Profile
  public static final String KEY_NAME = "name";
  public static final String KEY_EMAIL = "email";
  public static final String KEY_MOBILE_NUMBER = "mobileNumber";
  public static final String KEY_AVATAR_URL = "avatarUrl";
  public static final String KEY_PROPERTY = "property";

  // Push event
  public static final String KEY_CHAT_ID = "chatId";
  public static final String KEY_SENDER_AVATAR_URL = "senderAvatarUrl";
  public static final String KEY_SENDER_NAME = "senderName";
  public static final String KEY_MESSAGE = "message";

  // Launcher config
  public static final String LAUNCHER_POSITION = "LauncherPosition";

  public static final String KEY_POSITION = "position";
  public static final String KEY_LAUNCHER_POSITION_RIGHT = "right";
  public static final String KEY_LAUNCHER_POSITION_LEFT = "left";
  public static final String KEY_X_MARGIN = "xMargin";
  public static final String KEY_Y_MARGIN = "yMargin";

  public static final String LAUNCHER_RIGHT = "LauncherPositionRight";
  public static final String LAUNCHER_LEFT = "LauncherPositionLeft";

  // Boot Status
  public static final String BOOT_STATUS = "BootStatus";

  public static final String KEY_BOOT_SUCCESS = "success";
  public static final String KEY_BOOT_UNKNOWN = "unknown";
  public static final String KEY_BOOT_ACCESS_DENIED = "accessDenied";
  public static final String KEY_BOOT_TIMEOUT = "timeout";
  public static final String KEY_BOOT_REQUIRE_PAYMENT = "requirePayment";
  public static final String KEY_BOOT_NOT_INITIALIZED = "notInitialized";

  public static final String BOOT_SUCCESS = "ChannelPluginCompletionStatusSuccess";
  public static final String BOOT_UNKNOWN = "ChannelPluginCompletionStatusUnknown";
  public static final String BOOT_ACCESS_DENIED = "ChannelPluginCompletionStatusAccessDenied";
  public static final String BOOT_TIMEOUT = "ChannelPluginCompletionStatusNetworkTimeout";
  public static final String BOOT_REQUIRE_PAYMENT = "ChannelPluginCompletionStatusRequirePayment";
  public static final String BOOT_NOT_INITIALIZED = "ChannelPluginCompletionStatusNotInitialized";

  // Event
  public static final String KEY_EVENT_CHAT_ID = "chatId";
  public static final String KEY_EVENT_COUNT = "count";
  public static final String KEY_EVENT_URL = "url";
  public static final String KEY_EVENT_POPUP = "popup";
  public static final String KEY_PROFILE_KEY = "key";
  public static final String KEY_PROFILE_VALUE = "value";

  public static final String KEY_ON_BADGE_CHANGED = "ON_BADGE_CHANGED";
  public static final String KEY_ON_PROFILE_CHANGED = "ON_PROFILE_CHANGED";
  public static final String KEY_ON_POPUP_DATA_RECEIVED = "ON_POPUP_DATA_RECEIVED";
  public static final String KEY_ON_SHOW_MESSENGER = "ON_SHOW_MESSENGER";
  public static final String KEY_ON_HIDE_MESSENGER = "ON_HIDE_MESSENGER";
  public static final String KEY_ON_CHAT_CREATED = "ON_CHAT_CREATED";
  public static final String KEY_ON_URL_CLICKED = "ON_URL_CLICKED";
  public static final String KEY_ON_PUSH_NOTIFICATION_CLICKED = "ON_PUSH_NOTIFICATION_CLICKED";

  public static final String EVENT_ON_BADGE_CHANGED = "ChannelIO:Event:OnBadgeChanged";
  public static final String EVENT_ON_PROFILE_CHANGED = "ChannelIO:Event:OnProfileChanged";
  public static final String EVENT_ON_POPUP_DATA_RECEIVED = "ChannelIO:Event:OnPopupDataReceive";
  public static final String EVENT_ON_SHOW_MESSENGER = "ChannelIO:Event:OnShowMessenger";
  public static final String EVENT_ON_HIDE_MESSENGER = "ChannelIO:Event:OnHideMessenger";
  public static final String EVENT_ON_CHAT_CREATED = "ChannelIO:Event:OnChatCreated";
  public static final String EVENT_ON_URL_CLICKED = "ChannelIO:Event:OnUrlClicked";
  public static final String EVENT_ON_PUSH_NOTIFICATION_CLICKED = "ChannelIO:Event:OnPushNotificationClicked";


  public static final String Event = "Event";
  public static final String Locale = "Locale";
  public static final String BootStatus = "BootStatus";
  public static final String LauncherPosition = "LauncherPosition";
}

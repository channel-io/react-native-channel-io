package com.zoyi.channel.react.android;

/**
 * Created by jerry on 2018. 10. 12..
 */

public class Const {
  public static final String MODULE_NAME = "RNChannelIO";

  // Boot
  public static final String KEY_PLUGIN_KEY = "pluginKey";
  public static final String KEY_USER_ID = "userId";
  public static final String KEY_LOCALE = "locale";
  public static final String KEY_DEBUG_MODE = "debugMode";
  public static final String KEY_ENABLED_TRACK_DEFAULT_EVENT = "enabledTrackDefaultEvent";
  public static final String KEY_HIDE_DEFAULT_IN_APP_PUSH = "hideDefaultInAppPush";
  public static final String KEY_LAUNCHER_CONFIG = "launcherConfig";
  public static final String KEY_STATUS = "status";

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

  // Locale
  public static final String KEY_KOREAN = "korean";
  public static final String KEY_JAPANESE = "japanese";
  public static final String KEY_ENGLISH = "english";
  public static final String KEY_DEVICE = "device";

  public static final String LOCALE_KOREAN = "CHLocaleKorean";
  public static final String LOCALE_JAPANESE = "CHLocaleJapanese";
  public static final String LOCALE_ENGLISH = "CHLocaleEnglish";
  public static final String LOCALE_DEVICE = "CHLocaleDevice";

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
  public static final String KEY_EVENT_COUNT = "count";
  public static final String KEY_EVENT_LINK = "link";
  public static final String KEY_EVENT_PUSH = "push";
  public static final String KEY_PROFILE_KEY = "profileKey";
  public static final String KEY_PROFILE_VALUE = "profileValue";

  public static final String KEY_ON_CHANGE_BADGE = "ON_CHANGE_BADGE";
  public static final String KEY_ON_RECEIVE_PUSH = "ON_RECEIVE_PUSH";
  public static final String KEY_WILL_SHOW_MESSENGER = "WILL_SHOW_MESSENGER";
  public static final String KEY_WILL_HIDE_MESSENGER = "WILL_HIDE_MESSENGER";
  public static final String KEY_ON_CLICK_CHAT_LINK = "ON_CLICK_CHAT_LINK";
  public static final String KEY_ON_CLICK_REDIRECT_LINK = "ON_CLICK_REDIRECT_LINK";
  public static final String KEY_ON_CHANGE_GUEST_PROFILE = "ON_CHANGE_GUEST_PROFILE";

  public static final String EVENT_WILL_SHOW_MESSENGER = "ChannelIO:Event:WillShowMessenger";
  public static final String EVENT_WILL_HIDE_MESSENGER = "ChannelIO:Event:WillHideMessenger";
  public static final String EVENT_ON_CHANGE_BADGE = "ChannelIO:Event:OnChangeBadge";
  public static final String EVENT_ON_RECEIVE_PUSH = "ChannelIO:Event:OnReceivePush";
  public static final String EVENT_ON_CLICK_CHAT_LINK = "ChannelIO:Event:OnClickChatLink";
  public static final String EVENT_ON_CLICK_REDIRECT_LINK = "ChannelIO:Event:OnClickRedirectLink";
  public static final String EVENT_ON_CHANGE_GUEST_PROFILE = "ChannelIO:Event:onChangeGuestProfile";


  public static final String Event = "Event";
  public static final String Locale = "Locale";
  public static final String BootStatus = "BootStatus";
  public static final String LauncherPosition = "LauncherPosition";
}

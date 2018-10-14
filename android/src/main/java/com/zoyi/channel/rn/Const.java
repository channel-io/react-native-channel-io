
package com.zoyi.channel.rn;

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
  public static final String KEY_PROFILE = "profile";
  public static final String KEY_GUEST = "guest";
  public static final String KEY_ALERT = "alert";
  public static final String KEY_NAMED = "named";

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
  public static final String KEY_POSITION = "position";
  public static final String KEY_POSITION_RIGHT = "right";
  public static final String KEY_X_MARGIN = "xMargin";
  public static final String KEY_Y_MARGIN = "yMargin";

  // Event
  public static final String KEY_COUNT = "count";
  public static final String KEY_URL = "url";

  public static final String EVENT_WILL_SHOW_MESSENGER = "WillShowMessenger";
  public static final String EVENT_WILL_HIDE_MESSENGER = "WillHideMessenger";
  public static final String EVENT_ON_CHANGE_BADGE = "OnChangeBadge";
  public static final String EVENT_ON_RECEIVE_PUSH = "OnReceivePush";
  public static final String EVENT_ON_CLICK_CHAT_LINK = "OnClickChatLink";

}

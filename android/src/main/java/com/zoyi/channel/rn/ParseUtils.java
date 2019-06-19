
package com.zoyi.channel.rn;

import android.support.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import com.zoyi.channel.plugin.android.model.etc.*;
import com.zoyi.channel.plugin.android.*;
import com.zoyi.channel.react.android.Const;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by jerry on 2018. 10. 11..
 */

public class ParseUtils {

  public static WritableArray toWritableArray(Object[] array) {
    WritableArray writableArray = Arguments.createArray();

    if (array == null) {
      return writableArray;
    }

    for (int i = 0; i < array.length; i++) {
      Object value = array[i];

      if (value == null) {
        writableArray.pushNull();
      }
      if (value instanceof Boolean) {
        writableArray.pushBoolean((Boolean) value);
      }
      if (value instanceof Double) {
        writableArray.pushDouble((Double) value);
      }
      if (value instanceof Integer) {
        writableArray.pushInt((Integer) value);
      }
      if (value instanceof String) {
        writableArray.pushString((String) value);
      }
      if (value instanceof Map) {
        writableArray.pushMap(toWritableMap((Map<String, Object>) value));
      }
      if (value.getClass().isArray()) {
        writableArray.pushArray(toWritableArray((Object[]) value));
      }
    }

    return writableArray;
  }

  public static WritableMap toWritableMap(Map<String, Object> map) {
    WritableMap writableMap = Arguments.createMap();

    if (map == null) {
      return writableMap;
    }

    Iterator iterator = map.entrySet().iterator();

    while (iterator.hasNext()) {
      Map.Entry pair = (Map.Entry) iterator.next();
      Object value = pair.getValue();

      if (value == null) {
        writableMap.putNull((String) pair.getKey());
      } else if (value instanceof Boolean) {
        writableMap.putBoolean((String) pair.getKey(), (Boolean) value);
      } else if (value instanceof Double) {
        writableMap.putDouble((String) pair.getKey(), (Double) value);
      } else if (value instanceof Integer) {
        writableMap.putInt((String) pair.getKey(), (Integer) value);
      } else if (value instanceof String) {
        writableMap.putString((String) pair.getKey(), (String) value);
      } else if (value instanceof Map) {
        writableMap.putMap((String) pair.getKey(), toWritableMap((Map<String, Object>) value));
      } else if (value.getClass() != null && value.getClass().isArray()) {
        writableMap.putArray((String) pair.getKey(), toWritableArray((Object[]) value));
      }

      iterator.remove();
    }

    return writableMap;
  }

  public static Map<String, Object> toHashMap(ReadableMap readableMap) {
    Map<String, Object> hashMap = new HashMap<>();

    if (readableMap == null) {
      return hashMap;
    }

    ReadableMapKeySetIterator iterator = readableMap.keySetIterator();

    while (iterator.hasNextKey()) {
      String key = iterator.nextKey();
      ReadableType type = readableMap.getType(key);

      switch (type) {
        case Boolean:
          hashMap.put(key, Utils.getBoolean(readableMap, key, false));
          break;
        case Array:
          hashMap.put(key, Utils.getReadableArray(readableMap, key));
          break;

        case Number:
          hashMap.put(key, Utils.getDouble(readableMap, key));
          break;

        case String:
          hashMap.put(key, Utils.getString(readableMap, key));
          break;

        case Map:
          hashMap.put(key, Utils.getReadableMap(readableMap, key));
          break;

        default:
          break;
      }
    }

    return hashMap;
  }

  public static LauncherConfig toLauncherConfig(ReadableMap launcherConfigMap) {
    if (launcherConfigMap != null) {
      String positionString = Utils.getString(launcherConfigMap, Const.KEY_POSITION);
      Position launcherPosition;

      if (positionString != null) {
        if (Const.KEY_LAUNCHER_POSITION_LEFT.equals(positionString)) {
          launcherPosition = Position.LEFT;
        } else {
          launcherPosition = Position.RIGHT;
        }
      } else {
        launcherPosition = Position.RIGHT;
      }

      return new LauncherConfig(
          launcherPosition,
          Utils.getFloat(launcherConfigMap, Const.KEY_X_MARGIN),
          Utils.getFloat(launcherConfigMap, Const.KEY_Y_MARGIN));
    }

    return null;
  }

  public static Profile toProfile(ReadableMap profileMap) {
    if (profileMap != null) {
      Profile profile = Profile.create()
          .setName(Utils.getString(profileMap, Const.KEY_NAME))
          .setEmail(Utils.getString(profileMap, Const.KEY_EMAIL))
          .setMobileNumber(Utils.getString(profileMap, Const.KEY_MOBILE_NUMBER))
          .setAvatarUrl(Utils.getString(profileMap, Const.KEY_AVATAR_URL));

      Iterator propertyIterator = ParseUtils
          .toHashMap(Utils.getReadableMap(profileMap, Const.KEY_PROPERTY))
          .entrySet()
          .iterator();

      while (propertyIterator.hasNext()) {
        Map.Entry pair = (Map.Entry) propertyIterator.next();
        Object value = pair.getValue();

        profile.setProperty((String) pair.getKey(), value);

        propertyIterator.remove();
      }

      return profile;
    }
    return null;
  }

  public static ChannelPluginSettings toChannelPluginSettings(ReadableMap settingsMap) {
    String pluginKey = Utils.getString(settingsMap, Const.KEY_PLUGIN_KEY);
    String userId = Utils.getString(settingsMap, Const.KEY_USER_ID);
    String locale = Utils.getString(settingsMap, Const.KEY_LOCALE);

    boolean debugMode = Utils.getBoolean(settingsMap, Const.KEY_DEBUG_MODE, false);
    boolean enabledTrackDefaultEvent = Utils.getBoolean(settingsMap, Const.KEY_ENABLED_TRACK_DEFAULT_EVENT, true);
    boolean hideDefaultInAppPush = Utils.getBoolean(settingsMap, Const.KEY_HIDE_DEFAULT_IN_APP_PUSH, false);

    ReadableMap launcherConfig = Utils.getReadableMap(settingsMap, Const.KEY_LAUNCHER_CONFIG);
    ReadableMap profile = Utils.getReadableMap(settingsMap, Const.KEY_PROFILE);

    return new ChannelPluginSettings(pluginKey)
        .setUserId(userId)
        .setLocale(CHLocale.fromString(locale))
        .setDebugMode(debugMode)
        .setEnabledTrackDefaultEvent(enabledTrackDefaultEvent)
        .setHideDefaultInAppPush(hideDefaultInAppPush)
        .setLauncherConfig(ParseUtils.toLauncherConfig(launcherConfig));
  }

  public static Map<String, String> toPushNotification(ReadableMap pushNotificationMap) {
    Map<String, String> pushNotification = new HashMap<>();
    ReadableMapKeySetIterator iterator = pushNotificationMap.keySetIterator();

    while (iterator.hasNextKey()) {
      String key = iterator.nextKey();
      pushNotification.put(key, pushNotificationMap.getString(key));
    }

    return pushNotification;
  }

  public static WritableMap getBootResult(
      ChannelPluginListener listener,
      ChannelPluginCompletionStatus status,
      @Nullable Guest guest) {

    WritableMap result = Arguments.createMap();

    if (status == ChannelPluginCompletionStatus.SUCCESS) {
      ChannelIO.setChannelPluginListener(listener);
      result.putMap(Const.KEY_GUEST, ParseUtils.guestToWritableMap(guest));
    }

    result.putString(Const.KEY_STATUS, status.toString());

    return result;
  }

  public static WritableMap guestToWritableMap(Guest guest) {
    WritableMap guestMap = Arguments.createMap();

    if (guest == null) {
      return guestMap;
    }

    guestMap.putString(Const.KEY_ID, guest.getId());
    guestMap.putString(Const.KEY_NAME, guest.getName());
    guestMap.putString(Const.KEY_AVATAR_URL, guest.getAvatarUrl());
    guestMap.putInt(Const.KEY_ALERT, guest.getAlert());

    Map<String, Object> profile = guest.getProfile();
    if (profile != null) {
      guestMap.putMap(Const.KEY_PROFILE, toWritableMap(profile));
    }

    return guestMap;
  }

  public static WritableMap pushEventToWritableMap(PushEvent pushEvent) {
    WritableMap resultMap = Arguments.createMap();
    WritableMap pushMap = Arguments.createMap();

    pushMap.putString(Const.KEY_CHAT_ID, pushEvent.getChatId());
    pushMap.putString(Const.KEY_SENDER_AVATAR_URL, pushEvent.getSenderAvatarUrl());
    pushMap.putString(Const.KEY_SENDER_NAME, pushEvent.getSenderName());
    pushMap.putString(Const.KEY_MESSAGE, pushEvent.getMessage());

    resultMap.putMap(Const.KEY_EVENT_PUSH, pushMap);

    return resultMap;
  }

  public static WritableMap createKeyValueMap(String keyName, String keyContent, String valueName, Object valueContent) {
    Map<String, Object> map = new HashMap<>();
    map.put(keyName, keyContent);
    map.put(valueName, valueContent);
    return toWritableMap(map);
  }

  public static WritableMap createSingleMap(String key, Object object) {
    Map<String, Object> map = new HashMap<>();
    map.put(key, object);
    return toWritableMap(map);
  }
}

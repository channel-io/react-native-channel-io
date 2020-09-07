package com.zoyi.channel.rn;

import com.facebook.react.bridge.*;
import com.zoyi.channel.plugin.android.ChannelIO;
import com.zoyi.channel.plugin.android.open.config.BootConfig;
import com.zoyi.channel.plugin.android.open.enumerate.BootStatus;
import com.zoyi.channel.plugin.android.open.enumerate.ChannelButtonPosition;
import com.zoyi.channel.plugin.android.open.listener.ChannelPluginListener;
import com.zoyi.channel.plugin.android.open.model.*;
import com.zoyi.channel.plugin.android.open.option.ChannelButtonOption;
import com.zoyi.channel.plugin.android.open.option.Language;

import java.util.*;

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
          hashMap.put(key, toArrayList(Utils.getReadableArray(readableMap, key)));
          break;

        case Number:
          hashMap.put(key, Utils.getDouble(readableMap, key));
          break;

        case String:
          hashMap.put(key, Utils.getString(readableMap, key));
          break;

        case Map:
          hashMap.put(key, toHashMap(Utils.getReadableMap(readableMap, key)));
          break;

        default:
          break;
      }
    }

    return hashMap;
  }

  public static List<Object> toArrayList(ReadableArray readableArray) {
    ArrayList<Object> arrayList = new ArrayList<>();

    if (readableArray == null) {
      return arrayList;
    }

    for (int i = 0; i < readableArray.size(); i++) {
      ReadableType type = readableArray.getType(i);

      switch (type) {
        case Boolean:
          arrayList.add(readableArray.getBoolean(i));
          break;
        case Array:
          arrayList.add(toArrayList(readableArray.getArray(i)));
          break;

        case Number:
          arrayList.add(readableArray.getDouble(i));
          break;

        case String:
          arrayList.add(readableArray.getString(i));
          break;

        case Map:
          arrayList.add(toHashMap(readableArray.getMap(i)));
          break;

        default:
          break;
      }
    }

    return arrayList;
  }

  public static ChannelButtonOption toChannelButtonOption(ReadableMap channelButtonOption) {
    if (channelButtonOption != null) {
      String positionString = Utils.getString(channelButtonOption, Const.KEY_POSITION);
      ChannelButtonPosition buttonPosition;

      if (positionString != null) {
        if (Const.KEY_LAUNCHER_POSITION_LEFT.equals(positionString)) {
          buttonPosition = ChannelButtonPosition.LEFT;
        } else {
          buttonPosition = ChannelButtonPosition.RIGHT;
        }
      } else {
        buttonPosition = ChannelButtonPosition.RIGHT;
      }

      return new ChannelButtonOption(
          buttonPosition,
          Utils.getFloat(channelButtonOption, Const.KEY_X_MARGIN),
          Utils.getFloat(channelButtonOption, Const.KEY_Y_MARGIN));
    }

    return null;
  }

  private static Profile toProfile(ReadableMap profileMap) {
    if (profileMap != null) {
      Profile profile = Profile.create()
          .setName(Utils.getString(profileMap, Const.KEY_NAME))
          .setEmail(Utils.getString(profileMap, Const.KEY_EMAIL))
          .setMobileNumber(Utils.getString(profileMap, Const.KEY_MOBILE_NUMBER))
          .setAvatarUrl(Utils.getString(profileMap, Const.KEY_AVATAR_URL));

      Iterator propertyIterator = ParseUtils
          .toHashMap(profileMap)
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

  public static BootConfig toBootConfig(ReadableMap configMap) {
    String pluginKey = Utils.getString(configMap, Const.KEY_PLUGIN_KEY);
    String memberId = Utils.getString(configMap, Const.KEY_MEMBER_ID);
    String memberHash = Utils.getString(configMap, Const.KEY_MEMBER_HASH);
    String userId = Utils.getString(configMap, Const.KEY_USER_ID);

    String id = memberId == null ? userId : memberId;

    String locale = Utils.getString(configMap, Const.KEY_LOCALE);
    String language = Utils.getString(configMap, Const.KEY_LANGUAGE);

    boolean enabledTrackDefaultEvent = Utils.getBoolean(configMap, Const.KEY_ENABLED_TRACK_DEFAULT_EVENT, true);
    boolean hideDefaultInAppPush = Utils.getBoolean(configMap, Const.KEY_HIDE_DEFAULT_IN_APP_PUSH, false);
    boolean unsubscribed = Utils.getBoolean(configMap, Const.KEY_UNSUBSCRIBED, false);

    ReadableMap channelButtonOption = Utils.getReadableMap(configMap, Const.KEY_LAUNCHER_CONFIG);
    ReadableMap profile = Utils.getReadableMap(configMap, Const.KEY_PROFILE);

    return BootConfig.create(pluginKey)
        .setMemberId(id)
        .setMemberHash(memberHash)
        .setTrackDefaultEvent(enabledTrackDefaultEvent)
        .setHidePopup(hideDefaultInAppPush)
        .setUnsubscribed(unsubscribed)
        .setProfile(ParseUtils.toProfile(profile))
        .setLanguage(Language.fromString(language == null ? locale : language))
        .setChannelButtonOption(ParseUtils.toChannelButtonOption(channelButtonOption));
  }

  public static List<String> toTags(ReadableArray tagsArray) {
    ArrayList<String> arrayList = new ArrayList<>();

    if (tagsArray == null) {
      return arrayList;
    }

    for (int i = 0; i < tagsArray.size(); i++) {
      ReadableType type = tagsArray.getType(i);

      if (type == ReadableType.String) {
        arrayList.add(tagsArray.getString(i));
      }
    }

    return arrayList;
  }

  public static UserData toUserData(ReadableMap userDataMap) {
    String locale = Utils.getString(userDataMap, Const.KEY_UPDATE_LOCALE);
    String language = Utils.getString(userDataMap, Const.KEY_UPDATE_LANGUAGE);

    ReadableArray tags = Utils.getReadableArray(userDataMap, Const.KEY_UPDATE_TAGS);

    ReadableMap profile = Utils.getReadableMap(userDataMap, Const.KEY_UPDATE_PROFILE);
    ReadableMap profileOnce = Utils.getReadableMap(userDataMap, Const.KEY_UPDATE_PROFILE_ONCE);

    boolean unsubscribed = Utils.getBoolean(userDataMap, Const.KEY_UPDATE_UNSUBSCRIBED, false);

    return new UserData.Builder()
        .setLanguage(Language.fromString(language == null ? locale : language))
        .setTags(toTags(tags))
        .setProfileMap(toHashMap(profile))
        .setProfileOnceMap(toHashMap(profileOnce))
        .setUnsubscribed(unsubscribed)
        .build();
  }

  public static Map<String, String> toPushNotification(ReadableMap pushNotificationMap) {
    Map<String, String> pushNotification = new HashMap<>();
    ReadableMapKeySetIterator iterator = pushNotificationMap.keySetIterator();

    while (iterator.hasNextKey()) {
      String key = iterator.nextKey();
      ReadableType type = pushNotificationMap.getType(key);

      switch (type) {
        case String:
          pushNotification.put(key, pushNotificationMap.getString(key));
          break;
      }
    }

    return pushNotification;
  }

  public static WritableMap getBootResult(
      ChannelPluginListener listener,
      BootStatus status,
      User user) {

    WritableMap result = Arguments.createMap();

    if (status == BootStatus.SUCCESS) {
      ChannelIO.setListener(listener);
      result.putMap(Const.KEY_GUEST, ParseUtils.guestToWritableMap(user));
    }

    result.putString(Const.KEY_STATUS, status.toString());

    return result;
  }

  public static WritableMap getUserResult(
      Exception e,
      User user
  ) {

    WritableMap result = Arguments.createMap();

    if (e == null) {
      result.putMap(Const.KEY_GUEST, ParseUtils.guestToWritableMap(user));
    } else {
      result.putString(Const.KEY_EXCEPTION, e.getMessage());
    }

    return result;
  }

  public static WritableMap guestToWritableMap(User user) {
    WritableMap guestMap = Arguments.createMap();

    if (user == null) {
      return guestMap;
    }

    guestMap.putString(Const.KEY_ID, user.getId());
    guestMap.putString(Const.KEY_NAME, user.getName());
    guestMap.putString(Const.KEY_AVATAR_URL, user.getAvatarUrl());
    guestMap.putInt(Const.KEY_ALERT, user.getAlert());

    Map<String, Object> profile = user.getProfile();
    if (profile != null) {
      guestMap.putMap(Const.KEY_PROFILE, toWritableMap(profile));
    }

    return guestMap;
  }

  public static WritableMap popupDataToWritableMap(PopupData popupData) {
    WritableMap resultMap = Arguments.createMap();
    WritableMap pushMap = Arguments.createMap();

    pushMap.putString(Const.KEY_CHAT_ID, popupData.getChatId());
    pushMap.putString(Const.KEY_SENDER_AVATAR_URL, popupData.getAvatarUrl());
    pushMap.putString(Const.KEY_SENDER_NAME, popupData.getName());
    pushMap.putString(Const.KEY_MESSAGE, popupData.getMessage());

    resultMap.putMap(Const.KEY_EVENT_POPUP, pushMap);

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

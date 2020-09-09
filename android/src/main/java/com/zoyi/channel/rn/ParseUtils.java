package com.zoyi.channel.rn;

import com.facebook.react.bridge.*;
import com.zoyi.channel.plugin.android.open.config.BootConfig;
import com.zoyi.channel.plugin.android.open.enumerate.BootStatus;
import com.zoyi.channel.plugin.android.open.enumerate.ChannelButtonPosition;
import com.zoyi.channel.plugin.android.open.model.*;
import com.zoyi.channel.plugin.android.open.option.ChannelButtonOption;
import com.zoyi.channel.plugin.android.open.option.Language;
import com.zoyi.channel.rn.model.MapEntry;

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
      } else if (value instanceof Boolean) {
        writableArray.pushBoolean((Boolean) value);
      } else if (value instanceof Double) {
        writableArray.pushDouble((Double) value);
      } else if (value instanceof Integer) {
        writableArray.pushInt((Integer) value);
      } else if (value instanceof String) {
        writableArray.pushString((String) value);
      } else if (value instanceof Map) {
        writableArray.pushMap(toWritableMap((Map<String, Object>) value));
      } else if (value.getClass().isArray()) {
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

    Iterator<Map.Entry<String, Object>> iterator = map.entrySet().iterator();

    while (iterator.hasNext()) {
      Map.Entry<String, Object> pair = iterator.next();
      Object value = pair.getValue();

      if (value == null) {
        writableMap.putNull(pair.getKey());
      } else if (value instanceof Boolean) {
        writableMap.putBoolean(pair.getKey(), (Boolean) value);
      } else if (value instanceof Double) {
        writableMap.putDouble(pair.getKey(), (Double) value);
      } else if (value instanceof Integer) {
        writableMap.putInt(pair.getKey(), (Integer) value);
      } else if (value instanceof String) {
        writableMap.putString(pair.getKey(), (String) value);
      } else if (value instanceof Map) {
        writableMap.putMap(pair.getKey(), toWritableMap((Map<String, Object>) value));
      } else if (value.getClass().isArray()) {
        writableMap.putArray(pair.getKey(), toWritableArray((Object[]) value));
      }

      iterator.remove();
    }

    return writableMap;
  }

  public static Map<String, Object> toHashMap(ReadableMap readableMap) {
    HashMap<String, Object> hashMap = new HashMap<>();

    if (readableMap == null) {
      return hashMap;
    }

    ReadableMapKeySetIterator iterator = readableMap.keySetIterator();

    while (iterator.hasNextKey()) {
      String key = iterator.nextKey();
      ReadableType type = readableMap.getType(key);

      switch (type) {
        case Boolean:
          hashMap.put(key, Utils.getBoolean(readableMap, key).getValue());
          break;

        case Number:
          hashMap.put(key, Utils.getDouble(readableMap, key).getValue());
          break;

        case String:
          hashMap.put(key, Utils.getString(readableMap, key).getValue());
          break;

        case Array:
          hashMap.put(key, toArrayList(Utils.getReadableArray(readableMap, key).getValue()));
          break;

        case Map:
          hashMap.put(key, toHashMap(Utils.getReadableMap(readableMap, key).getValue()));
          break;

        case Null:
          hashMap.put(key, null);
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

        case Number:
          arrayList.add(readableArray.getDouble(i));
          break;

        case String:
          arrayList.add(readableArray.getString(i));
          break;

        case Array:
          arrayList.add(toArrayList(readableArray.getArray(i)));
          break;

        case Map:
          arrayList.add(toHashMap(readableArray.getMap(i)));
          break;

        case Null:
          arrayList.add(null);
          break;

        default:
          break;
      }
    }

    return arrayList;
  }

  public static ChannelButtonOption toChannelButtonOption(ReadableMap channelButtonOptionMap) {
    if (channelButtonOptionMap != null) {
      String positionString = Utils.getString(channelButtonOptionMap, Const.KEY_POSITION).getValue();
      Double xPosition = Utils.getDouble(channelButtonOptionMap, Const.KEY_X_MARGIN).getValue();
      Double yPosition = Utils.getDouble(channelButtonOptionMap, Const.KEY_Y_MARGIN).getValue();

      if (positionString != null && xPosition != null && yPosition != null) {
        switch (positionString) {
          case Const.KEY_LAUNCHER_POSITION_LEFT:
            return new ChannelButtonOption(ChannelButtonPosition.LEFT, xPosition.floatValue(), yPosition.floatValue());

          case Const.KEY_LAUNCHER_POSITION_RIGHT:
            return new ChannelButtonOption(ChannelButtonPosition.RIGHT, xPosition.floatValue(), yPosition.floatValue());
        }
      }
    }

    return null;
  }

  private static Profile toProfile(ReadableMap profileMap) {
    if (profileMap != null) {
      Profile profile = Profile.create();

      MapEntry<String> name = Utils.getString(profileMap, Const.KEY_NAME);
      if (name.hasValue()) {
        profile.setName(name.getValue());
      }

      MapEntry<String> email = Utils.getString(profileMap, Const.KEY_EMAIL);
      if (email.hasValue()) {
        profile.setEmail(email.getValue());
      }

      MapEntry<String> mobileNumber = Utils.getString(profileMap, Const.KEY_MOBILE_NUMBER);
      if (mobileNumber.hasValue()) {
        profile.setMobileNumber(mobileNumber.getValue());
      }

      MapEntry<String> avatarUrl = Utils.getString(profileMap, Const.KEY_AVATAR_URL);
      if (avatarUrl.hasValue()) {
        profile.setAvatarUrl(avatarUrl.getValue());
      }

      Iterator<Map.Entry<String, Object>> propertyIterator = toHashMap(profileMap).entrySet().iterator();

      List<String> primitiveKeys = Arrays.asList(Const.KEY_NAME, Const.KEY_EMAIL, Const.KEY_MOBILE_NUMBER, Const.KEY_AVATAR_URL);

      while (propertyIterator.hasNext()) {
        Map.Entry<String, Object> pair = propertyIterator.next();

        if (pair.getKey() != null && primitiveKeys.contains(pair.getKey())) {
          continue;
        }

        Object value = pair.getValue();

        profile.setProperty(pair.getKey(), value);

        propertyIterator.remove();
      }

      return profile;
    }
    return null;
  }

  public static BootConfig toBootConfig(ReadableMap configMap) {
    String pluginKey = Utils.getString(configMap, Const.KEY_PLUGIN_KEY).getValue();

    BootConfig bootConfig = BootConfig.create(pluginKey);

    MapEntry<String> memberId = Utils.getString(configMap, Const.KEY_MEMBER_ID, Const.KEY_USER_ID);
    if (memberId.hasValue()) {
      bootConfig.setMemberId(memberId.getValue());
    }

    MapEntry<String> memberHash = Utils.getString(configMap, Const.KEY_MEMBER_HASH);
    if (memberHash.hasValue()) {
      bootConfig.setMemberHash(memberHash.getValue());
    }

    MapEntry<String> language = Utils.getString(configMap, Const.KEY_LANGUAGE, Const.KEY_LOCALE);
    if (language.hasValue()) {
      bootConfig.setLanguage(Language.fromString(language.getValue()));
    }

    MapEntry<Boolean> trackDefaultEvent = Utils.getBoolean(configMap, Const.KEY_TRACK_DEFAULT_EVENT, Const.KEY_ENABLED_TRACK_DEFAULT_EVENT);
    if (trackDefaultEvent.hasValue()) {
      bootConfig.setTrackDefaultEvent(trackDefaultEvent.getValue());
    }

    MapEntry<Boolean> hidePopup = Utils.getBoolean(configMap, Const.KEY_HIDE_POPUP, Const.KEY_HIDE_DEFAULT_IN_APP_PUSH);
    if (hidePopup.hasValue()) {
      bootConfig.setHidePopup(hidePopup.getValue());
    }

    MapEntry<Boolean> unsubscribed = Utils.getBoolean(configMap, Const.KEY_UNSUBSCRIBED);
    if (unsubscribed.hasValue()) {
      bootConfig.setUnsubscribed(unsubscribed.getValue());
    }

    MapEntry<ReadableMap> channelButtonOption = Utils.getReadableMap(configMap, Const.KEY_CHANNEL_BUTTON_OPTION, Const.KEY_LAUNCHER_CONFIG);
    if (channelButtonOption.hasValue()) {
      bootConfig.setChannelButtonOption(toChannelButtonOption(channelButtonOption.getValue()));
    }

    MapEntry<ReadableMap> profile = Utils.getReadableMap(configMap, Const.KEY_PROFILE);
    if (profile.hasValue()) {
      bootConfig.setProfile(toProfile(profile.getValue()));
    }

    return bootConfig;
  }

  public static List<String> toStringArray(ReadableArray tagsArray) {
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
    UserData.Builder userDataBuilder = new UserData.Builder();

    MapEntry<String> language = Utils.getString(userDataMap, Const.KEY_LANGUAGE, Const.KEY_LOCALE);
    if (language.hasValue()) {
      userDataBuilder.setLanguage(Language.fromString(language.getValue()));
    }

    MapEntry<ReadableArray> tags = Utils.getReadableArray(userDataMap, Const.KEY_TAGS);
    if (tags.hasValue()) {
      userDataBuilder.setTags(toStringArray(tags.getValue()));
    }

    MapEntry<ReadableMap> profile = Utils.getReadableMap(userDataMap, Const.KEY_PROFILE);
    if (profile.hasValue()) {
      userDataBuilder.setProfileMap(toHashMap(profile.getValue()));
    }

    MapEntry<ReadableMap> profileOnce = Utils.getReadableMap(userDataMap, Const.KEY_PROFILE_ONCE);
    if (profileOnce.hasValue()) {
      userDataBuilder.setProfileOnceMap(toHashMap(profileOnce.getValue()));
    }

    MapEntry<Boolean> unsubscribed = Utils.getBoolean(userDataMap, Const.KEY_UNSUBSCRIBED);
    if (unsubscribed.hasValue()) {
      userDataBuilder.setUnsubscribed(unsubscribed.getValue());
    }

    return userDataBuilder.build();
  }

  public static Map<String, String> toPushNotification(ReadableMap pushNotificationMap) {
    Map<String, String> pushNotification = new HashMap<>();
    ReadableMapKeySetIterator iterator = pushNotificationMap.keySetIterator();

    while (iterator.hasNextKey()) {
      String key = iterator.nextKey();
      ReadableType type = pushNotificationMap.getType(key);
      String value = pushNotificationMap.getString(key);

      if (type == ReadableType.String && value != null) {
        pushNotification.put(key, value);
      }
    }

    return pushNotification;
  }

  public static WritableMap getBootResult(
      BootStatus status,
      User user
  ) {

    WritableMap result = Arguments.createMap();

    if (status == BootStatus.SUCCESS) {
      result.putMap(Const.RESULT_KEY_USER, userToWritableMap(user));
    }

    result.putString(Const.RESULT_KEY_STATUS, status.toString());

    return result;
  }

  public static WritableMap getUserResult(
      Exception e,
      User user
  ) {

    WritableMap result = Arguments.createMap();

    if (user != null) {
      result.putMap(Const.RESULT_KEY_USER, userToWritableMap(user));
    } else if (e != null) {
      result.putString(Const.RESULT_KEY_EXCEPTION, e.getMessage());
    }

    return result;
  }

  public static WritableMap userToWritableMap(User user) {
    WritableMap userMap = Arguments.createMap();

    if (user == null) {
      return userMap;
    }

    userMap.putString(Const.KEY_ID, user.getId());
    userMap.putString(Const.KEY_MEMBER_ID, user.getMemberId());
    userMap.putString(Const.KEY_NAME, user.getName());
    userMap.putString(Const.KEY_AVATAR_URL, user.getAvatarUrl());
    userMap.putInt(Const.KEY_ALERT, user.getAlert());
    userMap.putBoolean(Const.KEY_UNSUBSCRIBED, user.isUnsubscribed());
    userMap.putString(Const.KEY_LANGUAGE, user.getLanguage());

    Map<String, Object> profile = user.getProfile();
    if (profile != null) {
      userMap.putMap(Const.KEY_PROFILE, toWritableMap(profile));
    }

    List<String> tags = user.getTags();
    if (tags != null) {
      userMap.putArray(Const.KEY_TAGS, toWritableArray(tags.toArray()));
    }

    return userMap;
  }

  public static WritableMap popupDataToWritableMap(PopupData popupData) {
    WritableMap resultMap = Arguments.createMap();
    WritableMap popupMap = Arguments.createMap();

    popupMap.putString(Const.KEY_CHAT_ID, popupData.getChatId());
    popupMap.putString(Const.KEY_SENDER_AVATAR_URL, popupData.getAvatarUrl());
    popupMap.putString(Const.KEY_SENDER_NAME, popupData.getName());
    popupMap.putString(Const.KEY_MESSAGE, popupData.getMessage());

    resultMap.putMap(Const.KEY_EVENT_POPUP, popupMap);

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

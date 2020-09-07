package com.zoyi.channel.rn;

import com.facebook.react.bridge.*;
import com.facebook.react.modules.core.DeviceEventManagerModule;

/**
 * Created by mika on 2018. 9. 18..
 */

public class Utils {

  public static Boolean getBoolean(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return readableMap.getBoolean(key);
    }
    return null;
  }

  public static Boolean getBoolean(ReadableMap readableMap, String key, String legacyKey) {
    if (getBoolean(readableMap, key) != null) {
      return getBoolean(readableMap, key);
    }
    return getBoolean(readableMap, legacyKey);
  }

  public static Double getDouble(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return readableMap.getDouble(key);
    }
    return null;
  }

  public static String getString(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return readableMap.getString(key);
    }
    return null;
  }

  public static String getString(ReadableMap readableMap, String key, String legacyKey) {
    if (getString(readableMap, key) != null) {
      return getString(readableMap, key);
    }
    return getString(readableMap, legacyKey);
  }

  public static ReadableMap getReadableMap(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return readableMap.getMap(key);
    }
    return null;
  }

  public static ReadableMap getReadableMap(ReadableMap readableMap, String key, String legacyKey) {
    if (getReadableMap(readableMap, key) != null) {
      return getReadableMap(readableMap, key);
    }
    return getReadableMap(readableMap, legacyKey);
  }

  public static ReadableArray getReadableArray(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return readableMap.getArray(key);
    }
    return null;
  }

  public static void sendEvent(ReactContext reactContext, String eventName, WritableMap params) {
    reactContext
        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
        .emit(eventName, params);
  }
}

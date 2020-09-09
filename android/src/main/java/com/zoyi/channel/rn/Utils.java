package com.zoyi.channel.rn;

import com.facebook.react.bridge.*;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.zoyi.channel.rn.model.MapEntry;

/**
 * Created by mika on 2018. 9. 18..
 */

public class Utils {

  public static MapEntry<Boolean> getBoolean(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return new MapEntry<>(readableMap.getBoolean(key));
    }
    return new MapEntry<>();
  }

  public static MapEntry<Boolean> getBoolean(ReadableMap readableMap, String key, String legacyKey) {
    if (getBoolean(readableMap, key).hasValue()) {
      return getBoolean(readableMap, key);
    }
    return getBoolean(readableMap, legacyKey);
  }

  public static MapEntry<Double> getDouble(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return new MapEntry<>(readableMap.getDouble(key));
    }
    return new MapEntry<>();
  }

  public static MapEntry<String> getString(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return new MapEntry<>(readableMap.getString(key));
    }
    return new MapEntry<>();
  }

  public static MapEntry<String> getString(ReadableMap readableMap, String key, String legacyKey) {
    if (getString(readableMap, key).hasValue()) {
      return getString(readableMap, key);
    }
    return getString(readableMap, legacyKey);
  }

  public static MapEntry<ReadableMap> getReadableMap(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return new MapEntry<>(readableMap.getMap(key));
    }
    return new MapEntry<>();
  }

  public static MapEntry<ReadableMap> getReadableMap(ReadableMap readableMap, String key, String legacyKey) {
    if (getReadableMap(readableMap, key).hasValue()) {
      return getReadableMap(readableMap, key);
    }
    return getReadableMap(readableMap, legacyKey);
  }

  public static MapEntry<ReadableArray> getReadableArray(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return new MapEntry<>(readableMap.getArray(key));
    }
    return new MapEntry<>();
  }

  public static void sendEvent(ReactContext reactContext, String eventName, WritableMap params) {
    reactContext
        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
        .emit(eventName, params);
  }
}

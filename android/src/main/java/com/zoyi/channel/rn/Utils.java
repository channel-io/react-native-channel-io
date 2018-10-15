
package com.zoyi.channel.rn;

import android.content.Context;
import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.zoyi.channel.plugin.android.model.entity.Guest;
import com.zoyi.channel.plugin.android.*;
import com.zoyi.channel.plugin.android.global.*;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by mika on 2018. 9. 18..
 */

public class Utils {

  public static double getDouble(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return readableMap.getDouble(key);
    }

    return 0.0;
  }

  public static float getFloat(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return Double.valueOf(getDouble(readableMap, key)).floatValue();
    }

    return 0f;
  }

  public static boolean getBoolean(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return readableMap.getBoolean(key);
    }

    return false;
  }

  public static String getString(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return readableMap.getString(key);
    }

    return null;
  }

  public static ReadableMap getReadableMap(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return readableMap.getMap(key);
    }

    return null;
  }

  public static ReadableArray getReadableArray(ReadableMap readableMap, String key) {
    if (readableMap.hasKey(key)) {
      return readableMap.getArray(key);
    }

    return null;
  }

  public static String getPluginKey(Context context) {
    String pluginKey = null;

    if (PrefSupervisor.getPluginSetting(context) != null) {
      pluginKey = PrefSupervisor.getPluginSetting(context).getPluginKey();
    }

    return pluginKey;
  }

  public static void sendEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
    reactContext
        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
        .emit(eventName, params);
  }
}

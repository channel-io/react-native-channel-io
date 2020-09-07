
package com.zoyi.channel.rn;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.*;
import com.zoyi.channel.plugin.android.ChannelIO;
import com.zoyi.channel.plugin.android.open.callback.*;
import com.zoyi.channel.plugin.android.open.enumerate.BootStatus;
import com.zoyi.channel.plugin.android.open.listener.ChannelPluginListener;
import com.zoyi.channel.plugin.android.open.model.PopupData;
import com.zoyi.channel.plugin.android.open.model.User;

import java.util.HashMap;
import java.util.Map;

public class RNChannelIO extends ReactContextBaseJavaModule implements ChannelPluginListener {

  private boolean handleUrl = false;
  private boolean handlePushNotification = false;

  private ReactContext reactContext;

  public RNChannelIO(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return Const.MODULE_NAME;
  }

  @Override
  public Map<String, Object> getConstants() {
    Map<String, Object> constants = new HashMap<>();
    Map<String, String> eventMap = new HashMap<>();
    Map<String, String> localeMap = new HashMap<>();
    Map<String, String> bootStatusMap = new HashMap<>();
    Map<String, String> launcherPositionMap = new HashMap<>();

    eventMap.put(Const.KEY_ON_BADGE_CHANGED, Const.EVENT_ON_BADGE_CHANGED);
    eventMap.put(Const.KEY_ON_POPUP_DATA_RECEIVED, Const.EVENT_ON_POPUP_DATA_RECEIVED);
    eventMap.put(Const.KEY_ON_SHOW_MESSENGER, Const.EVENT_ON_SHOW_MESSENGER);
    eventMap.put(Const.KEY_ON_HIDE_MESSENGER, Const.EVENT_ON_HIDE_MESSENGER);
    eventMap.put(Const.KEY_ON_CHAT_CREATED, Const.EVENT_ON_CHAT_CREATED);
    eventMap.put(Const.KEY_ON_URL_CLICKED, Const.EVENT_ON_URL_CLICKED);
    eventMap.put(Const.KEY_ON_PROFILE_CHANGED, Const.EVENT_ON_PROFILE_CHANGED);
    eventMap.put(Const.KEY_ON_PUSH_NOTIFICATION_CLICKED, Const.EVENT_ON_PUSH_NOTIFICATION_CLICKED);

    launcherPositionMap.put(Const.KEY_LAUNCHER_POSITION_RIGHT, Const.LAUNCHER_RIGHT);
    launcherPositionMap.put(Const.KEY_LAUNCHER_POSITION_LEFT, Const.LAUNCHER_LEFT);

    bootStatusMap.put(Const.KEY_BOOT_SUCCESS, Const.BOOT_SUCCESS);
    bootStatusMap.put(Const.KEY_BOOT_TIMEOUT, Const.BOOT_TIMEOUT);
    bootStatusMap.put(Const.KEY_BOOT_ACCESS_DENIED, Const.BOOT_ACCESS_DENIED);
    bootStatusMap.put(Const.KEY_BOOT_NOT_INITIALIZED, Const.BOOT_NOT_INITIALIZED);
    bootStatusMap.put(Const.KEY_BOOT_REQUIRE_PAYMENT, Const.BOOT_REQUIRE_PAYMENT);

    constants.put(Const.Event, eventMap);
    constants.put(Const.Locale, localeMap);
    constants.put(Const.LAUNCHER_POSITION, launcherPositionMap);
    constants.put(Const.BOOT_STATUS, bootStatusMap);

    return constants;
  }

  @ReactMethod
  public void boot(ReadableMap config, final Promise promise) {
    ChannelIO.boot(
        ParseUtils.toBootConfig(config),
        new BootCallback() {
          @Override
          public void onComplete(BootStatus bootStatus, @Nullable User user) {
            promise.resolve(ParseUtils.getBootResult(RNChannelIO.this, bootStatus, user));
          }
        }
    );
  }

  @ReactMethod
  public void sleep() {
    ChannelIO.sleep();
  }

  @ReactMethod
  public void shutdown() {
    ChannelIO.shutdown();
  }

  @ReactMethod
  public void showChannelButton() {
    ChannelIO.showChannelButton();
  }

  @ReactMethod
  public void hideChannelButton() {
    ChannelIO.hideChannelButton();
  }

  @ReactMethod
  public void showMessenger() {
    ChannelIO.openChat(getCurrentActivity(), null, null);
  }

  @ReactMethod
  public void hideMessenger() {
    ChannelIO.hideMessenger();
  }

  @ReactMethod
  public void openChat(String chatId, String message) {
    ChannelIO.openChat(getCurrentActivity(), chatId, message);
  }

  @ReactMethod
  public void track(String name, ReadableMap eventProperty) {
    ChannelIO.track(name, ParseUtils.toHashMap(eventProperty));
  }

  @ReactMethod
  public void updateUser(ReadableMap userData, final Promise promise) {
    ChannelIO.updateUser(
        ParseUtils.toUserData(userData),
        new UserUpdateCallback() {
          @Override
          public void onComplete(@Nullable Exception e, @Nullable User user) {
            promise.resolve(ParseUtils.getUserResult(e, user));
          }
        }
    );
  }

  @ReactMethod
  public void addTags(ReadableArray tags, final Promise promise) {
    ChannelIO.addTags(
        ParseUtils.toTags(tags),
        new UserUpdateCallback() {
          @Override
          public void onComplete(@Nullable Exception e, @Nullable User user) {
            promise.resolve(ParseUtils.getUserResult(e, user));
          }
        }
    );
  }

  @ReactMethod
  public void removeTags(ReadableArray tags, final Promise promise) {
    ChannelIO.removeTags(
        ParseUtils.toTags(tags),
        new UserUpdateCallback() {
          @Override
          public void onComplete(@Nullable Exception e, @Nullable User user) {
            promise.resolve(ParseUtils.getUserResult(e, user));
          }
        }
    );
  }

  @ReactMethod
  public void initPushToken(String token) {
    ChannelIO.initPushToken(token);
  }

  @ReactMethod
  public void isChannelPushNotification(ReadableMap userInfo, Promise promise) {
    if (ChannelIO.isChannelPushNotification(ParseUtils.toPushNotification(userInfo))) {
      promise.resolve(true);
    } else {
      promise.resolve(false);
    }
  }

  @ReactMethod
  public void receivePushNotification(ReadableMap userInfo, Promise promise) {
    if (reactContext != null) {
      Context context = reactContext.getApplicationContext();

      if (context != null) {
        ChannelIO.receivePushNotification(context, ParseUtils.toPushNotification(userInfo));
      }
    }

    promise.resolve(true);
  }

  @ReactMethod
  public void hasStoredPushNotification(Promise promise) {
    Activity activity = getCurrentActivity();

    if (activity != null) {
      promise.resolve(ChannelIO.hasStoredPushNotification(getCurrentActivity()));
    } else {
      promise.resolve(false);
    }
  }

  @ReactMethod
  public void openStoredPushNotification() {
    Activity activity = getCurrentActivity();

    if (activity != null) {
      ChannelIO.openStoredPushNotification(getCurrentActivity());
    }
  }

  @ReactMethod
  public void isBooted(Promise promise) {
    if (ChannelIO.isBooted()) {
      promise.resolve(true);
    } else {
      promise.resolve(false);
    }
  }

  @ReactMethod
  public void setDebugMode(boolean enable) {
    ChannelIO.setDebugMode(enable);
  }

  @ReactMethod
  public void setUrlHandle(boolean handleUrl) {
    this.handleUrl = handleUrl;
  }

  @ReactMethod
  public void setPushNotificationHandle(boolean handlePushNotification) {
    this.handlePushNotification = handlePushNotification;
  }

  @Override
  public void onShowMessenger() {
    Utils.sendEvent(reactContext, Const.EVENT_ON_SHOW_MESSENGER, null);
  }

  @Override
  public void onHideMessenger() {
    Utils.sendEvent(reactContext, Const.EVENT_ON_HIDE_MESSENGER, null);
  }

  @Override
  public void onChatCreated(String chatId) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_CHAT_CREATED, ParseUtils.createSingleMap(Const.KEY_EVENT_CHAT_ID, chatId));
  }

  @Override
  public void onBadgeChanged(int count) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_BADGE_CHANGED, ParseUtils.createSingleMap(Const.KEY_EVENT_COUNT, count));
  }

  @Override
  public void onProfileChanged(String key, @Nullable Object value) {
    Utils.sendEvent(
        reactContext,
        Const.EVENT_ON_PROFILE_CHANGED,
        ParseUtils.createKeyValueMap(Const.KEY_PROFILE_KEY, key, Const.KEY_PROFILE_VALUE, value)
    );
  }

  @Override
  public boolean onUrlClicked(String url) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_URL_CLICKED, ParseUtils.createSingleMap(Const.KEY_EVENT_URL, url));
    return handleUrl;
  }

  @Override
  public boolean onPushNotificationClicked(String chatId) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_PUSH_NOTIFICATION_CLICKED, ParseUtils.createSingleMap(Const.KEY_EVENT_CHAT_ID, chatId));
    return handlePushNotification;
  }

  @Override
  public void onPopupDataReceived(PopupData popupData) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_POPUP_DATA_RECEIVED, ParseUtils.popupDataToWritableMap(popupData));
  }
}

package com.zoyi.channel.rn;

import android.app.Activity;
import android.content.Context;
import android.widget.Toast;

import com.facebook.react.bridge.*;
import com.zoyi.channel.plugin.android.*;
import com.zoyi.channel.plugin.android.global.*;

import com.facebook.react.bridge.ReadableMap;
import com.zoyi.channel.plugin.android.model.etc.PushEvent;
import com.zoyi.channel.react.android.*;
import com.zoyi.channel.react.android.Const;

import java.util.HashMap;
import java.util.Map;

public class RNChannelIO extends ReactContextBaseJavaModule implements ChannelPluginListener {

  private boolean debug = false;
  private boolean handleChatLink = false;
  private boolean handleRedirectLink = false;

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

    eventMap.put(Const.KEY_ON_CHANGE_BADGE, Const.EVENT_ON_CHANGE_BADGE);
    eventMap.put(Const.KEY_ON_RECEIVE_PUSH, Const.EVENT_ON_RECEIVE_PUSH);
    eventMap.put(Const.KEY_WILL_SHOW_MESSENGER, Const.EVENT_WILL_SHOW_MESSENGER);
    eventMap.put(Const.KEY_WILL_HIDE_MESSENGER, Const.EVENT_WILL_HIDE_MESSENGER);
    eventMap.put(Const.KEY_ON_CLICK_CHAT_LINK, Const.EVENT_ON_CLICK_CHAT_LINK);
    eventMap.put(Const.KEY_ON_CLICK_REDIRECT_LINK, Const.EVENT_ON_CLICK_REDIRECT_LINK);
    eventMap.put(Const.KEY_ON_CHANGE_PROFILE, Const.EVENT_ON_CHANGE_PROFILE);

    localeMap.put(Const.KEY_KOREAN, Const.LOCALE_KOREAN);
    localeMap.put(Const.KEY_JAPANESE, Const.LOCALE_JAPANESE);
    localeMap.put(Const.KEY_ENGLISH, Const.LOCALE_ENGLISH);
    localeMap.put(Const.KEY_DEVICE, Const.LOCALE_DEVICE);

    launcherPositionMap.put(Const.KEY_LAUNCHER_POSITION_RIGHT, Const.LAUNCHER_RIGHT);
    launcherPositionMap.put(Const.KEY_LAUNCHER_POSITION_LEFT, Const.LAUNCHER_LEFT);

    bootStatusMap.put(Const.KEY_BOOT_SUCCESS, Const.BOOT_SUCCESS);
    bootStatusMap.put(Const.KEY_BOOT_TIMEOUT, Const.BOOT_TIMEOUT);
    bootStatusMap.put(Const.KEY_BOOT_ACCESS_DENIED, Const.BOOT_ACCESS_DENIED);
    bootStatusMap.put(Const.KEY_BOOT_NOT_INITIALIZED, Const.BOOT_NOT_INITIALIZED);
    bootStatusMap.put(Const.KEY_BOOT_REQUIRE_PAYMENT, Const.BOOT_REQUIRE_PAYMENT);
    bootStatusMap.put(Const.KEY_BOOT_NOT_INITIALIZED, Const.BOOT_NOT_INITIALIZED);

    constants.put(Const.Event, eventMap);
    constants.put(Const.Locale, localeMap);
    constants.put(Const.LAUNCHER_POSITION, launcherPositionMap);
    constants.put(Const.BOOT_STATUS, bootStatusMap);

    return constants;
  }

  @ReactMethod
  public void boot(ReadableMap settings, final Promise promise) {
    ChannelIO.boot(
        ParseUtils.toChannelPluginSettings(settings),
        ParseUtils.toProfile(Utils.getReadableMap(settings, Const.KEY_PROFILE)),
        new OnBootListener() {
          @Override
          public void onCompletion(ChannelPluginCompletionStatus status, Guest guest) {
            promise.resolve(ParseUtils.getBootResult(RNChannelIO.this, status, guest));
          }
        });
  }

  @ReactMethod
  public void show(boolean animated) {
    ChannelIO.show();
  }

  @ReactMethod
  public void hide(boolean animated) {
    ChannelIO.hide();
  }

  @ReactMethod
  public void shutdown() {
    ChannelIO.shutdown();
  }

  @ReactMethod
  public void open(boolean animated) {
    ChannelIO.open(getCurrentActivity(), animated);
  }

  @ReactMethod
  public void close(boolean animated) {
    ChannelIO.close(animated);
  }

  @ReactMethod
  public void openChat(String chatId, boolean animated) {
    ChannelIO.openChat(getCurrentActivity(), chatId, animated);
  }

  @ReactMethod
  public void initPushToken(String tokenData) {
    Context context = getCurrentActivity();

    if (context != null){
      PrefSupervisor.setDeviceToken(context, tokenData);
    }
  }

  @ReactMethod
  public void handlePushNotification(ReadableMap userInfo, Promise promise) {
    Context context = getCurrentActivity();

    if (context != null){
      ChannelIO.showPushNotification(context, ParseUtils.toPushNotification(userInfo));
    }

    promise.resolve(true);
  }

  @ReactMethod
  public void handlePush() {
    Activity activity = getCurrentActivity();

    if (activity != null){
      ChannelIO.handlePushNotification(activity);
    }
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
  public void track(String name, ReadableMap eventProperty) {
    ChannelIO.track(name, ParseUtils.toHashMap(eventProperty));
  }

  @ReactMethod
  public void setLinkHandle(boolean handleChatLink) {
    this.handleChatLink = handleChatLink;
  }

  @ReactMethod
  public void setRedirectLinkHandle(boolean handleRedirectLink) {
    this.handleRedirectLink = handleRedirectLink;
  }

  @Override
  public void willShowMessenger() {
    Utils.sendEvent(reactContext, Const.EVENT_WILL_SHOW_MESSENGER, null);
  }

  @Override
  public void willHideMessenger() {
    Utils.sendEvent(reactContext, Const.EVENT_WILL_HIDE_MESSENGER, null);
  }

  @Override
  public void onChangeBadge(int count) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_CHANGE_BADGE, ParseUtils.createSingleMap(Const.KEY_EVENT_COUNT, count));
  }

  @Override
  public void onReceivePush(PushEvent pushEvent) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_RECEIVE_PUSH, ParseUtils.pushEventToWritableMap(pushEvent));
  }

  @Override
  public boolean onClickChatLink(String url) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_CLICK_CHAT_LINK, ParseUtils.createSingleMap(Const.KEY_EVENT_LINK, url));
    return handleChatLink;
  }

  @Override
  public boolean onClickRedirectUrl(String url) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_CLICK_REDIRECT_LINK, ParseUtils.createSingleMap(Const.KEY_EVENT_LINK, url));
    return handleRedirectLink;
  }

  @Override
  public void onChangeProfile(String key, Object value) {
    Utils.sendEvent(
      reactContext,
      Const.EVENT_ON_CHANGE_PROFILE,
      ParseUtils.createKeyValueMap(Const.KEY_PROFILE_KEY, key, Const.KEY_PROFILE_VALUE, value)
    );
  }
}

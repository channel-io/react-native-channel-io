
package com.zoyi.channel.rn;

import android.content.Context;
import android.support.annotation.Nullable;

import com.facebook.react.bridge.*;
import com.zoyi.channel.plugin.android.*;
import com.zoyi.channel.plugin.android.global.*;
import com.zoyi.channel.plugin.android.model.entity.*;

import com.facebook.react.bridge.ReadableMap;
import com.zoyi.channel.plugin.android.model.etc.PushEvent;

public class RNChannelIO extends ReactContextBaseJavaModule implements ChannelPluginListener {

  private boolean debug = false;
  private boolean handleChatLink = false;

  private ReactContext reactContext;

  public RNChannelIO(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return Const.MODULE_NAME;
  }

  @ReactMethod
  public void boot(ReadableMap settings, final Promise promise) {
    ChannelIO.boot(
        ParseUtils.toChannelPluginSettings(settings),
        ParseUtils.toProfile(Utils.getReadableMap(settings, Const.KEY_PROFILE)),
        new OnBootListener() {
          @Override
          public void onCompletion(ChannelPluginCompletionStatus status, @Nullable Guest guest) {
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
  public void handlePushNotification(ReadableMap userInfo) {
    ChannelIO.handlePushNotification(getCurrentActivity());
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
    ChannelIO.track(getCurrentActivity(), Utils.getPluginKey(getCurrentActivity()), name, ParseUtils.toHashMap(eventProperty));
  }

  @ReactMethod
  public void setHandleChatLink(boolean handleChatLink) {
    this.handleChatLink = handleChatLink;
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
    Utils.sendEvent(reactContext, Const.EVENT_ON_CHANGE_BADGE, ParseUtils.createSingleMap(Const.KEY_COUNT, count));
  }

  @Override
  public void onReceivePush(PushEvent pushEvent) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_RECEIVE_PUSH, ParseUtils.pushEventToWritableMap(pushEvent));
  }

  @Override
  public boolean onClickChatLink(String url) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_CLICK_CHAT_LINK, ParseUtils.createSingleMap(Const.KEY_URL, url));
    return handleChatLink;
  }
}
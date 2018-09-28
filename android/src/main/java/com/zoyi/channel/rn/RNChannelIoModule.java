
package com.zoyi.channel.rn;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class RNChannelIoModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNChannelIoModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNChannelIo";
  }
}
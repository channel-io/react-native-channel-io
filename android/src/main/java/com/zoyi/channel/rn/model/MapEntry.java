package com.zoyi.channel.rn.model;

public class MapEntry<E> {
  private boolean hasValue;
  private E value;

  public MapEntry() {
    this.hasValue = false;
  }

  public MapEntry(E value) {
    this.hasValue = true;
    this.value = value;
  }

  public boolean hasValue() {
    return hasValue;
  }

  public E getValue() {
    return value;
  }
}

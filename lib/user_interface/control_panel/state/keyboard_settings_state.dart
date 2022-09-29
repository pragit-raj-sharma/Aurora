import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class KeyboardSettingsLoadedState extends Equatable{
  final int brightness;
  final int mode;
  final int speed;
  final Color color;

  const KeyboardSettingsLoadedState({
    this.brightness=0,
    this.mode=0,
    this.speed=0,
    this.color=Colors.green
  });

  KeyboardSettingsLoadedState copyState({
    int? brightness,
    int? mode,
    int? speed,
    Color? color
  }){
    return KeyboardSettingsLoadedState(
      color: color??this.color,
      mode: mode?? this.mode,
      brightness: brightness?? this.brightness,
      speed: speed?? this.speed
    );
  }

  @override
  List<Object?> get props => [brightness,speed,color,mode];

}

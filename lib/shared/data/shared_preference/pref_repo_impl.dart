
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/ar_mode_model.dart';
import '../model/ar_state_model.dart';
import 'pref_constants.dart';
import 'pref_repo.dart';

class PrefRepoImpl extends PrefRepo{
  PrefRepoImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<String?> getVersion() async {
    return _sharedPreferences.getString(PrefConstants.version)??'0';
  }

  @override
  Future<int> getBrightness() async {
    return (_sharedPreferences.getInt(PrefConstants.brightness))??0;
  }

  @override
  Future<ArMode?> getArMode() async {
    String mode= (_sharedPreferences.getString(PrefConstants.mode))??'';
    if(mode.isEmpty) return null;
    return ArMode.fromJson(jsonDecode(mode));
  }

  @override
  Future<ArState> getArState() async {
    String state= (_sharedPreferences.getString(PrefConstants.state))??'';
    if(state.isEmpty) return ArState();
    return ArState.fromJson(jsonDecode(state));
  }

  @override
  Future<int?> getThreshold() async{
    return (_sharedPreferences.getInt(PrefConstants.threshold));
  }

  @override
  Future<bool> isFaustusEnforced() async {
    return (_sharedPreferences.getBool(PrefConstants.enforceFaustus))??false;
  }

  @override
  Future<ThemeMode> getTheme() async{
    switch((_sharedPreferences.getString(PrefConstants.theme))??PrefConstants.theme){
      case 'system':
        return ThemeMode.system;
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;

      default:
        return ThemeMode.system;
    }

  }

  @override
  Future setVersion(String version) async {
    await _sharedPreferences.setString(PrefConstants.version, version);
  }

  @override
  Future setBrightness(int brightness) async {
    await _sharedPreferences.setInt(PrefConstants.brightness, brightness);
  }

  @override
  Future setArMode({ required ArMode arMode}) async {
    await _sharedPreferences.setString(PrefConstants.mode,
        '{ "mode": ${arMode.mode}, "speed": ${arMode.speed}, "color": "${arMode.color}" }');
  }


  @override
  Future setArState({ required ArState arState }) async {
    await _sharedPreferences.setString(PrefConstants.state,
        '{ "boot": ${arState.boot}, "awake": ${arState.awake}, "sleep": ${arState.sleep} }');
  }

  @override
  Future setThreshold(int threshold) async {
    await _sharedPreferences.setInt(PrefConstants.threshold, threshold);
  }

  @override
  Future setTheme(ThemeMode arTheme) async {
    await _sharedPreferences.setString(PrefConstants.theme, arTheme.name);
  }

  @override
  Future setFaustusEnforcement(bool enforced) async {
    await _sharedPreferences.setBool(PrefConstants.enforceFaustus, enforced);
  }

  @override
  Future nukePref() async{
    await _sharedPreferences.clear();
  }
}

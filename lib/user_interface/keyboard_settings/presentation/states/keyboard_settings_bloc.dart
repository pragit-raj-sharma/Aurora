

import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_repo.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_event.dart';
import 'package:aurora/shared/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:flutter/material.dart';

import 'keyboard_settings_state.dart';

class KeyboardSettingsBloc extends TerminalBaseBloc<KeyboardSettingsEvent,KeyboardSettingsState> {
  KeyboardSettingsBloc(this._prefRepo,this._controlPanelRepo):super(const KeyboardSettingsState()){
   on<KeyboardSettingsEventSetBrightness>((event, emit)=> _setBrightness(event.brightness,emit));
   on<KeyboardSettingsEventSetSpeed>((event, emit)=> _setSpeed(speed: event.speed,emit));
   on<KeyboardSettingsEventSetMode>((event, emit)=> _setMode(mode: event.mode,emit));
   on<KeyboardSettingsEventSetColor>((event, emit)=> _setColor(color: event.color??ArColors.accentColor,mode: 0, emit));
   on<KeyboardSettingsEventInit>((event, emit) => _initPanel(emit));
   on<KeyboardSettingsEventSetState>((event, emit) => _setMainLineStateParams(emit,arState: ArState(boot: event.boot,sleep: event.sleep,awake: event.awake)));
  }

  final PrefRepo _prefRepo;
  final KeyboardSettingsRepo _controlPanelRepo;

  bool _boot=false;
  bool _awake=false;
  bool _sleep=false;

  ArMode arMode=ArMode(color: ArColors.accentColor,mode: 0,speed: 0);

  _initPanel(emit) async{
      arMode= (await _prefRepo.getArMode())??arMode;
      await _setBrightness(await _prefRepo.getBrightness(), emit);
      await _setMainlineModeParams(arMode: arMode, emit);
      if(super.isMainLine()){
        await _setMainLineStateParams(arState: (await _prefRepo.getArState()).negateValue(), emit );
      }
  }

  _setColor(emit,{required Color color,int? mode}) async {
    arMode.color= color;
    arMode.mode=mode??arMode.mode;
    await _controlPanelRepo.setColor(arMode: arMode);
    _updateState(emit);
  }

  _setBrightness(int brightness, emit) async {
    await _controlPanelRepo.setBrightness(brightness);
    emit(state.copyState(brightness: brightness));
  }


  _setMode(emit, {required int mode})async{
    arMode.mode=mode;
    await _controlPanelRepo.setMode(arMode: arMode);
    _updateState(emit);
  }

  _setSpeed(emit,{required int speed}) async{
    arMode.speed=speed;
    await _controlPanelRepo.setSpeed(arMode: arMode);
    _updateState(emit);
  }
  
  _setMainlineModeParams(emit,{
    required ArMode arMode    
  }) async{
    this.arMode.color=arMode.color??this.arMode.color;
    this.arMode.mode=arMode.mode??this.arMode.mode;
    this.arMode.speed=arMode.speed??this.arMode.speed;
    await _controlPanelRepo.setMainlineModeParams(arMode: arMode);
    _updateState(emit);
  }
  
  _setMainLineStateParams(emit,{
    required ArState arState
  }) async{
    _boot=arState.boot==null?_boot:!arState.boot!;
    _awake=arState.awake==null?_awake:!arState.awake!;
    _sleep=arState.sleep==null?_sleep:!arState.sleep!;
    await _controlPanelRepo.setMainlineStateParams(sleep: _parseBool(_sleep),awake: _parseBool(_awake),boot: _parseBool(_boot));
    _updateState(emit);
  }

  _parseBool(bool? value)=>(value??false)?1:0;
  
  _updateState(emit){
    super.setSelectedColor(arMode.color!);
    emit(state.copyState(speed: arMode.speed,mode: arMode.mode,color: arMode.color,awake: _awake,sleep: _sleep,boot: _boot));
  }

  bool get isSpeedBarVisible => (state.mode)>0&&(state.mode)<3&&isModeBarVisible;
  bool get isModeBarVisible => (state.brightness)>0;

}
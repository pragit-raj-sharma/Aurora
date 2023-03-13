import 'dart:io';

import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import 'home_repo.dart';

class HomeRepoImpl extends HomeRepo with GlobalMixin{

  HomeRepoImpl(this._terminalDelegate,this._prefRepo);

  final TerminalDelegate _terminalDelegate;
  final PrefRepo _prefRepo;

  final _globalConfig=Constants.globalConfig;

  @override
  List<String> readFile({required String path}){
    return (File(path).readAsLinesSync());
  }

  @override
  Future<bool> checkInternetAccess() async{
    try {
      final result = await InternetAddress.lookup('www.google.com');
        return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Future launchArUrl({String? subPath}) async {
    var url = Uri.parse(Constants.kAuroraGitUrl+(subPath??''));
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "error launching $url";
    }
  }

  @override
  Future<String> getVersion() async{
    var version= (await PackageInfo.fromPlatform()).version;
    _globalConfig.setInstance(
        arVersion:version,
        arChannel: version.split('-')[1]
    );
    return version;
  }

  @override
  void setAppHeight(){
    var window = WindowManager.instance;
    window..setMinimumSize(Size(1000,super.isMainLine()?680:600))
    ..show()
    ..focus();
  }

  @override
  Future<int> compatibilityChecker() async{

    if(!await _terminalDelegate.pkexecChecker()){
      return 6;
    }

    if(isMainLineCompatible()){
      return 4;
    }

    if(!checkFaustusFolder()) {
      if(File(Constants.kBatteryThresholdPath).existsSync()) {
        return 3;
      } else {
        return 2;
      }
    }else if(await _terminalDelegate.isKernelCompatible()) {
      return 5;
    }

    if((await _terminalDelegate.listPackagesToInstall()).isNotEmpty) {
      return 1;
    }

    return 0;
  }


  @override
  int convertVersionToInt(String version) {
    return int.tryParse(version.replaceAll('.', '').replaceAll('+', '').split('-')[0])??0;
  }

  @override
  bool checkFaustusFolder()=>Directory(Constants.kFaustusModulePath).existsSync();

  Future _getAccess() async{
    await _terminalDelegate.execute("${Constants.kPolkit} ${super.isMainLine()? _globalConfig.kExecMainlinePath: _globalConfig
        .kExecFaustusPath} init ${_globalConfig.kWorkingDirectory} ${await _prefRepo.getThreshold()}");
  }

  Future<bool> _checkAccess() async{
    return await _terminalDelegate.checkAccess();
  }

  @override
  Future loadScripts() async{
    _globalConfig.kExecBatteryManagerPath= await _terminalDelegate.extractAsset(sourceFileName:Constants.kBatteryManager);
    if(super.isMainLine()){
      _globalConfig.kExecMainlinePath= await _terminalDelegate.extractAsset(sourceFileName: Constants.kMainline);
    }else {
      _globalConfig.kExecFaustusPath=await _terminalDelegate.extractAsset(sourceFileName: Constants.kFaustus);
    }
  }

  @override
  Future<bool> requestAccess() async{
    var checkAccess=await _checkAccess();
    if(!checkAccess) {
      await _getAccess();
      checkAccess=await _checkAccess();
    }
    return checkAccess;
  }

}
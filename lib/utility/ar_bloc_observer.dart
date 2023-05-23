import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/di/di.dart';

class AppBlocObserver extends BlocObserver{

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    sl<ArLogger>().log(data: error, stackTrace: stackTrace);

  }
}
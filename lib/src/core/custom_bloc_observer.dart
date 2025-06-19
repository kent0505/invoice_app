import 'package:flutter_bloc/flutter_bloc.dart';

import 'utils.dart';

class CustomBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger('🟡 EVENT: ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger('🔵 STATE CHANGE: ${bloc.runtimeType} -> $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger('🟢 TRANSITION: ${bloc.runtimeType} -> $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger('🔴 ERROR IN ${bloc.runtimeType}: $error');
    super.onError(bloc, error, stackTrace);
  }
}

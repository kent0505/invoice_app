import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../models/pro.dart';
import '../../../core/utils.dart';
import '../data/pro_repository.dart';

part 'pro_event.dart';

class ProBloc extends Bloc<ProEvent, Pro> {
  final ProRepository _repository;

  ProBloc({required ProRepository repository})
      : _repository = repository,
        super(Pro()) {
    on<ProEvent>(
      (event, emit) => switch (event) {
        CheckPro() => _checkPro(event, emit),
      },
    );
  }

  void _checkPro(
    CheckPro event,
    Emitter<Pro> emit,
  ) async {
    if (isIOS()) {
      emit(Pro(loading: true));

      try {
        late String identifier;

        if (event.initial) {
          final showCount = _repository.getShowCount();
          final isFirstOrSecondShow = showCount == 1 || showCount == 2;
          identifier =
              isFirstOrSecondShow ? Identifiers.paywall2 : Identifiers.paywall1;
          await _repository.saveShowCount(showCount + 1);
        } else {
          identifier = event.identifier;
        }

        final isPro = await _repository.getPro();
        final offering = await _repository.getOffering(identifier);

        emit(Pro(
          isPro: isPro,
          offering: offering,
        ));
      } catch (e) {
        logger(e);
        emit(Pro());
      }
    } else {
      emit(Pro(isPro: true));
    }
  }
}

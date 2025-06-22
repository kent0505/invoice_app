import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../models/pro.dart';
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

        final showCount = _repository.getShowCount();
        final isFirstOrSecondShow = showCount == 3 || showCount == 5;
        identifier =
            isFirstOrSecondShow ? Identifiers.paywall2 : Identifiers.paywall1;
        await _repository.saveShowCount(showCount + 1);

        CustomerInfo customerInfo = await Purchases.getCustomerInfo().timeout(
          const Duration(seconds: 3),
        );
        final offering = await _repository.getOffering(identifier);

        final entitlement = customerInfo.entitlements.active['PRO'];

        String title = '';
        String expireDate = '';

        if (entitlement != null) {
          if (entitlement.productIdentifier ==
              'com.helperg.invoicer.app.week') {
            title = 'Weekly';
          } else if (entitlement.productIdentifier ==
              'com.helperg.invoicer.app.month') {
            title = 'Monthly';
          } else if (entitlement.productIdentifier ==
              'com.helperg.invoicer.app.year') {
            title = 'Yearly';
          }

          try {
            if (entitlement.expirationDate != null &&
                entitlement.expirationDate!.isNotEmpty) {
              DateTime dateTime = DateTime.parse(entitlement.expirationDate!);
              expireDate = DateFormat('dd.MM.yyyy').format(
                dateTime.toLocal(),
              );
            }
          } catch (e) {
            logger(e);
          }
        }

        emit(Pro(
          isPro: customerInfo.entitlements.active.isNotEmpty,
          offering: offering,
          title: title,
          expireDate: expireDate,
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

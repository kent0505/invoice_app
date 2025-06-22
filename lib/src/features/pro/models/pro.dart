import 'package:purchases_flutter/purchases_flutter.dart';

class Pro {
  Pro({
    this.isPro = false,
    this.loading = false,
    this.available = 3,
    this.offering,
    this.title = '',
    this.expireDate = '',
  });

  final bool isPro;
  final bool loading;
  final int available;
  final Offering? offering;
  final String title;
  final String expireDate;
}

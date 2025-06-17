import 'package:purchases_flutter/purchases_flutter.dart';

class Pro {
  Pro({
    this.isPro = false,
    this.loading = false,
    this.offering,
  });

  final bool isPro;
  final bool loading;
  final Offering? offering;
}

import 'package:flutter/material.dart';

import '../models/invoice.dart';

class InvoiceCustomizeScreen extends StatelessWidget {
  const InvoiceCustomizeScreen({super.key, required this.invoice});

  final Invoice invoice;

  static const routePath = '/InvoiceCustomizeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}

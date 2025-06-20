import 'package:flutter/material.dart';

import '../../../core/widgets/appbar.dart';
import '../models/invoice.dart';

class InvoicePreviewScreen extends StatelessWidget {
  const InvoicePreviewScreen({super.key, required this.invoice});

  final Invoice invoice;

  static const routePath = '/InvoicePreviewScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Preview'),
      body: ListView(
        children: [],
      ),
    );
  }
}

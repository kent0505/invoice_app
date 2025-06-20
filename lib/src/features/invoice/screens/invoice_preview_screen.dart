import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../models/invoice.dart';

class InvoicePreviewScreen extends StatelessWidget {
  const InvoicePreviewScreen({super.key, required this.invoice});

  final Invoice invoice;

  static const routePath = '/InvoicePreviewScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Preview',
        right: Button(
          onPressed: () {
            context.push(
              InvoicePreviewScreen.routePath,
              extra: invoice,
            );
          },
          child: const Text(
            'Customize',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: AppFonts.w400,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}

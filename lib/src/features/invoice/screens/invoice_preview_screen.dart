import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../models/preview_data.dart';
import '../widgets/invoice_template1.dart';
import 'invoice_customize_screen.dart';

class InvoicePreviewScreen extends StatelessWidget {
  const InvoicePreviewScreen({super.key, required this.previewData});

  final PreviewData previewData;

  static const routePath = '/InvoicePreviewScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Preview',
        right: Button(
          onPressed: () {
            context.push(
              InvoiceCustomizeScreen.routePath,
              extra: previewData.invoice,
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
        padding: const EdgeInsets.all(16),
        children: [
          InvoiceTemplate1(
            previewData: previewData,
            controller: ScreenshotController(),
          ),
        ],
      ),
    );
  }
}

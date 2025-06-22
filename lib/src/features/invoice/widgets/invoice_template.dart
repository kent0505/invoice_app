import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_app/src/core/utils.dart';
import 'package:screenshot/screenshot.dart';

import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../models/preview_data.dart';
import 'invoice_template1.dart';
import 'invoice_template2.dart';

class InvoiceTemplate extends StatelessWidget {
  const InvoiceTemplate({
    super.key,
    required this.previewData,
    required this.controller,
  });

  final PreviewData previewData;
  final ScreenshotController controller;

  static Future<Uint8List?> capture(
    ScreenshotController controller,
  ) async {
    return await controller.capture();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Screenshot(
        controller: controller,
        child: BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceLoaded) {
              Invoice? invoice;
              try {
                invoice = state.invoices.firstWhere((element) {
                  return element.id == previewData.invoice.id;
                });
              } catch (e) {
                logger(e);
              }

              return switch (invoice?.template) {
                1 => InvoiceTemplate1(previewData: previewData),
                2 => InvoiceTemplate2(previewData: previewData),
                _ => InvoiceTemplate1(previewData: previewData),
              };
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

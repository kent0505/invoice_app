import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';

class InvoiceCustomizeScreen extends StatelessWidget {
  const InvoiceCustomizeScreen({super.key, required this.invoice});

  final Invoice invoice;

  static const routePath = '/InvoiceCustomizeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Customize'),
      body: GridView.count(
        padding: EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1 / 1.414,
        children: [
          _TemplateCard(
            id: 1,
            asset: Assets.template1,
            invoice: invoice,
          ),
          _TemplateCard(
            id: 2,
            asset: Assets.template2,
            invoice: invoice,
          ),
          _TemplateCard(
            id: 3,
            asset: Assets.template3,
            invoice: invoice,
          ),
          _TemplateCard(
            id: 4,
            asset: Assets.template4,
            invoice: invoice,
          ),
          _TemplateCard(
            id: 5,
            asset: Assets.template5,
            invoice: invoice,
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.id,
    required this.asset,
    required this.invoice,
  });

  final int id;
  final String asset;
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () {
        invoice.template = id;
        context.read<InvoiceBloc>().add(EditInvoice(invoice: invoice));
        Future.delayed(
          Duration(milliseconds: 400),
          () {
            if (context.mounted) {
              context.pop();
            }
          },
        );
      },
      child: ImageWidget(
        asset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

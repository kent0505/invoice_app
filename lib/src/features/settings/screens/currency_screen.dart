import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../invoice/bloc/invoice_bloc.dart';
import '../data/settings_repository.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  static const routePath = '/CurrencyScreen';

  @override
  Widget build(BuildContext context) {
    List<String> currencies = [
      '\$',
      '€',
      '₽',
    ];

    return Scaffold(
      appBar: const Appbar(title: 'Currency'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          final currency = currencies[index];

          return _CurrencyTile(
            currency: currency,
            onPressed: (value) async {
              await context.read<SettingsRepository>().setCurrency(value);
              if (context.mounted) {
                context.read<InvoiceBloc>().add(GetInvoices());
                context.pop();
              }
            },
          );
        },
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.currency,
    required this.onPressed,
  });

  final String currency;
  final void Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () {
        onPressed(currency);
      },
      child: Container(
        height: 44,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Color(0xff7D81A3),
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              currency,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: AppFonts.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

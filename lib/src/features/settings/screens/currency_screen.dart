import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../invoice/bloc/invoice_bloc.dart';
import '../data/settings_repository.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  static const routePath = '/CurrencyScreen';

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  String currency = '';

  List<String> currencies = [
    '\$',
    '€',
    '£',
    '¥',
    '₹',
    '₽',
    '₩',
    '₪',
    '₨',
    '₡',
    '₦',
    '₱',
    '₫',
    '₪',
    '₵',
    '₲',
    '₴',
    '₸',
    '₼',
    'R',
    'R\$',
    'kr',
    'Kč',
    'zł',
    'Ft',
    'lei',
    'лв',
    'din',
    'kn',
    'Lt',
    'Ls',
    '₺',
    'S\$',
    'HK\$',
    'CA\$',
    'AU\$',
    'NZ\$',
    'CHF',
  ];

  void onCurrency(String value) async {
    currency = value;
    setState(() {});
    await context.read<SettingsRepository>().setCurrency(value);
    if (mounted) {
      context.read<InvoiceBloc>().add(GetInvoices());
    }
  }

  @override
  void initState() {
    super.initState();
    currency = context.read<SettingsRepository>().getCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Currency'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          return _CurrencyTile(
            currency: currencies[index],
            current: currency,
            onPressed: onCurrency,
          );
        },
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.currency,
    required this.current,
    required this.onPressed,
  });

  final String currency;
  final String current;
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
            Expanded(
              child: Text(
                currency,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: AppFonts.w400,
                ),
              ),
            ),
            if (currency == current)
              const Icon(
                Icons.check,
                color: Color(0xffFF4400),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../invoice/bloc/invoice_bloc.dart';
import '../../invoice/models/invoice.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../../settings/screens/settings_screen.dart';

class TotalIncome extends StatelessWidget {
  const TotalIncome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 16,
      ).copyWith(top: 16 + MediaQuery.of(context).viewPadding.top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Income',
                  style: TextStyle(
                    color: Color(0xff8E8E93),
                    fontSize: 14,
                  ),
                ),
                BlocBuilder<InvoiceBloc, List<Invoice>>(
                  builder: (context, invoices) {
                    final sorted = invoices.where((element) {
                      return element.paymentMethod.isNotEmpty;
                    }).toList();

                    return BlocBuilder<ItemBloc, List<Item>>(
                      builder: (context, items) {
                        double amount = 0;
                        for (Invoice invoice in sorted) {
                          for (Item item in items) {
                            if (item.invoiceID == invoice.id) {
                              final basePrice =
                                  double.tryParse(item.discountPrice) ?? 0;
                              final taxRate = double.tryParse(item.tax) ?? 0;
                              final priceWithTax =
                                  basePrice + (basePrice * taxRate / 100);
                              amount += priceWithTax;
                            }
                          }
                        }

                        return Text(
                          '\$${amount.toStringAsFixed(2)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontFamily: AppFonts.w800,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Button(
            child: SvgWidget(Assets.settings),
            onPressed: () {
              context.push(SettingsScreen.routePath);
            },
          ),
        ],
      ),
    );
  }
}

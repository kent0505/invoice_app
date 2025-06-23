import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';

class InvoicePay extends StatelessWidget {
  const InvoicePay({super.key, required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Button(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.vertical(
                top: Radius.circular(10),
              ),
            ),
            builder: (context) {
              return Container(
                height: 358,
                decoration: const BoxDecoration(
                  color: Color(0xffF3F3F1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Mark as Paid',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: AppFonts.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 28,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xff94A3B8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              formatTimestamp(
                                  DateTime.now().millisecondsSinceEpoch),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: AppFonts.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select How You Received the money',
                      style: TextStyle(
                        color: Color(0xff8E8E93),
                        fontSize: 12,
                        fontFamily: AppFonts.w400,
                      ),
                    ),
                    const SizedBox(height: 30),
                    FittedBox(
                      child: Row(
                        spacing: 10,
                        children: [
                          _PayMethod(
                            invoice: invoice,
                            asset: Assets.paid1,
                            title: 'Cash',
                          ),
                          _PayMethod(
                            invoice: invoice,
                            asset: Assets.paid2,
                            title: 'Check',
                          ),
                          _PayMethod(
                            invoice: invoice,
                            asset: Assets.paid3,
                            title: 'Bank',
                          ),
                          _PayMethod(
                            invoice: invoice,
                            asset: Assets.paid4,
                            title: 'PayPal',
                            notPaid: true,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Button(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xff7D81A3),
                          fontSize: 14,
                          fontFamily: AppFonts.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          );
        },
        minSize: 40,
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                invoice.isEstimate.isEmpty
                    ? 'Has Invoice Been Paid?'
                    : 'Has Estimate Been Paid?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: AppFonts.w600,
                ),
              ),
            ),
            Container(
              height: 22,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xffFF4400),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  'Mark as Paid',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: AppFonts.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _PayMethod extends StatelessWidget {
  const _PayMethod({
    required this.invoice,
    required this.asset,
    required this.title,
    this.notPaid = false,
  });

  final Invoice invoice;
  final String title;
  final String asset;
  final bool notPaid;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () {
        invoice.paymentMethod = notPaid ? '' : title;
        invoice.paymentDate =
            notPaid ? 0 : DateTime.now().millisecondsSinceEpoch;
        context.read<InvoiceBloc>().add(EditInvoice(invoice: invoice));
        context.pop();
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: const Color(0xffDEDEDE),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            notPaid
                ? const SizedBox(height: 30)
                : SvgWidget(
                    asset,
                    height: 30,
                  ),
            const SizedBox(height: 4),
            Text(
              notPaid ? 'Not Paid' : title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: AppFonts.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

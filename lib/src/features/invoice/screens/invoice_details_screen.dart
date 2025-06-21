import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../client/bloc/client_bloc.dart';
import '../../client/models/client.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../widgets/invoice_appbar.dart';
import '../widgets/invoice_pay.dart';
import 'edit_invoice_screen.dart';
import 'invoice_preview_screen.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  const InvoiceDetailsScreen({super.key, required this.invoice});

  final Invoice invoice;

  static const routePath = '/InvoiceDetailsScreen';

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  late Invoice invoice;
  Client? client;

  void onPreview() {
    context.push(
      InvoicePreviewScreen.routePath,
      extra: invoice,
    );
  }

  void onPromoPrinter() {}

  void onPdfService() {}

  void onPrint() {}

  void onEdit() {
    context.push(
      EditInvoiceScreen.routePath,
      extra: invoice,
    );
  }

  void onShare() {}

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
    try {
      client = context
          .read<ClientBloc>()
          .state
          .firstWhere((element) => element.id == invoice.clientID);
    } catch (e) {
      logger(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InvoiceAppbar(
        title: '',
        onPreview: onPreview,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<InvoiceBloc, List<Invoice>>(
                        builder: (context, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 22,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFF4400),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    invoice.paymentMethod.isEmpty
                                        ? 'Not Paid'
                                        : 'Paid',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: AppFonts.w400,
                                    ),
                                  ),
                                ),
                              ),
                              if (invoice.paymentMethod.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Container(
                                  height: 22,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff94A3B8),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      invoice.paymentMethod,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: AppFonts.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        client?.name ?? '?',
                        style: const TextStyle(
                          color: Color(0xff7D81A3),
                          fontSize: 16,
                          fontFamily: AppFonts.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<ItemBloc, List<Item>>(
                        builder: (context, items) {
                          return Text(
                            calculateInvoiceMoney(
                              items: items,
                              invoiceID: invoice.id,
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontFamily: AppFonts.w600,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                InvoicePay(invoice: invoice),
                BlocBuilder<InvoiceBloc, List<Invoice>>(
                  builder: (context, state) {
                    return invoice.paymentDate == 0
                        ? const SizedBox()
                        : Column(
                            children: [
                              _Data(
                                title: 'Marked as Paid',
                                data: formatTimestamp(invoice.paymentDate),
                                asset: Assets.calendar,
                              ),
                              const _Divider(),
                            ],
                          );
                  },
                ),
                _Data(
                  title: 'Issued',
                  data: formatTimestamp(invoice.date),
                ),
                const _Divider(),
                _Data(
                  title: 'Invoice #',
                  data: formatInvoiceNumber(invoice.number),
                ),
                const SizedBox(height: 30),
                _OtherApp(
                  title: 'Promo Printer',
                  onPressed: onPromoPrinter,
                ),
                const SizedBox(height: 10),
                _OtherApp(
                  title: 'PDF service',
                  onPressed: onPdfService,
                ),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              Row(
                children: [
                  _Button(
                    title: 'Print',
                    asset: Assets.print,
                    onPressed: onPrint,
                  ),
                  const Spacer(),
                  _Button(
                    title: 'Edit',
                    asset: Assets.edit,
                    onPressed: onEdit,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              MainButton(
                title: 'Share Invoice',
                onPressed: onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Data extends StatelessWidget {
  const _Data({
    required this.title,
    required this.data,
    this.asset = '',
  });

  final String title;
  final String data;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: AppFonts.w400,
              ),
            ),
          ),
          Text(
            data,
            style: const TextStyle(
              color: Color(0xff7D81A3),
              fontSize: 14,
              fontFamily: AppFonts.w400,
            ),
          ),
          if (asset.isNotEmpty) ...[
            const SizedBox(width: 6),
            SvgWidget(asset),
          ],
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: const Color(0xff7D81A3),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.title,
    required this.asset,
    required this.onPressed,
  });

  final String title;
  final String asset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            SvgWidget(asset),
            Text(
              title,
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

class _OtherApp extends StatelessWidget {
  const _OtherApp({
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Button(
        onPressed: onPressed,
        child: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xffFF4400),
                fontSize: 12,
                fontFamily: AppFonts.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

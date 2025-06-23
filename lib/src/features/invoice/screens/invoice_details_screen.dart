import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../business/bloc/business_bloc.dart';
import '../../business/models/business.dart';
import '../../client/bloc/client_bloc.dart';
import '../../client/models/client.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../models/photo.dart';
import '../widgets/invoice_template.dart';
import '../widgets/photos_list.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../models/preview_data.dart';
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
  final screenshotController = ScreenshotController();
  late Invoice invoice;
  List<Business> business = [];
  List<Client> clients = [];
  List<Item> items = [];
  List<Photo> photos = [];
  Client? client;
  File file = File('');

  void onPreview() {
    context.push(
      InvoicePreviewScreen.routePath,
      extra: getData(),
    );
  }

  void onPromoPrinter() async {
    try {
      if (!await launchUrl(
        Uri.parse('https://pub.dev/'),
      )) {
        throw 'Could not launch url';
      }
    } catch (e) {
      logger(e);
    }
  }

  void onPdfService() async {
    try {
      if (!await launchUrl(
        Uri.parse('https://www.google.com/'),
      )) {
        throw 'Could not launch url';
      }
    } catch (e) {
      logger(e);
    }
  }

  Future<pw.Document> captureWidget() async {
    final pdf = pw.Document();
    final bytes = await InvoiceTemplate.capture(screenshotController);
    if (bytes != null) {
      final dir = await getTemporaryDirectory();
      final name = invoice.isEstimate.isEmpty ? 'invoice' : 'estimate';
      // file = File('${dir.path}/${name}_${invoice.number}.png');
      // await file.writeAsBytes(bytes);
      pdf.addPage(
        pw.Page(
          margin: pw.EdgeInsets.zero,
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(bytes),
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );
      file = File('${dir.path}/${name}_${invoice.number}.pdf');
      await file.writeAsBytes(await pdf.save());
    }
    return pdf;
  }

  void onPrint() async {
    final pdf = await captureWidget();
    Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void onEdit() {
    context.push(
      EditInvoiceScreen.routePath,
      extra: invoice,
    );
  }

  void onShare() async {
    await captureWidget();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        sharePositionOrigin: Rect.fromLTWH(100, 100, 200, 200),
      ),
    );
  }

  PreviewData getData() {
    final state = context.read<InvoiceBloc>().state;

    return PreviewData(
      invoice: state is InvoiceLoaded
          ? state.invoices.firstWhere((element) {
              return element.id == invoice.id;
            })
          : invoice,
      business: context.read<BusinessBloc>().state.where((element) {
        return element.id == invoice.businessID;
      }).toList(),
      clients: context.read<ClientBloc>().state.where((element) {
        return element.id == invoice.clientID;
      }).toList(),
      items: context.read<ItemBloc>().state.where((element) {
        return element.invoiceID == invoice.id;
      }).toList(),
      photos: state is InvoiceLoaded
          ? state.photos.where(
              (element) {
                return element.id == invoice.id;
              },
            ).toList()
          : [],
    );
  }

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
    final data = getData();
    business = data.business;
    clients = data.clients;
    items = data.items;
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
                Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 200,
                        child: InvoiceTemplate(
                          previewData: PreviewData(
                            invoice: invoice,
                            business: business,
                            clients: clients,
                            items: items,
                            photos: photos,
                          ),
                          controller: screenshotController,
                        ),
                      ),
                    ),
                    Container(
                      height: 130,
                      margin: const EdgeInsets.only(top: 100),
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
                          BlocBuilder<InvoiceBloc, InvoiceState>(
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
                  ],
                ),
                const SizedBox(height: 20),
                InvoicePay(invoice: invoice),
                BlocBuilder<InvoiceBloc, InvoiceState>(
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
                  title:
                      invoice.isEstimate.isEmpty ? 'Invoice #' : 'Estimate #',
                  data: formatInvoiceNumber(invoice.number),
                ),
                const SizedBox(height: 30),
                BlocBuilder<InvoiceBloc, InvoiceState>(
                  builder: (context, state) {
                    if (state is InvoiceLoaded &&
                        invoice.isEstimate.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: PhotosList(
                          photos: state.photos.where((element) {
                            return element.id == invoice.id;
                          }).toList(),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
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
                title: invoice.isEstimate.isEmpty
                    ? 'Share Invoice'
                    : 'Share Estimate',
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

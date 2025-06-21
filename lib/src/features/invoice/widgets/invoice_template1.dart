import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/image_widget.dart';
import '../../business/bloc/business_bloc.dart';
import '../../business/models/business.dart';
import '../../client/bloc/client_bloc.dart';
import '../../client/models/client.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../models/invoice.dart';

class InvoiceTemplate1 extends StatelessWidget {
  const InvoiceTemplate1({
    super.key,
    required this.invoice,
    required this.controller,
  });

  final Invoice invoice;
  final ScreenshotController controller;

  static Future<Uint8List?> capture(
    ScreenshotController controller,
  ) async {
    return await controller.capture();
  }

  @override
  Widget build(BuildContext context) {
    final businesses = context.watch<BusinessBloc>().state;
    Business? business = businesses.firstWhere(
      (element) => element.id == invoice.businessID,
    );

    final clients = context.watch<ClientBloc>().state;
    Client? client = clients.firstWhere(
      (element) => element.id == invoice.clientID,
    );

    final items = context.watch<ItemBloc>().state.where((element) {
      return element.invoiceID == invoice.id;
    }).toList();

    final Set<int> seenIds = {};
    final List<Item> uniqueItems = [];

    double subtotal = 0;
    double discount = 0;
    double tax = 0;

    for (final item in items) {
      if (!seenIds.contains(item.id)) {
        seenIds.add(item.id);
        uniqueItems.add(item);
      }

      final price = double.tryParse(item.price) ?? 0;
      final discountPrice = double.tryParse(item.discountPrice) ?? 0;
      final taxPercent = double.tryParse(item.tax) ?? 0;

      subtotal += price;
      discount += discountPrice;

      final itemTax = discountPrice * (taxPercent / 100);
      tax += itemTax;
    }

    return FittedBox(
      child: Screenshot(
        controller: controller,
        child: Container(
          width: 500,
          height: 500 * 1.414,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        File(business.imageLogo),
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: ImageWidget.errorBuilder,
                        frameBuilder: ImageWidget.frameBuilder,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatTimestamp(invoice.date),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: AppFonts.w400,
                        ),
                      ),
                      Text(
                        'INVOICE # ${invoice.number}',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: AppFonts.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _From(
                          name: client.name,
                          phone: client.phone,
                          email: client.email,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _From(
                          name: business.name,
                          phone: business.phone,
                          email: business.email,
                          isClient: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 40,
                color: Color(0xff8E8E93).withValues(alpha: 0.2),
                child: Row(
                  children: [
                    Expanded(
                      child: _ItemRowName(title: 'Name'),
                    ),
                    const SizedBox(
                      width: 80,
                      child: _ItemRowName(title: 'QTY'),
                    ),
                    const SizedBox(
                      width: 80,
                      child: _ItemRowName(title: 'Price'),
                    ),
                    const SizedBox(
                      width: 80,
                      child: _ItemRowName(title: 'Amount'),
                    ),
                  ],
                ),
              ),
              Column(
                children: List.generate(
                  uniqueItems.length,
                  (index) {
                    double amount = 0;
                    for (Item item in items) {
                      if (item.id == uniqueItems[index].id) {
                        amount += double.tryParse(item.price) ?? 0;
                      }
                    }

                    return Container(
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0xff8E8E93).withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ItemRowData(
                              data: uniqueItems[index].title,
                            ),
                          ),
                          const _Divider(),
                          SizedBox(
                            width: 80,
                            child: _ItemRowData(
                              data: items
                                  .where((element) =>
                                      element.id == uniqueItems[index].id)
                                  .length
                                  .toString(),
                            ),
                          ),
                          const _Divider(),
                          SizedBox(
                            width: 80,
                            child: _ItemRowData(
                              data:
                                  (double.tryParse(uniqueItems[index].price) ??
                                          0)
                                      .toStringAsFixed(2),
                            ),
                          ),
                          const _Divider(),
                          SizedBox(
                            width: 80,
                            child: _ItemRowData(
                              data: amount.toStringAsFixed(2),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (invoice.imageSignature.isNotEmpty ||
                      business.imageSignature.isNotEmpty)
                    Column(
                      children: [
                        const Text(
                          'Signature:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: AppFonts.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SvgPicture.string(
                          business.imageSignature.isEmpty
                              ? invoice.imageSignature
                              : business.imageSignature,
                          height: 40,
                        ),
                      ],
                    ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Amount(
                        data: 'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                      ),
                      _Amount(
                        data:
                            'Discount: \$${(subtotal - discount).toStringAsFixed(2)}',
                      ),
                      _Amount(
                        data: 'Tax: \$${(tax).toStringAsFixed(2)}',
                      ),
                      _Amount(
                        data: 'Total: \$${(discount + tax).toStringAsFixed(2)}',
                        bold: true,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _From extends StatelessWidget {
  const _From({
    required this.name,
    required this.phone,
    required this.email,
    this.isClient = true,
  });

  final String name;

  final String phone;
  final String email;
  final bool isClient;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isClient ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          isClient ? 'INVOICE TO:' : 'INVOICE FROM:',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: AppFonts.w600,
          ),
        ),
        _FromData(title: name),
        // _FromData(title: to),
        _FromData(title: 'Phone: $phone'),
        if (email.isNotEmpty) _FromData(title: 'Email: $email'),
      ],
    );
  }
}

class _FromData extends StatelessWidget {
  const _FromData({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontFamily: AppFonts.w400,
        height: 1.2,
      ),
    );
  }
}

class _ItemRowName extends StatelessWidget {
  const _ItemRowName({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontFamily: AppFonts.w600,
        ),
      ),
    );
  }
}

class _ItemRowData extends StatelessWidget {
  const _ItemRowData({required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        data,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontFamily: AppFonts.w400,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Color(0xff8E8E93).withValues(alpha: 0.2),
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({
    required this.data,
    this.bold = false,
  });

  final String data;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: bold ? AppFonts.w600 : AppFonts.w400,
      ),
    );
  }
}

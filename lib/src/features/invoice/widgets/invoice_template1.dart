import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/image_widget.dart';
import '../../business/models/business.dart';
import '../../client/models/client.dart';
import '../../item/models/item.dart';
import '../../settings/data/settings_repository.dart';
import '../models/preview_data.dart';

class InvoiceTemplate1 extends StatelessWidget {
  const InvoiceTemplate1({super.key, required this.previewData});

  final PreviewData previewData;

  @override
  Widget build(BuildContext context) {
    final Set<int> seenIds = {};
    List<Item> uniqueItems = [];

    double subtotal = 0;
    double discount = 0;
    double tax = 0;

    for (final item in previewData.items) {
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

    final isEstimate = previewData.invoice.isEstimate.isNotEmpty;

    uniqueItems = uniqueItems.take(isEstimate ? 8 : 10).toList();

    final signature = previewData.invoice.imageSignature.isNotEmpty
        ? previewData.invoice.imageSignature
        : previewData.business.isNotEmpty
            ? previewData.business.first.imageSignature
            : '';

    final dates = previewData.invoice.dueDate != 0
        ? '${formatTimestamp2(previewData.invoice.date)} - ${formatTimestamp2(previewData.invoice.dueDate)}'
        : formatTimestamp2(previewData.invoice.date);

    final currency = context.read<SettingsRepository>().getCurrency();

    return Container(
      width: 500,
      height: 500 * 1.414,
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 80,
                child: previewData.business.isEmpty
                    ? const SizedBox()
                    : previewData.business.first.imageLogo.isEmpty
                        ? const SizedBox()
                        : Image.file(
                            File(previewData.business.first.imageLogo),
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: ImageWidget.errorBuilder,
                            frameBuilder: ImageWidget.frameBuilder,
                          ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    dates,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: AppFonts.w400,
                    ),
                  ),
                  Text(
                    isEstimate
                        ? 'ESTIMATE # ${previewData.invoice.number}'
                        : 'INVOICE # ${previewData.invoice.number}',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (previewData.clients.isNotEmpty)
                      _Client(
                        client: previewData.clients.first,
                        isEstimate: isEstimate,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (previewData.business.isNotEmpty)
                      _Business(
                        business: previewData.business.first,
                        isEstimate: isEstimate,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 32,
            color: Color(0xff8E8E93).withValues(alpha: 0.2),
            child: const Row(
              children: [
                Expanded(
                  child: _ItemRowName(title: 'Name'),
                ),
                SizedBox(
                  width: 80,
                  child: _ItemRowName(title: 'QTY'),
                ),
                SizedBox(
                  width: 80,
                  child: _ItemRowName(title: 'Price'),
                ),
                SizedBox(
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
                for (Item item in previewData.items) {
                  if (item.id == uniqueItems[index].id) {
                    amount += double.tryParse(item.price) ?? 0;
                  }
                }

                return Container(
                  height: 30,
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
                          data: previewData.items
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
                          data: (double.tryParse(uniqueItems[index].price) ?? 0)
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
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (previewData.invoice.isEstimate.isNotEmpty) ...[
                SizedBox(
                  width: 80 * 3,
                  child: Wrap(
                    children: List.generate(
                      previewData.photos.length,
                      (index) {
                        return Image.file(
                          File(previewData.photos[index].path),
                          frameBuilder: ImageWidget.frameBuilder,
                          errorBuilder: ImageWidget.errorBuilder,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ] else if (signature.isNotEmpty) ...[
                const SizedBox(height: 10),
                SvgPicture.string(
                  signature,
                  height: 40,
                ),
              ],
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Amount(
                    data: 'Subtotal: $currency${subtotal.toStringAsFixed(2)}',
                  ),
                  _Amount(
                    data:
                        'Discount: $currency${(subtotal - discount).toStringAsFixed(2)}',
                  ),
                  _Amount(
                    data:
                        'Tax ${((tax / discount) * 100).toStringAsFixed(2)}%: $currency${(tax).toStringAsFixed(2)}',
                  ),
                  _Amount(
                    data:
                        'Total: $currency${(discount + tax).toStringAsFixed(2)}',
                    bold: true,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Client extends StatelessWidget {
  const _Client({
    required this.client,
    required this.isEstimate,
  });

  final Client client;
  final bool isEstimate;

  @override
  Widget build(BuildContext context) {
    final to = isEstimate ? 'ESTIMATE TO:' : 'INVOICE TO:';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          to,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: AppFonts.w600,
          ),
        ),
        _FromData(title: client.name),
        _FromData(title: 'Phone: ${client.phone}'),
        _FromData(title: 'Email: ${client.email}'),
        _FromData(
          title: 'Address: ${client.address}',
          maxLines: 2,
        ),
      ],
    );
  }
}

class _Business extends StatelessWidget {
  const _Business({
    required this.business,
    required this.isEstimate,
  });

  final Business business;
  final bool isEstimate;

  @override
  Widget build(BuildContext context) {
    final from = isEstimate ? 'ESTIMATE FROM:' : 'INVOICE FROM:';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          from,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: AppFonts.w600,
          ),
        ),
        _FromData(title: business.name),
        _FromData(title: 'Phone: ${business.phone}'),
        _FromData(title: 'Email: ${business.email}'),
        _FromData(
          title: 'Address: ${business.address}',
          maxLines: 2,
        ),
        if (business.vat.isNotEmpty)
          _FromData(title: 'VAT No: ${business.vat}'),
        if (business.bank.isNotEmpty)
          _FromData(title: 'Bank: ${business.bank}'),
        if (business.iban.isNotEmpty)
          _FromData(title: 'IBAN: ${business.iban}'),
        if (business.bic.isNotEmpty) _FromData(title: 'BIC: ${business.bic}'),
      ],
    );
  }
}

class _FromData extends StatelessWidget {
  const _FromData({
    required this.title,
    this.maxLines = 1,
  });

  final String title;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 10,
        fontFamily: AppFonts.w400,
        height: 1.1,
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
        fontSize: 14,
        fontFamily: bold ? AppFonts.w600 : AppFonts.w400,
      ),
    );
  }
}

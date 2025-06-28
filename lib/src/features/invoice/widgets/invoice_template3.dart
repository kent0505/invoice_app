import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/image_widget.dart';
import '../../item/models/item.dart';
import '../../settings/data/settings_repository.dart';
import '../models/preview_data.dart';

class InvoiceTemplate3 extends StatelessWidget {
  const InvoiceTemplate3({
    super.key,
    required this.previewData,
    required this.color,
  });

  final PreviewData previewData;
  final Color color;

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

    uniqueItems = uniqueItems.take(isEstimate ? 7 : 10).toList();

    final signature = previewData.invoice.imageSignature.isNotEmpty
        ? previewData.invoice.imageSignature
        : previewData.business.isNotEmpty
            ? previewData.business.first.imageSignature
            : '';

    final dates = previewData.invoice.dueDate != 0
        ? '${formatTimestamp2(previewData.invoice.date)} - ${formatTimestamp2(previewData.invoice.dueDate)}'
        : formatTimestamp2(previewData.invoice.date);

    return Container(
      width: 500,
      height: 500 * 1.414,
      color: Colors.white,
      padding: const EdgeInsets.all(20).copyWith(bottom: 0),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEstimate
                        ? 'ESTIMATE #${previewData.invoice.number}'
                        : 'INVOICE #${previewData.invoice.number}',
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontFamily: AppFonts.w600,
                    ),
                  ),
                  Text(
                    dates,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontFamily: AppFonts.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _Logo(path: previewData.business.first.imageLogo),
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
                    if (previewData.clients.isNotEmpty) ...[
                      _Text(
                        'Billing to:',
                        bold: true,
                        color: color,
                      ),
                      _Text(
                        previewData.clients.first.name,
                        bold: true,
                      ),
                      _Text(previewData.clients.first.phone),
                      _Text(previewData.clients.first.email),
                      _Text(
                        previewData.clients.first.address,
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (previewData.business.isNotEmpty) ...[
                      _Text(
                        'Billing from:',
                        bold: true,
                        color: color,
                      ),
                      _Text(
                        previewData.business.first.name,
                        bold: true,
                        maxLines: 1,
                      ),
                      _Text(
                        previewData.business.first.phone,
                        maxLines: 1,
                      ),
                      _Text(
                        previewData.business.first.email,
                        maxLines: 1,
                      ),
                      _Text(
                        previewData.business.first.address,
                        maxLines: 2,
                      ),
                      if (previewData.business.first.vat.isNotEmpty)
                        _Text(
                          'VAT No: ${previewData.business.first.vat}',
                          maxLines: 1,
                        ),
                      if (previewData.business.first.bank.isNotEmpty)
                        _Text(
                          'Bank: ${previewData.business.first.bank}',
                          maxLines: 1,
                        ),
                      if (previewData.business.first.iban.isNotEmpty)
                        _Text(
                          'IBAN: ${previewData.business.first.iban}',
                          maxLines: 1,
                        ),
                      if (previewData.business.first.bic.isNotEmpty)
                        _Text(
                          'BIC: ${previewData.business.first.bic}',
                          maxLines: 1,
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              _DataTitleRow(color: color),
              Column(
                children: List.generate(
                  uniqueItems.length,
                  (index) {
                    double total = 0;
                    for (Item item in previewData.items) {
                      if (item.id == uniqueItems[index].id) {
                        total += double.tryParse(item.price) ?? 0;
                      }
                    }

                    final color = index % 2 == 0
                        ? Colors.transparent
                        : const Color(0xffEBEBEB);

                    return _Data(
                      name: uniqueItems[index].title,
                      price: double.tryParse(uniqueItems[index].price) ?? 0,
                      quantity: previewData.items.where((element) {
                        return element.id == uniqueItems[index].id;
                      }).length,
                      total: total,
                      color: color,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: previewData.invoice.paymentMethod.isEmpty
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Text(
                                'Payment Method:',
                                bold: true,
                              ),
                              _Text(previewData.invoice.paymentMethod),
                              const SizedBox(height: 20),
                              _Signature(signature: signature),
                            ],
                          ),
                  ),
                  const Spacer(),
                  _Amount(
                    subtotal: subtotal,
                    discount: discount,
                    tax: tax,
                    color: color,
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            // width: 150,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(previewData.photos.length, (index) {
                return Image.file(
                  File(previewData.photos[index].path),
                  frameBuilder: ImageWidget.frameBuilder,
                  errorBuilder: ImageWidget.errorBuilder,
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: path.isEmpty
          ? const SizedBox()
          : Image.file(
              File(path),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: ImageWidget.errorBuilder,
              frameBuilder: ImageWidget.frameBuilder,
            ),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text(
    this.data, {
    this.bold = false,
    this.color = Colors.black,
    this.maxLines,
  });

  final String data;
  final bool bold;
  final Color color;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontFamily: bold ? AppFonts.w600 : AppFonts.w400,
        height: 1.3,
      ),
    );
  }
}

class _Data extends StatelessWidget {
  const _Data({
    required this.name,
    required this.price,
    required this.quantity,
    required this.total,
    required this.color,
  });

  final String name;
  final double price;
  final int quantity;
  final double total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      decoration: BoxDecoration(color: color),
      child: Row(
        children: [
          Expanded(
            child: _DataText(name),
          ),
          SizedBox(
            width: 80,
            child: _DataText(price.toStringAsFixed(2)),
          ),
          SizedBox(
            width: 80,
            child: _DataText(quantity.toString()),
          ),
          SizedBox(
            width: 80,
            child: _DataText(total.toStringAsFixed(2)),
          ),
        ],
      ),
    );
  }
}

class _DataText extends StatelessWidget {
  const _DataText(this.data);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
      child: Text(
        data,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontFamily: AppFonts.w400,
        ),
      ),
    );
  }
}

class _DataTitleRow extends StatelessWidget {
  const _DataTitleRow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(color: color),
      child: const Row(
        children: [
          Expanded(
            child: _DataTitle('Product Description'),
          ),
          SizedBox(
            width: 80,
            child: _DataTitle('Price'),
          ),
          SizedBox(
            width: 80,
            child: _DataTitle('Quantity'),
          ),
          SizedBox(
            width: 80,
            child: _DataTitle('Total'),
          ),
        ],
      ),
    );
  }
}

class _DataTitle extends StatelessWidget {
  const _DataTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontFamily: AppFonts.w600,
        ),
      ),
    );
  }
}

class _Signature extends StatelessWidget {
  const _Signature({required this.signature});

  final String signature;

  @override
  Widget build(BuildContext context) {
    return signature.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              const Text(
                'Signature:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: AppFonts.w600,
                ),
              ),
              const SizedBox(height: 10),
              SvgPicture.string(
                signature,
                height: 40,
              ),
            ],
          );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.color,
  });

  final double subtotal;
  final double discount;
  final double tax;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          _AmountRow(
            title: 'Subtotal:',
            data: subtotal,
          ),
          _AmountRow(
            title: 'Discount:',
            data: subtotal - discount,
          ),
          _AmountRow(
            title: 'Tax ${((tax / discount) * 100).toStringAsFixed(2)}%:',
            data: tax,
          ),
          const SizedBox(height: 4),
          Container(
            height: 30,
            color: color,
            child: _AmountRow(
              title: 'Total:',
              data: discount + tax,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.title,
    required this.data,
    this.color = Colors.black,
  });

  final String title;
  final double data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final currency = context.read<SettingsRepository>().getCurrency();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontFamily: AppFonts.w600,
            height: 1.2,
          ),
        ),
        Expanded(
          child: Text(
            '$currency${data.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontFamily: AppFonts.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

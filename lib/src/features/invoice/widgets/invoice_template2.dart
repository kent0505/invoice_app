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

class InvoiceTemplate2 extends StatelessWidget {
  const InvoiceTemplate2({super.key, required this.previewData});

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

    return Container(
      width: 500,
      height: 500 * 1.414,
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 150,
              height: 500 * 1.414,
              color: const Color(0xff1b1509),
              child: Column(
                children: [
                  _Logo(path: previewData.business.first.imageLogo),
                ],
              ),
            ),
          ),
          Positioned(
            top: 26,
            right: 20,
            child: Text(
              dates,
              style: TextStyle(
                color: const Color(0xff1b1509),
                fontSize: 12,
                fontFamily: AppFonts.w600,
              ),
            ),
          ),
          if (previewData.clients.isNotEmpty)
            Positioned(
              top: 20,
              left: 170,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            Text(
                              isEstimate
                                  ? 'ESTIMATE ${previewData.invoice.number}'
                                  : 'INVOICE #${previewData.invoice.number}',
                              style: const TextStyle(
                                color: Color(0xff1B1509),
                                fontSize: 20,
                                fontFamily: AppFonts.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (previewData.clients.isNotEmpty) ...[
                        _Text(
                          'Billing to:',
                          bold: true,
                        ),
                        _Text(
                          previewData.clients.first.name,
                          bold: true,
                        ),
                        _Text(previewData.clients.first.phone),
                        _Text(previewData.clients.first.email),
                        _Text(previewData.clients.first.address),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          if (previewData.business.isNotEmpty)
            Positioned(
              top: 20,
              right: 20,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 40),
                      const _Text(
                        'Billing from:',
                        bold: true,
                      ),
                      _Text(
                        previewData.business.first.name,
                        bold: true,
                      ),
                      _Text(previewData.business.first.phone),
                      _Text(previewData.business.first.email),
                      _Text(previewData.business.first.address),
                    ],
                  ),
                ],
              ),
            ),
          _Signature(signature: signature),
          Positioned(
            bottom: 100,
            right: 10,
            child: _Amount(
              subtotal: subtotal,
              discount: discount,
              tax: tax,
              previewData: previewData,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: 150,
              child: Wrap(
                children: List.generate(previewData.photos.length, (index) {
                  return Image.file(
                    File(previewData.photos[index].path),
                    frameBuilder: ImageWidget.frameBuilder,
                    errorBuilder: ImageWidget.errorBuilder,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  );
                }),
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              const _DataTitleRow(),
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
                        ? const Color(0xffD9D9D9)
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
              const SizedBox(height: 225),
            ],
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
      height: 130,
      width: 130,
      child: path.isEmpty
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(130),
                child: Image.file(
                  File(path),
                  height: 130,
                  width: 130,
                  fit: BoxFit.cover,
                  errorBuilder: ImageWidget.errorBuilder,
                  frameBuilder: ImageWidget.frameBuilder,
                ),
              ),
            ),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text(
    this.data, {
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
        fontSize: 12,
        fontFamily: bold ? AppFonts.w600 : AppFonts.w400,
        height: 1.2,
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
    final currency = context.read<SettingsRepository>().getCurrency();

    return Container(
      height: 30,
      decoration: BoxDecoration(color: color),
      child: Row(
        children: [
          Expanded(
            child: _DataText(name),
          ),
          SizedBox(
            width: 80,
            child: _DataText('$currency${price.toStringAsFixed(2)}'),
          ),
          SizedBox(
            width: 80,
            child: _DataText(quantity.toString()),
          ),
          SizedBox(
            width: 80,
            child: _DataText('$currency${total.toStringAsFixed(2)}'),
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
  const _DataTitleRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: const BoxDecoration(
        color: Color(0xff1B1509),
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color(0xffD9D9D9),
          ),
        ),
      ),
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
        : Positioned(
            bottom: 10,
            right: 10,
            child: Column(
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
            ),
          );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.previewData,
  });

  final double subtotal;
  final double discount;
  final double tax;
  final PreviewData previewData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          _AmountRow(
            title: 'Total:',
            data: discount + tax,
          ),
          const SizedBox(height: 4),
          SizedBox(
            child: previewData.invoice.paymentMethod.isEmpty
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Text(
                        'Payment Method:',
                        bold: true,
                      ),
                      _Text(previewData.invoice.paymentMethod),
                    ],
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
  });

  final String title;
  final double data;

  @override
  Widget build(BuildContext context) {
    final currency = context.read<SettingsRepository>().getCurrency();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Text(
          title,
          bold: true,
        ),
        Expanded(
          child: Text(
            '$currency${data.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontFamily: AppFonts.w600,
            ),
          ),
        ),
      ],
    );
  }
}

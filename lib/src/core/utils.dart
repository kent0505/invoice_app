import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../features/client/models/client.dart';
import '../features/item/models/item.dart';
import 'widgets/snack_widget.dart';

void logger(Object message) => developer.log(message.toString());

bool isIOS() {
  return Platform.isIOS;
}

int getTimestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}

String formatTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final formatter = DateFormat('d MMMM yyyy');
  return formatter.format(date);
}

String formatSmartDate(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final now = DateTime.now();
  final isToday =
      date.year == now.year && date.month == now.month && date.day == now.day;
  if (isToday) {
    return 'Today';
  } else {
    return DateFormat('MMM d. yyyy').format(date);
  }
}

Future<XFile> pickImage() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return XFile('');
    return image;
  } catch (e) {
    logger(e);
    return XFile('');
  }
}

Future<List<XFile>> pickImages() async {
  try {
    final image = await ImagePicker().pickMultiImage();
    return image;
  } catch (e) {
    logger(e);
    return [];
  }
}

Future<Client> getContact(BuildContext context) async {
  final isGranted = await FlutterContacts.requestPermission(readonly: true);
  if (isGranted) {
    await FlutterContacts.requestPermission();
    final contact = await FlutterContacts.openExternalPick();
    if (contact != null) {
      return Client(
        id: 0,
        billTo: '',
        name: '${contact.name.first} ${contact.name.last}',
        phone: contact.phones.isNotEmpty ? contact.phones[0].number : '',
        email: contact.emails.isNotEmpty ? contact.emails[0].address : '',
        address:
            contact.addresses.isNotEmpty ? contact.addresses[0].address : '',
      );
    }
  }
  if (context.mounted) {
    SnackWidget.show(
      context,
      message: 'Contact permission not granted',
    );
  }
  return Client(
    id: 0,
    billTo: '',
    name: '',
    phone: '',
    email: '',
    address: '',
  );
}

String formatInvoiceNumber(int number) {
  return number.toString().padLeft(3, '0');
}

String calculateInvoiceMoney({
  required List<Item> items,
  int invoiceID = 0,
}) {
  double amount = items
      .where((item) => invoiceID == 0 || item.invoiceID == invoiceID)
      .fold(0.0, (sum, item) {
    final basePrice = double.tryParse(item.discountPrice) ?? 0;
    final taxRate = double.tryParse(item.tax) ?? 0;
    final priceWithTax = basePrice + (basePrice * taxRate / 100);
    return sum + priceWithTax;
  });

  return '\$${amount.toStringAsFixed(2).replaceAll('.', ',')}';
}

import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';

import '../features/client/models/client.dart';
import 'widgets/snack_widget.dart';

void logger(Object message) => developer.log(message.toString());

bool isIOS() {
  return Platform.isIOS;
}

int getTimestamp() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;
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

Future<Client> getContact(BuildContext context) async {
  final isGranted = await FlutterContacts.requestPermission(readonly: true);
  if (isGranted) {
    await FlutterContacts.requestPermission();
    final contact = await FlutterContacts.openExternalPick();
    if (contact != null) {
      return Client(
        id: 0,
        billTo: '',
        name: contact.name.first,
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

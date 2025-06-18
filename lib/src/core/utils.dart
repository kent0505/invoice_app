import 'dart:developer' as developer;
import 'dart:io';

import 'package:image_picker/image_picker.dart';

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

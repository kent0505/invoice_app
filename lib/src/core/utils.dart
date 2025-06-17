import 'dart:developer' as developer;
import 'dart:io';

void logger(Object message) => developer.log(message.toString());

bool isIOS() {
  return Platform.isIOS;
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants.dart';

class ItemField extends StatelessWidget {
  const ItemField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.decimal = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final bool decimal;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        controller: controller,
        textAlign: textAlign,
        keyboardType: decimal
            ? TextInputType.numberWithOptions(decimal: true)
            : keyboardType,
        textCapitalization: TextCapitalization.sentences,
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
          if (decimal) DecimalInputFormatter()
        ],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontFamily: AppFonts.w400,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          hintStyle: TextStyle(
            color: Color(0xff808080).withValues(alpha: 0.55),
            fontSize: 12,
            fontFamily: AppFonts.w400,
          ),
          hintText: hintText,
        ),
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: onChanged,
      ),
    );
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only numbers and one decimal point
    final text = newValue.text;
    if (RegExp(r'^[0-9]*[.,]?[0-9]*$').hasMatch(text)) {
      final dotCount = '.'.allMatches(text).length;
      final commaCount = ','.allMatches(text).length;

      if (dotCount + commaCount > 1) {
        return oldValue;
      }
      return newValue;
    }
    return oldValue;
  }
}

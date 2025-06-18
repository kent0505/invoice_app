import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants.dart';

class ClientBillTo extends StatelessWidget {
  const ClientBillTo({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontFamily: AppFonts.w400,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        hintStyle: const TextStyle(
          color: Color(0xff7D81A3),
          fontSize: 12,
          fontFamily: AppFonts.w400,
        ),
        hintText: 'Bill To',
      ),
      onChanged: onChanged,
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}

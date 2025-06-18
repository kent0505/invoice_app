import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants.dart';

class BusinessField extends StatelessWidget {
  const BusinessField({
    super.key,
    required this.title,
    required this.controller,
    this.keyboardType,
    this.onChanged,
  });

  final String title;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.sentences,
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
        ],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: AppFonts.w400,
        ),
        decoration: InputDecoration(
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: AppFonts.w400,
                  ),
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.4,
              color: Color(0xff545456).withValues(alpha: 0.34),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.4,
              color: Color(0xff545456).withValues(alpha: 0.34),
            ),
          ),
          hintStyle: TextStyle(
            color: Color(0xff3C3C43).withValues(alpha: 0.3),
            fontSize: 16,
            fontFamily: AppFonts.w400,
          ),
          hintText: onChanged == null ? 'Optional' : 'Required',
        ),
        onChanged: onChanged,
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}

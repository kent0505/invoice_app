import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class SearchField extends StatelessWidget {
  const SearchField({
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
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: AppFonts.w400,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xff787880).withValues(alpha: 0.12),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: Color(0xff3C3C43).withValues(alpha: 0.6),
        ),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Color(0xff3C3C43).withValues(alpha: 0.6),
          fontSize: 16,
          fontFamily: AppFonts.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: onChanged,
    );
  }
}

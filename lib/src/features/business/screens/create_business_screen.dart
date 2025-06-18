import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../bloc/business_bloc.dart';
import '../models/business.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  static const routePath = '/CreateBusinessScreen';

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  XFile file = XFile('');

  bool active = false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  void checkActive() {
    setState(() {
      active = [
            nameController,
            phoneController,
            emailController,
            addressController,
          ].every((element) => element.text.isNotEmpty) &&
          file.path.isNotEmpty;
    });
  }

  void onAddLogo() async {
    file = await pickImage();
    checkActive();
  }

  void onSignature() {
    // context.push(location);
  }

  void onSave() {
    context.read<BusinessBloc>().add(
          AddBusiness(
            business: Business(
              id: getTimestamp(),
              name: nameController.text,
              phone: phoneController.text,
              email: emailController.text,
              address: addressController.text,
              imageLogo: file.path,
              imageSignature: 'imageSignature',
            ),
          ),
        );
    context.pop();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const Appbar(title: 'Business'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _AddLogo(
                  file: file,
                  onPressed: onAddLogo,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Business Information',
                  style: TextStyle(
                    color: Color(0xff7D81A3),
                    fontSize: 12,
                    fontFamily: AppFonts.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      _Field(
                        title: 'Name',
                        controller: nameController,
                        onChanged: checkActive,
                      ),
                      _Field(
                        title: 'Phone',
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        onChanged: checkActive,
                      ),
                      _Field(
                        title: 'E-Mail',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: checkActive,
                      ),
                      _Field(
                        title: 'Address',
                        controller: addressController,
                        onChanged: checkActive,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'create a signature',
                outlined: true,
                onPressed: onSignature,
              ),
              const SizedBox(height: 8),
              MainButton(
                title: 'Save',
                active: active,
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddLogo extends StatelessWidget {
  const _AddLogo({
    required this.file,
    required this.onPressed,
  });

  final XFile file;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Button(
        onPressed: onPressed,
        child: file.path.isEmpty
            ? const DottedBorder(
                options: RectDottedBorderOptions(
                  dashPattern: [2, 2],
                  strokeWidth: 1,
                  color: Color(0xff8E8E93),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgWidget(Assets.addImage),
                      Text(
                        'Add Logo',
                        style: TextStyle(
                          color: Color(0xff8E8E93),
                          fontSize: 12,
                          fontFamily: AppFonts.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Image.file(
                File(file.path),
                errorBuilder: ImageWidget.errorBuilder,
                frameBuilder: ImageWidget.frameBuilder,
              ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.title,
    required this.controller,
    this.keyboardType,
    required this.onChanged,
  });

  final String title;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final void Function() onChanged;

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
          hintText: 'Optional',
        ),
        onChanged: (_) {
          onChanged();
        },
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}

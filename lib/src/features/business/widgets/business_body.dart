import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/main_button.dart';
import 'business_field.dart';
import 'business_logo.dart';

class BusinessBody extends StatelessWidget {
  const BusinessBody({
    super.key,
    required this.active,
    required this.file,
    required this.nameController,
    required this.businessNameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.vatController,
    required this.bankController,
    required this.ibanController,
    required this.bicController,
    required this.signature,
    required this.onAddLogo,
    required this.onSignature,
    required this.onSave,
    required this.onChanged,
  });

  final bool active;
  final XFile file;
  final TextEditingController nameController;
  final TextEditingController businessNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController vatController;
  final TextEditingController bankController;
  final TextEditingController ibanController;
  final TextEditingController bicController;
  final String signature;
  final VoidCallback onAddLogo;
  final VoidCallback onSignature;
  final VoidCallback onSave;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              BusinessLogo(
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
                    BusinessField(
                      title: 'Name',
                      controller: nameController,
                      onChanged: onChanged,
                    ),
                    BusinessField(
                      title: 'Business name',
                      controller: businessNameController,
                    ),
                    BusinessField(
                      title: 'Phone',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: onChanged,
                    ),
                    BusinessField(
                      title: 'E-Mail',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    BusinessField(
                      title: 'Address',
                      controller: addressController,
                    ),
                  ],
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
                    BusinessField(
                      title: 'VAT No.',
                      controller: vatController,
                    ),
                    BusinessField(
                      title: 'Bank',
                      controller: bankController,
                    ),
                    BusinessField(
                      title: 'IBAN',
                      controller: ibanController,
                    ),
                    BusinessField(
                      title: 'BIC',
                      controller: bicController,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SvgPicture.string(signature),
            ],
          ),
        ),
        MainButtonWrapper(
          children: [
            MainButton(
              title: 'Create a signature',
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
    );
  }
}

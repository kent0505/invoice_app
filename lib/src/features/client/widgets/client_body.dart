import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/main_button.dart';
import '../../business/widgets/business_field.dart';
import 'client_bill_to.dart';
import 'client_import_contact.dart';

class ClientBody extends StatelessWidget {
  const ClientBody({
    super.key,
    required this.active,
    required this.billToController,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.onContact,
    required this.onContinue,
    required this.onChanged,
  });

  final bool active;
  final TextEditingController billToController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final VoidCallback onContact;
  final VoidCallback onContinue;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClientBillTo(controller: billToController),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Contacts',
                  style: TextStyle(
                    color: Color(0xff7D81A3),
                    fontSize: 12,
                    fontFamily: AppFonts.w400,
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
              ClientImportContact(onPressed: onContact),
            ],
          ),
        ),
        MainButtonWrapper(
          children: [
            MainButton(
              title: 'Continue',
              active: active,
              onPressed: onContinue,
            ),
          ],
        ),
      ],
    );
  }
}

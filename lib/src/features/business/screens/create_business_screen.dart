import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/main_button.dart';
import '../bloc/business_bloc.dart';
import '../models/business.dart';
import '../widgets/business_field.dart';
import '../widgets/business_logo.dart';
import 'signature_screen.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  static const routePath = '/CreateBusinessScreen';

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  XFile file = XFile('');
  String? signature = '';
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
      ].every((element) => element.text.isNotEmpty);
    });
  }

  void onAddLogo() async {
    file = await pickImage();
    checkActive();
  }

  void onSignature() async {
    context.push<String?>(SignatureScreen.routePath).then(
      (value) {
        if (value != null) {
          setState(() {
            signature = value;
          });
        }
      },
    );
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
              imageSignature: signature ?? '',
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
                        onChanged: checkActive,
                      ),
                      BusinessField(
                        title: 'Phone',
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        onChanged: checkActive,
                      ),
                      BusinessField(
                        title: 'E-Mail',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: checkActive,
                      ),
                      BusinessField(
                        title: 'Address',
                        controller: addressController,
                        onChanged: checkActive,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SvgPicture.string(signature ?? ''),
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

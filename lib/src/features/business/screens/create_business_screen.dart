import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../bloc/business_bloc.dart';
import '../models/business.dart';
import '../widgets/business_body.dart';
import 'signature_screen.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  static const routePath = '/CreateBusinessScreen';

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  XFile file = XFile('');
  String signature = '';
  bool active = false;

  void checkActive(String _) {
    setState(() {
      active = [
        nameController,
        phoneController,
      ].every((element) => element.text.isNotEmpty);
    });
  }

  void onAddLogo() async {
    file = await pickImage();
    checkActive('');
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
              imageSignature: signature,
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
      body: BusinessBody(
        active: active,
        file: file,
        nameController: nameController,
        phoneController: phoneController,
        emailController: emailController,
        addressController: addressController,
        signature: signature,
        onAddLogo: onAddLogo,
        onSignature: onSignature,
        onSave: onSave,
        onChanged: checkActive,
      ),
    );
  }
}

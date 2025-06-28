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
  final businessNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final vatController = TextEditingController();
  final bankController = TextEditingController();
  final ibanController = TextEditingController();
  final bicController = TextEditingController();

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
    final business = Business(
      id: getTimestamp(),
      name: nameController.text,
      businessName: businessNameController.text,
      phone: phoneController.text,
      email: emailController.text,
      address: addressController.text,
      vat: vatController.text,
      bank: bankController.text,
      iban: ibanController.text,
      bic: bicController.text,
      imageLogo: file.path,
      imageSignature: signature,
    );
    context.read<BusinessBloc>().add(AddBusiness(business: business));
    context.pop();
  }

  @override
  void dispose() {
    nameController.dispose();
    businessNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    vatController.dispose();
    bankController.dispose();
    ibanController.dispose();
    bicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Business'),
      body: BusinessBody(
        active: active,
        file: file,
        nameController: nameController,
        businessNameController: businessNameController,
        phoneController: phoneController,
        emailController: emailController,
        addressController: addressController,
        vatController: vatController,
        bankController: bankController,
        ibanController: ibanController,
        bicController: bicController,
        signature: signature,
        onAddLogo: onAddLogo,
        onSignature: onSignature,
        onSave: onSave,
        onChanged: checkActive,
      ),
    );
  }
}

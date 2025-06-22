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

class EditBusinessScreen extends StatefulWidget {
  const EditBusinessScreen({super.key, required this.business});

  final Business business;

  static const routePath = '/EditBusinessScreen';

  @override
  State<EditBusinessScreen> createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends State<EditBusinessScreen> {
  XFile file = XFile('');
  String signature = '';
  bool active = true;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

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

  void onEdit() {
    final business = widget.business;
    business.name = nameController.text;
    business.phone = phoneController.text;
    business.email = emailController.text;
    business.address = addressController.text;
    business.imageLogo = file.path;
    business.imageSignature = signature;
    context.read<BusinessBloc>().add(EditBusiness(business: business));
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    file = XFile(widget.business.imageLogo);
    signature = widget.business.imageSignature;
    nameController.text = widget.business.name;
    phoneController.text = widget.business.phone;
    emailController.text = widget.business.email;
    addressController.text = widget.business.address;
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
      appBar: Appbar(title: 'Business'),
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
        onSave: onEdit,
        onChanged: checkActive,
      ),
    );
  }
}

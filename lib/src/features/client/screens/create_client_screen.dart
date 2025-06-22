import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../bloc/client_bloc.dart';
import '../models/client.dart';
import '../widgets/client_body.dart';

class CreateClientScreen extends StatefulWidget {
  const CreateClientScreen({super.key});

  static const routePath = '/CreateClientScreen';

  @override
  State<CreateClientScreen> createState() => _CreateClientScreenState();
}

class _CreateClientScreenState extends State<CreateClientScreen> {
  final billToController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  bool active = false;

  void checkActive(String _) {
    setState(() {
      active = [
        billToController,
        nameController,
        phoneController,
      ].every((element) => element.text.isNotEmpty);
    });
  }

  void onContact() async {
    await getContact(context).then((value) {
      nameController.text = value.name;
      phoneController.text = value.phone;
      emailController.text = value.email;
      addressController.text = value.address;
      checkActive('');
    });
  }

  void onContinue() {
    context.read<ClientBloc>().add(
          AddClient(
            client: Client(
              id: getTimestamp(),
              billTo: billToController.text,
              name: nameController.text,
              phone: phoneController.text,
              email: emailController.text,
              address: addressController.text,
            ),
          ),
        );
    context.pop();
  }

  @override
  void dispose() {
    billToController.dispose();
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
      appBar: const Appbar(title: 'New Client'),
      body: ClientBody(
        active: active,
        billToController: billToController,
        nameController: nameController,
        phoneController: phoneController,
        emailController: emailController,
        addressController: addressController,
        onContact: onContact,
        onContinue: onContinue,
        onChanged: checkActive,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/main_button.dart';
import '../../business/widgets/business_field.dart';
import '../bloc/client_bloc.dart';
import '../models/client.dart';
import '../widgets/client_bill_to.dart';
import '../widgets/client_import_contact.dart';

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
      setState(() {
        nameController.text = value.name;
        phoneController.text = value.phone;
        emailController.text = value.email;
        addressController.text = value.address;
      });
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ClientBillTo(
                  controller: billToController,
                  onChanged: checkActive,
                ),
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
      ),
    );
  }
}

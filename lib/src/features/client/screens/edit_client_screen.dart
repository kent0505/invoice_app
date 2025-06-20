import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../business/widgets/business_field.dart';
import '../bloc/client_bloc.dart';
import '../models/client.dart';
import '../widgets/client_bill_to.dart';
import '../widgets/client_import_contact.dart';

class EditClientScreen extends StatefulWidget {
  const EditClientScreen({super.key, required this.client});

  final Client client;

  static const routePath = '/EditClientScreen';

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final billToController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  bool active = true;

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

  void onDelete() {
    DialogWidget.show(
      context,
      title: 'Delete?',
      delete: true,
      onPressed: () {
        context.read<ClientBloc>().add(DeleteClient(client: widget.client));
        context.pop();
        context.pop();
      },
    );
  }

  void onEdit() {
    final client = widget.client;
    client.billTo = billToController.text;
    client.name = nameController.text;
    client.phone = phoneController.text;
    client.email = emailController.text;
    client.address = addressController.text;
    context.read<ClientBloc>().add(EditClient(client: client));
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    billToController.text = widget.client.billTo;
    nameController.text = widget.client.name;
    phoneController.text = widget.client.phone;
    emailController.text = widget.client.email;
    addressController.text = widget.client.address;
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
      appBar: Appbar(
        title: 'Edit Client',
        right: Button(
          onPressed: () {
            DialogWidget.show(
              context,
              title: 'Delete?',
              delete: true,
              onPressed: onDelete,
            );
          },
          child: const SvgWidget(Assets.delete),
        ),
      ),
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
                title: 'Edit',
                active: active,
                onPressed: onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

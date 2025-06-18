import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/main_button.dart';
import '../widgets/invoice_appbar.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  static const routePath = '/CreateInvoiceScreen';

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  void onPreview() {}

  void onDone() {}

  void onDate() {}

  void onCreate() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InvoiceAppbar(
        title: 'New invoice',
        onPreview: onPreview,
        onDone: onDone,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: _Title(title: 'Issued'),
                    ),
                    _Title(title: '#'),
                  ],
                ),
                Row(
                  children: [
                    _Issued(
                      date: DateTime.now(),
                      onPressed: onDate,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _Title(title: 'Business account'),
                //
                const SizedBox(height: 16),
                _Title(title: 'Client'),
                //
                const SizedBox(height: 16),
                _Title(title: 'Items'),
                //
                const SizedBox(height: 16),
                _Title(title: 'Summary'),
                //
                const SizedBox(height: 16),
                _Title(title: 'Photos'),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'Create New Invoice',
                onPressed: onCreate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 6,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff7D81A3),
          fontSize: 12,
          fontFamily: AppFonts.w400,
        ),
      ),
    );
  }
}

class _Issued extends StatelessWidget {
  const _Issued({
    required this.date,
    required this.onPressed,
  });

  final DateTime date;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Button(
            onPressed: () {},
            child: SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '5 May 2025',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: AppFonts.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signature/signature.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/main_button.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  static const routePath = '/SignatureScreen';

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  late SignatureController signatureController;

  bool active = false;

  void onUndo() {
    if (signatureController.canUndo) {
      signatureController.undo();
      setState(() {});
    }
  }

  void onSave() {
    final signature = signatureController.toRawSVG();
    if (signature != null) {
      context.pop(signature);
    }
  }

  @override
  void initState() {
    super.initState();
    signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      onDrawEnd: () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Create a signsature'),
      body: Column(
        children: [
          Container(
            height: 186,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: DottedBorder(
              options: const RectDottedBorderOptions(
                dashPattern: [2, 2],
                strokeWidth: 1,
                color: Color(0xff8E8E93),
              ),
              child: Signature(
                controller: signatureController,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          MainButton(
            title: 'Undo',
            horizontal: 16,
            active: signatureController.canUndo,
            onPressed: onUndo,
          ),
          const SizedBox(height: 16),
          MainButton(
            title: 'Save',
            horizontal: 16,
            active: signatureController.canUndo,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}

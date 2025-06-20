import 'package:flutter/material.dart';

import 'pro_sheet.dart';

class ProScreen extends StatelessWidget {
  const ProScreen({super.key, required this.identifier});

  static const routePath = '/ProScreen';

  final String identifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProSheet(identifier: identifier),
    );
  }
}

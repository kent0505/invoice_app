import 'package:flutter/material.dart';

import 'pro_sheet.dart';

class ProPage extends StatelessWidget {
  const ProPage({super.key, required this.identifier});

  static const routePath = '/ProPage';

  final String identifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProSheet(identifier: identifier),
    );
  }
}

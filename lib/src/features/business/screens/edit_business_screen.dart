import 'package:flutter/material.dart';

import '../../../core/widgets/appbar.dart';
import '../models/business.dart';

class EditBusinessScreen extends StatelessWidget {
  const EditBusinessScreen({super.key, required this.business});

  final Business business;

  static const routePath = '/EditBusinessScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Business'),
      body: Column(
        children: [],
      ),
    );
  }
}

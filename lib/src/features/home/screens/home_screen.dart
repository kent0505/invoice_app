import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../pro/bloc/pro_bloc.dart';
import '../../pro/screens/pro_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routePath = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _paywallShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ProBloc>().state;

      if (!_paywallShown &&
          !state.loading &&
          !state.isPro &&
          state.offering != null &&
          mounted) {
        _paywallShown = true;
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            ProSheet.show(
              context,
              identifier: Identifiers.paywall1,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('HOME'),
        ],
      ),
    );
  }
}

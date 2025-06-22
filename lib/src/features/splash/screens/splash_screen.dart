import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../business/bloc/business_bloc.dart';
import '../../client/bloc/client_bloc.dart';
import '../../home/screens/home_screen.dart';
import '../../invoice/bloc/invoice_bloc.dart';
import '../../item/bloc/item_bloc.dart';
import '../../onboard/data/onboard_repository.dart';
import '../../onboard/screens/onboard_screen.dart';
import '../../pro/bloc/pro_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    context.read<InvoiceBloc>().add(GetInvoices());
    context.read<BusinessBloc>().add(GetBusiness());
    context.read<ClientBloc>().add(GetClients());
    context.read<ItemBloc>().add(GetItems());
    context.read<ProBloc>().add(CheckPro(identifier: Identifiers.paywall1));

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          if (context.read<OnboardRepository>().isOnboard()) {
            context.go(OnboardScreen.routePath);
          } else {
            context.go(
              HomeScreen.routePath,
              extra: false,
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingWidget(),
    );
  }
}

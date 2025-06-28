import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../models/pro.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../bloc/pro_bloc.dart';

class ProSheet extends StatefulWidget {
  const ProSheet({super.key, required this.identifier});

  final String identifier;

  static void show(
    BuildContext context, {
    required String identifier,
  }) {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          return ProSheet(identifier: identifier);
        },
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  State<ProSheet> createState() => _ProSheetState();
}

class _ProSheetState extends State<ProSheet> {
  bool isClosed = false;
  bool visible = false;

  void showInfo(String title) {
    if (!isClosed) {
      isClosed = true;
      context.pop();
    }
    DialogWidget.show(context, title: title);
    context.read<ProBloc>().add(CheckPro(identifier: widget.identifier));
  }

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProBloc>();
    bloc.add(CheckPro(identifier: widget.identifier));
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        visible = true;
      });

      if (mounted) {
        if (bloc.state.offering == null) {
          context.pop();
          DialogWidget.show(context, title: 'Error');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      child: BlocBuilder<ProBloc, Pro>(
        builder: (context, state) {
          if (state.loading || state.offering == null) {
            return const SizedBox();
          }

          return PaywallView(
            offering: state.offering,
            onDismiss: () {
              context.pop();
            },
            onPurchaseCompleted: (customerInfo, storeTransaction) {
              showInfo('Purchase Completed');
            },
            onPurchaseCancelled: () {
              showInfo('Purchase Cancelled');
            },
            onPurchaseError: (e) {
              showInfo('Purchase Error');
            },
            onRestoreCompleted: (customerInfo) {
              showInfo('Restore Completed');
            },
            onRestoreError: (e) {
              showInfo('Restore Error');
            },
          );
        },
      ),
    );
  }
}

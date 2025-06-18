import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../../invoice/bloc/invoice_bloc.dart';
import '../../invoice/screens/create_invoice_screen.dart';
import '../../invoice/widgets/invoice_tile.dart';
import '../../pro/bloc/pro_bloc.dart';
import '../../pro/screens/pro_sheet.dart';
import '../widgets/filter_tab.dart';
import '../widgets/total_income.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routePath = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _paywallShown = false;

  int index = 1;

  List<Color> invoiceColors = const [
    Color(0xFFB1E5AD),
    Color(0xFFE7BDAB),
    Color(0xFFA9ABE5),
    Color(0xFFE2AAE6),
    Color(0xFF8E8E93),
  ];

  void onFilter(int value) {
    setState(() {
      index = value;
    });
  }

  void onCreate() {
    context.push(CreateInvoiceScreen.routePath);
  }

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
        children: [
          const TotalIncome(),
          const SizedBox(height: 26),
          Row(
            children: [
              const SizedBox(width: 16),
              FilterTab(
                index: 1,
                current: index,
                title: 'All',
                onPressed: onFilter,
              ),
              const SizedBox(width: 16),
              FilterTab(
                index: 2,
                current: index,
                title: 'Unpaid',
                onPressed: onFilter,
              ),
              const SizedBox(width: 16),
              FilterTab(
                index: 3,
                current: index,
                title: 'Paid',
                onPressed: onFilter,
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<InvoiceBloc, InvoiceState>(
              builder: (context, state) {
                if (state is InvoicesLoaded) {
                  return state.invoices.isEmpty
                      ? const NoData()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.invoices.length,
                          itemBuilder: (context, index) {
                            return InvoiceTile(
                              invoice: state.invoices[index],
                              circleColor:
                                  invoiceColors[index % invoiceColors.length],
                            );
                          },
                        );
                }

                return const SizedBox();
              },
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'Create Invoice',
                onPressed: onCreate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

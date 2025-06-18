import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../bloc/business_bloc.dart';
import '../widgets/business_tile.dart';
import 'create_business_screen.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  static const routePath = '/BusinessScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Business'),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<BusinessBloc, BusinessState>(
              builder: (context, state) {
                if (state is BusinessLoaded) {
                  return state.businessList.isEmpty
                      ? const NoData()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.businessList.length,
                          itemBuilder: (context, index) {
                            return BusinessTile(
                              business: state.businessList[index],
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
                title: 'Add New',
                onPressed: () {
                  context.push(CreateBusinessScreen.routePath);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/no_data.dart';
import '../bloc/client_bloc.dart';
import '../widgets/client_tile.dart';
import 'create_client_screen.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  static const routePath = '/ClientsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Clients',
        right: Button(
          onPressed: () {
            context.push(CreateClientScreen.routePath);
          },
          child: const Text(
            '+',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: AppFonts.w400,
            ),
          ),
        ),
      ),
      body: BlocBuilder<ClientBloc, ClientState>(
        builder: (context, state) {
          if (state is ClientsLoaded) {
            return state.clients.isEmpty
                ? const NoData()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.clients.length,
                    itemBuilder: (context, index) {
                      return ClientTile(
                        client: state.clients[index],
                      );
                    },
                  );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

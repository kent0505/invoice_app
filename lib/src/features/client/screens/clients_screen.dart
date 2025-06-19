import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/no_data.dart';
import '../../../core/widgets/search_field.dart';
import '../bloc/client_bloc.dart';
import '../widgets/client_tile.dart';
import 'create_client_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  static const routePath = '/ClientsScreen';

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final searchController = TextEditingController();

  void onSearch(String _) {
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchField(
              controller: searchController,
              onChanged: onSearch,
            ),
          ),
          Expanded(
            child: BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                if (state is ClientsLoaded) {
                  final sorted = searchController.text.isEmpty
                      ? state.clients
                      : state.clients.where((client) {
                          return client.name
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase());
                        }).toList();

                  return sorted.isEmpty
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
          ),
        ],
      ),
    );
  }
}

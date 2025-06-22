import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/add_button.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/no_data.dart';
import '../../../core/widgets/search_field.dart';
import '../bloc/client_bloc.dart';
import '../models/client.dart';
import '../widgets/client_tile.dart';
import 'create_client_screen.dart';
import 'edit_client_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key, required this.select});

  final bool select;

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
      resizeToAvoidBottomInset: false,
      appBar: Appbar(
        title: 'Clients',
        right: AddButton(
          onPressed: () {
            context.push(CreateClientScreen.routePath);
          },
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
            child: BlocBuilder<ClientBloc, List<Client>>(
              builder: (context, clients) {
                clients = clients.reversed.toList();
                final sorted = searchController.text.isEmpty
                    ? clients
                    : clients.where((client) {
                        return client.name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase());
                      }).toList();

                return sorted.isEmpty
                    ? const NoData()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: clients.length,
                        itemBuilder: (context, index) {
                          final client = clients[index];

                          return ClientTile(
                            client: client,
                            onPressed: () {
                              widget.select
                                  ? context.pop(client)
                                  : context.push(
                                      EditClientScreen.routePath,
                                      extra: client,
                                    );
                            },
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

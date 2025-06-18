part of 'client_bloc.dart';

@immutable
sealed class ClientEvent {}

final class GetClients extends ClientEvent {}

final class AddClient extends ClientEvent {
  AddClient({required this.client});

  final Client client;
}

final class EditClient extends ClientEvent {
  EditClient({required this.client});

  final Client client;
}

final class DeleteClient extends ClientEvent {
  DeleteClient({required this.client});

  final Client client;
}

part of 'client_bloc.dart';

@immutable
sealed class ClientState {}

final class ClientInitial extends ClientState {}

final class ClientsLoaded extends ClientState {
  ClientsLoaded({required this.clients});

  final List<Client> clients;
}

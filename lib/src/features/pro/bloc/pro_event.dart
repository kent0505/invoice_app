part of 'pro_bloc.dart';

@immutable
sealed class ProEvent {}

final class CheckPro extends ProEvent {
  CheckPro({
    required this.identifier,
    this.initial = false,
  });

  final String identifier;
  final bool initial;
}

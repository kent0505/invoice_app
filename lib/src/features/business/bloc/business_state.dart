part of 'business_bloc.dart';

@immutable
sealed class BusinessState {}

final class BusinessInitial extends BusinessState {}

final class BusinessLoaded extends BusinessState {
  BusinessLoaded({required this.businesses});

  final List<Business> businesses;
}

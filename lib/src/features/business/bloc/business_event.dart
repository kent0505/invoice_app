part of 'business_bloc.dart';

@immutable
sealed class BusinessEvent {}

final class GetBusiness extends BusinessEvent {}

final class AddBusiness extends BusinessEvent {
  AddBusiness({required this.business});

  final Business business;
}

final class EditBusiness extends BusinessEvent {
  EditBusiness({required this.business});

  final Business business;
}

final class DeleteBusiness extends BusinessEvent {
  DeleteBusiness({required this.business});

  final Business business;
}

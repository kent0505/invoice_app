import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/business_repository.dart';
import '../models/business.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final BusinessRepository _repository;

  BusinessBloc({required BusinessRepository repository})
      : _repository = repository,
        super(BusinessInitial()) {
    on<BusinessEvent>(
      (event, emit) => switch (event) {
        GetBusiness() => _getBusiness(event, emit),
        AddBusiness() => _addBusiness(event, emit),
        EditBusiness() => _editBusiness(event, emit),
        DeleteBusiness() => _deleteBusiness(event, emit),
      },
    );
  }

  void _getBusiness(
    GetBusiness event,
    Emitter<BusinessState> emit,
  ) async {
    final businessList = await _repository.getBusiness();
    emit(BusinessLoaded(businessList: businessList));
  }

  void _addBusiness(
    AddBusiness event,
    Emitter<BusinessState> emit,
  ) async {
    await _repository.addBusiness(event.business);
    add(GetBusiness());
  }

  void _editBusiness(
    EditBusiness event,
    Emitter<BusinessState> emit,
  ) async {
    await _repository.editBusiness(event.business);
    add(GetBusiness());
  }

  void _deleteBusiness(
    DeleteBusiness event,
    Emitter<BusinessState> emit,
  ) async {
    await _repository.deleteBusiness(event.business);
    add(GetBusiness());
  }
}

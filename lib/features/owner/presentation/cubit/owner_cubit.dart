import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_apartment_usecase.dart';
import '../../domain/usecases/delete_apartment_usecase.dart';
import '../../domain/usecases/respond_booking_usecase.dart';
import '../../domain/usecases/update_apartment_usecase.dart';
import 'owner_state.dart';

class OwnerCubit extends Cubit<OwnerState> {
  final AddApartmentUseCase addApartmentUseCase;
  final UpdateApartmentUseCase updateApartmentUseCase;
  final DeleteApartmentUseCase deleteApartmentUseCase;
  final RespondBookingUseCase respondBookingUseCase;

  OwnerCubit({
    required this.addApartmentUseCase,
    required this.updateApartmentUseCase,
    required this.deleteApartmentUseCase,
    required this.respondBookingUseCase,
  }) : super(OwnerInitial());

  Future<void> addApartment(AddApartmentParams params) async {
    emit(OwnerLoading());
    final result = await addApartmentUseCase(params);
    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) => emit(const OwnerSuccess("Apartment added successfully")),
    );
  }

  Future<void> updateApartment(UpdateApartmentParams params) async {
    emit(OwnerLoading());
    final result = await updateApartmentUseCase(params);
    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) => emit(const OwnerSuccess("Apartment updated successfully")),
    );
  }

  Future<void> deleteApartment(int id) async {
    emit(OwnerLoading());
    final result = await deleteApartmentUseCase(id);
    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) => emit(const OwnerSuccess("Apartment deleted")),
    );
  }

  Future<void> respondToBooking(int bookingId, bool accept) async {
    emit(OwnerLoading());
    final result = await respondBookingUseCase(
        RespondBookingParams(bookingId: bookingId, accept: accept));
    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) =>
          emit(OwnerSuccess(accept ? "Booking Confirmed" : "Booking Rejected")),
    );
  }
}

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // Import Image Picker

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

  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];

  OwnerCubit({
    required this.addApartmentUseCase,
    required this.updateApartmentUseCase,
    required this.deleteApartmentUseCase,
    required this.respondBookingUseCase,
  }) : super(OwnerInitial());

  void reset() {
    emit(OwnerInitial());
  }

  Future<void> pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      _selectedImages.addAll(pickedFiles.map((e) => File(e.path)));

      emit(OwnerImagesChanged(List.from(_selectedImages)));
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      emit(OwnerImagesChanged(List.from(_selectedImages)));
    }
  }

  void clearImages() {
    _selectedImages.clear();
    emit(OwnerImagesChanged(List.from(_selectedImages)));
  }

  Future<void> addApartment(AddApartmentParams params) async {
    emit(OwnerLoading());

    final finalParams = params.images.isEmpty
        ? AddApartmentParams(
            address: params.address,
            description: params.description,
            governorate: params.governorate,
            price: params.price,
            images: _selectedImages,
            roomCount: params.roomCount,
            title: params.title)
        : params;

    final result = await addApartmentUseCase(finalParams);
    if (state is! OwnerLoading) return;

    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) {
        clearImages();
        emit(const OwnerSuccess("Apartment added successfully"));
      },
    );
  }

  Future<void> updateApartment(UpdateApartmentParams params) async {
    emit(OwnerLoading());

    final finalParams = _selectedImages.isNotEmpty
        ? UpdateApartmentParams(
            apartmentId: params.apartmentId,
            address: params.address,
            description: params.description,
            governorate: params.governorate,
            price: params.price,
            newImages: _selectedImages,
            roomCount: params.roomCount,
            title: params.title)
        : params;

    final result = await updateApartmentUseCase(finalParams);
    if (state is! OwnerLoading) return;

    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) {
        clearImages();
        emit(const OwnerSuccess("Apartment updated successfully"));
      },
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
    if (state is! OwnerLoading) return;

    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) =>
          emit(OwnerSuccess(accept ? "Booking Confirmed" : "Booking Rejected")),
    );
  }
}

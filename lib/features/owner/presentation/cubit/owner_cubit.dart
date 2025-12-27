import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residential_booking_app/core/usecases/usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/get_my_apartments_usecase.dart';
import '../../domain/usecases/add_apartment_usecase.dart';
import '../../domain/usecases/delete_apartment_usecase.dart';
import '../../domain/usecases/get_owner_requests_usecase.dart';
import '../../domain/usecases/respond_booking_usecase.dart';
import '../../domain/usecases/update_apartment_usecase.dart';
import 'owner_state.dart';

class OwnerCubit extends Cubit<OwnerState> {
  final AddApartmentUseCase addApartmentUseCase;
  final UpdateApartmentUseCase updateApartmentUseCase;
  final DeleteApartmentUseCase deleteApartmentUseCase;
  final RespondBookingUseCase respondBookingUseCase;
  final GetOwnerApartmentsUseCase getOwnerApartmentsUseCase;
  final GetOwnerRequestsUseCase getOwnerRequestsUseCase;

  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];

  OwnerCubit({
    required this.addApartmentUseCase,
    required this.updateApartmentUseCase,
    required this.deleteApartmentUseCase,
    required this.respondBookingUseCase,
    required this.getOwnerApartmentsUseCase,
    required this.getOwnerRequestsUseCase,
  }) : super(OwnerInitial());

  // Called by Dashboard Screen
  Future<void> getDashboardData() async {
    emit(OwnerLoading());

    final results = await Future.wait([
      getOwnerApartmentsUseCase(NoParams()),
      getOwnerRequestsUseCase(NoParams()),
    ]);

    final apartmentsResult = results[0];
    final requestsResult = results[1];

    List myApartments = [];
    List requests = [];
    String? errorMessage;

    apartmentsResult.fold(
      (l) => errorMessage = l.message,
      (r) => myApartments = r as List,
    );

    requestsResult.fold(
      (l) {
        // If requests fail but apartments loaded, don't block the UI completely
        // Only set error if EVERYTHING failed
        if (myApartments.isEmpty) errorMessage = l.message;
      },
      (r) => requests = r as List,
    );

    if (errorMessage != null && myApartments.isEmpty && requests.isEmpty) {
      emit(OwnerError(errorMessage!));
    } else {
      emit(OwnerDataLoaded(
        requests: List.from(requests),
        myApartments: List.from(myApartments),
        totalEarnings: 0,
      ));
    }
  }

  // [FIX] New method called by OwnerApartmentsScreen
  Future<void> loadMyApartments() async {
    emit(OwnerLoading());
    final result = await getOwnerApartmentsUseCase(NoParams());

    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (apartments) => emit(OwnerDataLoaded(
          myApartments: apartments, // Only update apartments list
          requests: [],
          totalEarnings: 0)),
    );
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
  }

  Future<void> addApartment(AddApartmentParams params) async {
    emit(OwnerLoading());

    final paramsWithImages = AddApartmentParams(
      title: params.title,
      description: params.description,
      governorate: params.governorate,
      address: params.address,
      price: params.price,
      roomCount: params.roomCount,
      images: List.from(_selectedImages),
    );

    final result = await addApartmentUseCase(paramsWithImages);
    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) {
        clearImages();
        emit(const OwnerSuccess("Property Listed Successfully"));
        // Refresh based on what we are looking at
        loadMyApartments();
      },
    );
  }

  Future<void> updateApartment(UpdateApartmentParams params) async {
    emit(OwnerLoading());

    UpdateApartmentParams finalParams = params;
    if (_selectedImages.isNotEmpty) {
      finalParams = UpdateApartmentParams(
        apartmentId: params.apartmentId,
        title: params.title,
        description: params.description,
        governorate: params.governorate,
        address: params.address,
        price: params.price,
        roomCount: params.roomCount,
        newImages: List.from(_selectedImages),
      );
    }

    final result = await updateApartmentUseCase(finalParams);
    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) {
        clearImages();
        emit(const OwnerSuccess("Property Updated"));
        loadMyApartments();
      },
    );
  }

  Future<void> deleteApartment(int id) async {
    emit(OwnerLoading());
    final result = await deleteApartmentUseCase(id);
    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) {
        emit(const OwnerSuccess("Property Deleted"));
        loadMyApartments();
      },
    );
  }

  Future<void> respondToBooking(int bookingId, bool accept) async {
    emit(OwnerLoading());
    final result = await respondBookingUseCase(
        RespondBookingParams(bookingId: bookingId, accept: accept));
    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) {
        emit(OwnerSuccess(accept ? "Booking Accepted" : "Booking Rejected"));
        getDashboardData();
      },
    );
  }
}

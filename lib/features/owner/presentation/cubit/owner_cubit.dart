import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residential_booking_app/core/usecases/usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/get_my_apartments_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/orce_delete_apartment_usecase.dart';
import '../../domain/usecases/add_apartment_usecase.dart';
import '../../domain/usecases/delete_apartment_usecase.dart';
import '../../domain/usecases/activate_apartment_usecase.dart';
import '../../domain/usecases/get_owner_requests_usecase.dart';
import '../../domain/usecases/get_owner_earnings_usecase.dart';
import '../../domain/usecases/respond_booking_usecase.dart';
import '../../domain/usecases/update_apartment_usecase.dart';
import 'owner_state.dart';

class OwnerCubit extends Cubit<OwnerState> {
  final AddApartmentUseCase addApartmentUseCase;
  final UpdateApartmentUseCase updateApartmentUseCase;
  final DeleteApartmentUseCase deleteApartmentUseCase;
  final ActivateApartmentUseCase activateApartmentUseCase;
  final ForceDeleteApartmentUseCase forceDeleteApartmentUseCase;
  final RespondBookingUseCase respondBookingUseCase;
  final GetOwnerApartmentsUseCase getOwnerApartmentsUseCase;
  final GetOwnerRequestsUseCase getOwnerRequestsUseCase;
  final GetOwnerEarningsUseCase getOwnerEarningsUseCase;

  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];

  OwnerCubit({
    required this.addApartmentUseCase,
    required this.updateApartmentUseCase,
    required this.deleteApartmentUseCase,
    required this.activateApartmentUseCase,
    required this.forceDeleteApartmentUseCase,
    required this.respondBookingUseCase,
    required this.getOwnerApartmentsUseCase,
    required this.getOwnerRequestsUseCase,
    required this.getOwnerEarningsUseCase,
  }) : super(OwnerInitial());

  Future<void> getDashboardData() async {
    emit(OwnerLoading());

    final results = await Future.wait([
      getOwnerApartmentsUseCase(NoParams()),
      getOwnerRequestsUseCase(NoParams()),
      getOwnerEarningsUseCase(NoParams()),
    ]);

    final apartmentsResult = results[0];
    final requestsResult = results[1];
    final earningsResult = results[2];

    List myApartments = [];
    List requests = [];
    double earnings = 0.0;
    String? errorMessage;

    apartmentsResult.fold(
      (l) => errorMessage = l.message,
      (r) => myApartments = r as List,
    );

    requestsResult.fold(
      (l) {
        if (myApartments.isEmpty) errorMessage = l.message;
      },
      (r) => requests = r as List,
    );

    earningsResult.fold(
      (l) {},
      (r) => earnings = r as double,
    );

    if (errorMessage != null && myApartments.isEmpty && requests.isEmpty) {
      emit(OwnerError(errorMessage!));
    } else {
      emit(OwnerDataLoaded(
        requests: List.from(requests),
        myApartments: List.from(myApartments),
        totalEarnings: earnings,
      ));
    }
  }

  Future<void> loadMyApartments() async {
    emit(OwnerLoading());
    final result = await getOwnerApartmentsUseCase(NoParams());

    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (apartments) => emit(OwnerDataLoaded(
        myApartments: apartments,
        requests: [],
        totalEarnings: 0,
      )),
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
        emit(const OwnerSuccess("Property Marked as Unavailable"));
        loadMyApartments();
      },
    );
  }

  Future<void> activateApartment(int id) async {
    emit(OwnerLoading());
    final result = await activateApartmentUseCase(id);
    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) {
        emit(const OwnerSuccess("Apartment is now Available"));
        loadMyApartments();
      },
    );
  }

  Future<void> forceDeleteApartment(int id) async {
    emit(OwnerLoading());
    final result = await forceDeleteApartmentUseCase(id);
    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) {
        emit(const OwnerSuccess("Apartment Permanently Deleted"));
        loadMyApartments();
      },
    );
  }

  Future<void> respondToBooking(int id, bool accept,
      {bool isModification = false}) async {
    emit(OwnerLoading());
    final result = await respondBookingUseCase(RespondBookingParams(
        id: id, accept: accept, isModification: isModification));

    result.fold(
      (failure) => emit(OwnerError(failure.message)),
      (_) {
        emit(OwnerSuccess(accept ? "Accepted" : "Rejected"));
        getDashboardData();
      },
    );
  }
}

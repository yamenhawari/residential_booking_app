import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_booking_app/features/home/domain/usecases/get_aparment_by_id_usecase.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/apartmentDetails/apartment_details_state.dart';

class ApartmentDetailsCubit extends Cubit<ApartmentDetailsState> {
  final GetApartmentBYIdUseCase getApartmentByIdUseCase;

  ApartmentDetailsCubit({required this.getApartmentByIdUseCase})
      : super(ApartmentDetailsInitial());

  Future<void> getDetails(int id) async {
    emit(ApartmentDetailsLoading());
    final result = await getApartmentByIdUseCase(id);
    result.fold(
      (failure) => emit(ApartmentDetailsError(failure.message)),
      (apartment) => emit(ApartmentDetailsLoaded(apartment)),
    );
  }
}

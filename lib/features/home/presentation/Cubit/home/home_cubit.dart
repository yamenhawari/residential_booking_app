import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:residential_booking_app/features/home/domain/entities/filter_apartment_params.dart';
import 'package:residential_booking_app/features/home/domain/usecases/get_apartments_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetApartmentsUseCase getApartmentsUseCase;

  HomeCubit({
    required this.getApartmentsUseCase,
  }) : super(HomeInitial());

  static HomeCubit get(BuildContext context) =>
      BlocProvider.of<HomeCubit>(context);

  Future<void> getApartments({FilterApartmentParams? params}) async {
    emit(HomeLoading());

    final requestParams = params ?? FilterApartmentParams.defaultFeed();

    final result = await getApartmentsUseCase(requestParams);

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (apartments) => emit(HomeLoaded(apartments)),
    );
  }
}

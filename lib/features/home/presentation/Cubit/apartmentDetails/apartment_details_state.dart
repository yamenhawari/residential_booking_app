import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/core/entities/apartment.dart';

class ApartmentDetailsState extends Equatable {
  const ApartmentDetailsState();
  @override
  List<Object?> get props => [];
}

class ApartmentDetailsInitial extends ApartmentDetailsState {}

class ApartmentDetailsLoading extends ApartmentDetailsState {}

class ApartmentDetailsLoaded extends ApartmentDetailsState {
  final Apartment apartment;

  const ApartmentDetailsLoaded(this.apartment);

  @override
  List<Object> get props => [apartment];
}

class ApartmentDetailsError extends ApartmentDetailsState {
  final String message;
  const ApartmentDetailsError(this.message);
  @override
  List<Object> get props => [message];
}

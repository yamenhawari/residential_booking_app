import 'package:equatable/equatable.dart';

import '../../../../../core/entities/apartment.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Apartment> apartments;

  const HomeLoaded(this.apartments);

  @override
  List<Object> get props => [apartments];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailsLoading extends HomeState {}

class ApartmentByIdLoaded extends HomeState {
  final Apartment apartment;

  const ApartmentByIdLoaded(this.apartment);

  @override
  List<Object> get props => [apartment];
}

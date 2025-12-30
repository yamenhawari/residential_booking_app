import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/core/entities/apartment.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Apartment> favorites;
  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

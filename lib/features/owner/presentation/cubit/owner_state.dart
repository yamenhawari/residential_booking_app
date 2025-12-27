import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/core/entities/apartment.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/booking.dart';

abstract class OwnerState extends Equatable {
  const OwnerState();
  @override
  List<Object> get props => [];
}

class OwnerInitial extends OwnerState {}

class OwnerLoading extends OwnerState {}

class OwnerDataLoaded extends OwnerState {
  final List<Booking> requests;
  final List<Apartment> myApartments;
  final double totalEarnings;

  const OwnerDataLoaded({
    this.requests = const [],
    this.myApartments = const [],
    this.totalEarnings = 0.0,
  });

  @override
  List<Object> get props => [requests, myApartments, totalEarnings];
}

class OwnerSuccess extends OwnerState {
  final String message;
  const OwnerSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class OwnerError extends OwnerState {
  final String message;
  const OwnerError(this.message);
  @override
  List<Object> get props => [message];
}

class OwnerImagesChanged extends OwnerState {
  final List<File> images;
  const OwnerImagesChanged(this.images);
  @override
  List<Object> get props => [images];
}

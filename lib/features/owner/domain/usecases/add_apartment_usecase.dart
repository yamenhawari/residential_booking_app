import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/core/enums/governorate_enum.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/owner_repository.dart';

class AddApartmentUseCase implements UseCase<Unit, AddApartmentParams> {
  final OwnerRepository repository;
  AddApartmentUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddApartmentParams params) async {
    return await repository.addApartment(params);
  }
}

class AddApartmentParams extends Equatable {
  final String title;
  final String description;
  final Governorate governorate;
  final String address;
  final double price;
  final int roomCount;
  final List<File> images;

  const AddApartmentParams({
    required this.title,
    required this.description,
    required this.governorate,
    required this.address,
    required this.price,
    required this.roomCount,
    required this.images,
  });

  @override
  List<Object> get props =>
      [title, description, governorate, address, price, roomCount, images];
}

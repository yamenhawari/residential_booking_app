import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/core/enums/governorate_enum.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/owner_repository.dart';

class UpdateApartmentUseCase implements UseCase<Unit, UpdateApartmentParams> {
  final OwnerRepository repository;
  UpdateApartmentUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateApartmentParams params) async {
    return await repository.updateApartment(params);
  }
}

class UpdateApartmentParams extends Equatable {
  final int apartmentId;
  final String? title;
  final String? description;
  final Governorate? governorate;
  final String? area;
  final double? price;
  final int? roomCount;
  final List<File>? newImages;

  const UpdateApartmentParams({
    required this.apartmentId,
    this.title,
    this.description,
    this.governorate,
    this.area,
    this.price,
    this.roomCount,
    this.newImages,
  });

  @override
  List<Object?> get props => [
        apartmentId,
        title,
        description,
        governorate,
        area,
        price,
        roomCount,
        newImages
      ];
}

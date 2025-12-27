import 'package:dartz/dartz.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_consumer.dart';
import '../../domain/usecases/add_apartment_usecase.dart';
import '../../domain/usecases/update_apartment_usecase.dart';
import '../../domain/usecases/respond_booking_usecase.dart';

abstract class OwnerRemoteDataSource {
  Future<Unit> addApartment(AddApartmentParams params);
  Future<Unit> updateApartment(UpdateApartmentParams params);
  Future<Unit> deleteApartment(int apartmentId);
  Future<Unit> respondToBooking(RespondBookingParams params);
}

class OwnerRemoteDataSourceImpl implements OwnerRemoteDataSource {
  final ApiConsumer apiConsumer;

  OwnerRemoteDataSourceImpl({required this.apiConsumer});

  int _mapGovernorateToId(dynamic gov) {
    switch (gov.toString()) {
      case 'Governorate.damascus':
        return 1;
      case 'Governorate.aleppo':
        return 2;
      case 'Governorate.homs':
        return 3;
      case 'Governorate.rifDimashq':
        return 4;
      case 'Governorate.daraa':
        return 5;
      case 'Governorate.latakia':
        return 6;
      case 'Governorate.tartus':
        return 7;
      case 'Governorate.quneitra':
        return 8;
      case 'Governorate.deirEzZor':
        return 9;
      case 'Governorate.hama':
        return 10;
      default:
        return 1;
    }
  }

  @override
  Future<Unit> addApartment(AddApartmentParams params) async {
    final fields = {
      'city_id': "1",
      'title': params.title,
      'description': params.description,
      'address': params.address,
      'governorate_id': _mapGovernorateToId(params.governorate).toString(),
      'price_per_month': params.price.toString(),
      'rooms': params.roomCount.toString(),
    };

    final files = params.images
        .map((image) => FileParam(name: 'images[]', file: image))
        .toList();

    await apiConsumer.postMultipart(
      ApiConstants.apartments,
      fields: fields,
      files: files,
    );

    return unit;
  }

  @override
  Future<Unit> updateApartment(UpdateApartmentParams params) async {
    final fields = <String, String>{};

    if (params.title != null) fields['title'] = params.title!;
    if (params.description != null) fields['description'] = params.description!;
    if (params.governorate != null) {
      fields['governorate_id'] =
          _mapGovernorateToId(params.governorate!).toString();
    }
    if (params.address != null) fields['address'] = params.address!;
    if (params.price != null) {
      fields['price_per_month'] = params.price!.toString();
    }
    if (params.roomCount != null) {
      fields['room_count'] = params.roomCount!.toString();
    }

    final files = <FileParam>[];
    if (params.newImages != null) {
      files.addAll(params.newImages!
          .map((image) => FileParam(name: 'images[]', file: image)));
    }

    await apiConsumer.postMultipart(
      "${ApiConstants.apartments}/${params.apartmentId}",
      fields: fields,
      files: files,
    );

    return unit;
  }

  @override
  Future<Unit> deleteApartment(int apartmentId) async {
    await apiConsumer.delete("${ApiConstants.apartments}/$apartmentId");
    return unit;
  }

  @override
  Future<Unit> respondToBooking(RespondBookingParams params) async {
    final url = params.accept
        ? ApiConstants.confirmBooking(params.bookingId)
        : "${ApiConstants.bookings}/${params.bookingId}/cancel";

    if (params.accept) {
      await apiConsumer.put(url);
    } else {
      await apiConsumer.put(url);
    }

    return unit;
  }
}

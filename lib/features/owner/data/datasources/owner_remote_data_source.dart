import 'package:dartz/dartz.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/models/apartment_model.dart';
import '../../../../features/bookings/data/models/booking_model.dart';
import '../../domain/usecases/add_apartment_usecase.dart';
import '../../domain/usecases/update_apartment_usecase.dart';
import '../../domain/usecases/respond_booking_usecase.dart';

abstract class OwnerRemoteDataSource {
  Future<Unit> addApartment(AddApartmentParams params);
  Future<Unit> updateApartment(UpdateApartmentParams params);
  Future<Unit> deleteApartment(int apartmentId);
  Future<Unit> activateApartment(int apartmentId);
  Future<Unit> forceDeleteApartment(int apartmentId);
  Future<Unit> respondToBooking(RespondBookingParams params);
  Future<List<ApartmentModel>> getMyApartments();
  Future<List<BookingModel>> getOwnerRequests();
  Future<double> getOwnerEarnings();
}

class OwnerRemoteDataSourceImpl implements OwnerRemoteDataSource {
  final ApiConsumer apiConsumer;

  OwnerRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<Unit> addApartment(AddApartmentParams params) async {
    final fields = {
      'city_id': "1",
      'title': params.title,
      'description': params.description,
      'address': params.address,
      'governorate_id': params.governorate.id.toString(),
      'price_per_month': params.price.toString(),
      'room_count': params.roomCount.toString(),
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
    fields['city_id'] = "1";

    if (params.title != null) fields['title'] = params.title!;
    if (params.description != null) fields['description'] = params.description!;
    if (params.governorate != null) {
      fields['governorate_id'] = params.governorate!.id.toString();
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
  Future<Unit> activateApartment(int apartmentId) async {
    await apiConsumer.put(ApiConstants.activateApartment(apartmentId));
    return unit;
  }

  @override
  Future<Unit> forceDeleteApartment(int apartmentId) async {
    await apiConsumer.delete(ApiConstants.forceDeleteApartment(apartmentId));
    return unit;
  }

  @override
  Future<Unit> respondToBooking(RespondBookingParams params) async {
    String url;

    if (params.isModification) {
      if (params.accept) {
        url = ApiConstants.approveUpdate(params.id);
      } else {
        url = ApiConstants.rejectUpdate(params.id);
      }
      await apiConsumer.post(url);
    } else {
      if (params.accept) {
        url = ApiConstants.confirmBooking(params.id);
        await apiConsumer.put(url);
      } else {
        url = ApiConstants.rejectBooking(params.id);
        await apiConsumer.put(url);
      }
    }

    return unit;
  }

  @override
  Future<List<ApartmentModel>> getMyApartments() async {
    final response = await apiConsumer.get(ApiConstants.myApartments);

    if (response is List) {
      return response.map((e) => ApartmentModel.fromJson(e)).toList();
    } else if (response is Map && response.containsKey('data')) {
      return (response['data'] as List)
          .map((e) => ApartmentModel.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  Future<List<BookingModel>> getOwnerRequests() async {
    final response = await apiConsumer.get(ApiConstants.ownerBookingRequests);

    final List dynamicList = (response is Map && response.containsKey('data'))
        ? response['data']
        : (response is List ? response : []);

    return dynamicList.map((e) => BookingModel.fromJson(e)).toList();
  }

  @override
  Future<double> getOwnerEarnings() async {
    try {
      final response = await apiConsumer.get(ApiConstants.ownerEarnings);

      if (response is Map && response.containsKey('data')) {
        final val = response['data'];
        if (val == null) return 0.0;

        return double.tryParse(val.toString()) ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/api/api_constants.dart';
import '../../../../core/datasources/user_local_data_source.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/resources/app_strings.dart';
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
  final http.Client client;
  final UserLocalDataSource userLocalDataSource;

  OwnerRemoteDataSourceImpl(
      {required this.client, required this.userLocalDataSource});

  Future<Map<String, String>> _getHeaders() async {
    final token = await userLocalDataSource.getToken();
    return {
      'Accept': AppStrings.api.accept,
      'Authorization': '${AppStrings.api.bearer} $token',
    };
  }

  @override
  Future<Unit> addApartment(AddApartmentParams params) async {
    final request =
        http.MultipartRequest('POST', Uri.parse(ApiConstants.apartments));
    request.headers.addAll(await _getHeaders());

    request.fields['title'] = params.title;
    request.fields['description'] = params.description;
    request.fields['goovernate'] = params.governorate.name;
    request.fields['address'] = params.address;
    request.fields['price'] = params.price.toString();
    request.fields['room_count'] = params.roomCount.toString();

    for (var image in params.images) {
      if (await image.exists()) {
        request.files
            .add(await http.MultipartFile.fromPath('images[]', image.path));
      }
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return unit;
    } else {
      throw ServerException(AppStrings.error.server);
    }
  }

  @override
  Future<Unit> updateApartment(UpdateApartmentParams params) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse("${ApiConstants.apartments}/${params.apartmentId}"));
    request.headers.addAll(await _getHeaders());

    // request.fields['_method'] = 'PUT'; // Uncomment if backend requires this method spoofing

    if (params.title != null) request.fields['title'] = params.title!;
    if (params.description != null) {
      request.fields['description'] = params.description!;
    }
    if (params.governorate != null) {
      request.fields['goovernate'] = params.governorate!.name;
    }
    if (params.area != null) request.fields['area'] = params.area!;
    if (params.price != null) {
      request.fields['price'] = params.price!.toString();
    }
    if (params.roomCount != null) {
      request.fields['room_count'] = params.roomCount!.toString();
    }

    if (params.newImages != null) {
      for (var image in params.newImages!) {
        if (await image.exists()) {
          request.files
              .add(await http.MultipartFile.fromPath('images[]', image.path));
        }
      }
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      return unit;
    } else {
      throw ServerException(AppStrings.error.server);
    }
  }

  @override
  Future<Unit> deleteApartment(int apartmentId) async {
    final response = await client.delete(
      Uri.parse("${ApiConstants.apartments}/$apartmentId"),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return unit;
    } else {
      throw ServerException(AppStrings.error.server);
    }
  }

  @override
  Future<Unit> respondToBooking(RespondBookingParams params) async {
    final url = params.accept
        ? ApiConstants.confirmBooking(params.bookingId)
        : "${ApiConstants.bookings}/${params.bookingId}/cancel";

    final method = 'PUT';

    final request = http.Request(method, Uri.parse(url));
    request.headers.addAll(await _getHeaders());

    final response = await client.send(request);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return unit;
    } else {
      throw ServerException(AppStrings.error.server);
    }
  }
}

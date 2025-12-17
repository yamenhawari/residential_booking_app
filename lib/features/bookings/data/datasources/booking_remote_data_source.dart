import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:residential_booking_app/features/bookings/domain/entities/add_review_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/modify_booking_usecase.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/datasources/user_local_data_source.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/resources/app_strings.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<Unit> createBooking(CreateBookingParams params);
  Future<List<BookingModel>> getMyBookings();
  Future<Unit> cancelBooking(int bookingId);
  Future<Unit> modifyBooking(ModifyBookingParams params);
  Future<Unit> addReview(ReviewParams params);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final http.Client client;
  final UserLocalDataSource userLocalDataSource;

  BookingRemoteDataSourceImpl({
    required this.client,
    required this.userLocalDataSource,
  });

  Future<Map<String, String>> _headers() async {
    final token = await userLocalDataSource.getToken();
    return {
      'Content-Type': AppStrings.api.contentType,
      'Accept': AppStrings.api.accept,
      'Authorization': '${AppStrings.api.bearer} $token',
    };
  }

  @override
  Future<Unit> createBooking(CreateBookingParams params) async {
    final response = await client.post(
      Uri.parse(ApiConstants.bookings),
      headers: await _headers(),
      body: json.encode({
        'apartment_id': params.apartmentId,
        'start_date': params.startDate.toIso8601String().split('T')[0],
        'end_date': params.endDate.toIso8601String().split('T')[0],
      }),
    );

    return _handleResponse(response);
  }

  @override
  Future<List<BookingModel>> getMyBookings() async {
    final response = await client.get(
      Uri.parse(ApiConstants.myBookings),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      final List data =
          (body is Map && body.containsKey('data')) ? body['data'] : body;

      return data.map((e) => BookingModel.fromJson(e)).toList();
    } else {
      throw ServerException(AppStrings.error.server);
    }
  }

  @override
  Future<Unit> cancelBooking(int bookingId) async {
    final response = await client.post(
      Uri.parse(ApiConstants.cancelBooking(bookingId)),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }

  @override
  Future<Unit> modifyBooking(ModifyBookingParams params) async {
    final response = await client.post(
      Uri.parse(ApiConstants.modifyBooking(params.bookingId)),
      headers: await _headers(),
      body: json.encode({
        'start_date': params.newStartDate.toIso8601String().split('T')[0],
        'end_date': params.newEndDate.toIso8601String().split('T')[0],
      }),
    );
    return _handleResponse(response);
  }

  @override
  Future<Unit> addReview(ReviewParams params) async {
    final response = await client.post(
      Uri.parse(ApiConstants.rateBooking(params.bookingId)),
      headers: await _headers(),
      body: json.encode({
        'rating': params.rating,
        'comment': params.comment,
      }),
    );
    return _handleResponse(response);
  }

  Unit _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return unit;
    } else {
      final body = json.decode(response.body);
      String msg = AppStrings.error.server;

      if (body is Map && body.containsKey('message')) {
        msg = body['message'];
      }

      if (response.statusCode == 422 || response.statusCode == 409) {
        throw ServerException(msg);
      }

      throw ServerException(msg);
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/add_review_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/modify_booking_usecase.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_consumer.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<Unit> createBooking(CreateBookingParams params);
  Future<List<BookingModel>> getMyBookings();
  Future<Unit> cancelBooking(int bookingId);
  Future<Unit> checkoutBooking(int bookingId); // Added
  Future<Unit> modifyBooking(ModifyBookingParams params);
  Future<Unit> addReview(ReviewParams params);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiConsumer apiConsumer;

  BookingRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<Unit> createBooking(CreateBookingParams params) async {
    await apiConsumer.post(
      ApiConstants.bookings,
      body: {
        'apartment_id': params.apartmentId,
        'start_date': params.startDate.toIso8601String().split('T')[0],
        'end_date': params.endDate.toIso8601String().split('T')[0],
      },
    );
    return unit;
  }

  @override
  Future<List<BookingModel>> getMyBookings() async {
    final response = await apiConsumer.get(ApiConstants.myBookings);

    final List dynamicList = (response is Map && response.containsKey('data'))
        ? response['data']
        : response;

    return dynamicList.map((e) => BookingModel.fromJson(e)).toList();
  }

  @override
  Future<Unit> cancelBooking(int bookingId) async {
    await apiConsumer.post(ApiConstants.cancelBooking(bookingId));
    return unit;
  }

  @override
  Future<Unit> checkoutBooking(int bookingId) async {
    await apiConsumer.put(ApiConstants.checkoutBooking(bookingId));
    return unit;
  }

  @override
  Future<Unit> modifyBooking(ModifyBookingParams params) async {
    await apiConsumer.post(
      ApiConstants.modifyBooking(params.bookingId),
      body: {
        'start_date': params.newStartDate.toIso8601String().split('T')[0],
        'end_date': params.newEndDate.toIso8601String().split('T')[0],
      },
    );
    return unit;
  }

  @override
  Future<Unit> addReview(ReviewParams params) async {
    await apiConsumer.post(
      ApiConstants.rateBooking(params.bookingId),
      body: {
        'rating': params.rating,
        'comment': params.comment,
      },
    );
    return unit;
  }
}

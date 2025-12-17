import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/add_review_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';
import '../../domain/usecases/modify_booking_usecase.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetMyBookingsUseCase getMyBookingsUseCase;
  final CreateBookingUseCase createBookingUseCase;
  final CancelBookingUseCase cancelBookingUseCase;
  final ModifyBookingUseCase modifyBookingUseCase;
  final AddReviewUseCase addReviewUseCase;

  BookingCubit({
    required this.addReviewUseCase,
    required this.getMyBookingsUseCase,
    required this.createBookingUseCase,
    required this.cancelBookingUseCase,
    required this.modifyBookingUseCase,
  }) : super(BookingInitial());

  static BookingCubit get(BuildContext context) =>
      BlocProvider.of<BookingCubit>(context);

  Future<void> getBookings() async {
    emit(GetBookingsLoading());
    final result = await getMyBookingsUseCase(NoParams());
    result.fold(
      (failure) => emit(GetBookingsFailure(failure.message)),
      (bookings) => emit(GetBookingsSuccess(bookings)),
    );
  }

  Future<void> createBooking(CreateBookingParams params) async {
    emit(BookingActionLoading());
    final result = await createBookingUseCase(params);
    result.fold(
      (failure) => emit(BookingActionFailure(failure.message)),
      (_) => emit(const BookingActionSuccess("Booking Created Successfully!")),
    );
  }

  Future<void> cancelBooking(int id) async {
    emit(BookingActionLoading());
    final result = await cancelBookingUseCase(id);
    result.fold(
      (failure) => emit(BookingActionFailure(failure.message)),
      (_) {
        emit(const BookingActionSuccess("Booking Cancelled"));
        getBookings();
      },
    );
  }

  Future<void> modifyBooking(ModifyBookingParams params) async {
    emit(BookingActionLoading());
    final result = await modifyBookingUseCase(params);
    result.fold(
      (failure) => emit(BookingActionFailure(failure.message)),
      (_) {
        emit(const BookingActionSuccess("Request Sent"));
        getBookings();
      },
    );
  }

  Future<void> addReview(int bookingId, double rating, String comment) async {
    emit(BookingActionLoading());

    final result = await addReviewUseCase(ReviewParams(
      bookingId: bookingId,
      rating: rating,
      comment: comment,
    ));

    result.fold(
      (failure) => emit(BookingActionFailure(failure.message)),
      (_) {
        emit(const BookingActionSuccess("Review submitted successfully!"));
        getBookings();
      },
    );
  }
}

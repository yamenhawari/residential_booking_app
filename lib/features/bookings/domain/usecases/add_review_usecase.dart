import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class AddReviewUseCase implements UseCase<Unit, ReviewParams> {
  final BookingRepository repository;

  AddReviewUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ReviewParams params) async {
    return await repository.addReview(params);
  }
}

class ReviewParams {
  final int bookingId;
  final double rating;
  final String comment;

  ReviewParams({
    required this.bookingId,
    required this.rating,
    required this.comment,
  });
}

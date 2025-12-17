import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class OfflineFailure extends Failure {
  const OfflineFailure(super.message);
}

class BookingConflictFailure extends Failure {
  const BookingConflictFailure(super.message);
}

class SelfBookingFailure extends Failure {
  const SelfBookingFailure(super.message);
}

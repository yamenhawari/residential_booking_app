import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<Unit, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(
      phoneNumber: params.phoneNumber,
      code: params.code,
    );
  }
}

class VerifyOtpParams extends Equatable {
  final String phoneNumber;
  final String code;

  const VerifyOtpParams({
    required this.phoneNumber,
    required this.code,
  });

  @override
  List<Object> get props => [phoneNumber, code];
}

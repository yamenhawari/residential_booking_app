import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';
import 'package:residential_booking_app/features/bookings/data/datasources/booking_remote_data_source.dart';
import 'package:residential_booking_app/features/bookings/data/repositories/post_repository_impl.dart';
import 'package:residential_booking_app/features/bookings/domain/repositories/booking_repository.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/get_my_bookings_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/modify_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_cubit.dart';
import 'package:residential_booking_app/features/owner/data/datasources/owner_remote_data_source.dart';
import 'package:residential_booking_app/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:residential_booking_app/features/owner/domain/repositories/owner_repository.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/add_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/delete_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/respond_booking_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/update_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';

// Core
import '../datasources/user_local_data_source.dart';
import '../network/network_info.dart';

// Auth Feature
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Home Feature
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_apartments_usecase.dart';
import '../../features/home/presentation/cubit/home/home_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! ---------------- Features: Auth ----------------

  // Bloc
  sl.registerFactory(() => AuthCubit(
        registerUseCase: sl(),
        loginUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      userLocalDataSource: sl(), // Using Shared Core Source
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  //! ---------------- Features: Home ----------------

  // Blocs
  sl.registerFactory(() => HomeCubit(
        getApartmentBYIdUseCase: sl(),
        getApartmentsUseCase: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => GetApartmentsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      client: sl(),
      userLocalDataSource: sl(), // Using Shared Core Source
    ),
  );

  //!-----------------------Features - Bookings-------------------------------
  sl.registerFactory(() => BookingCubit(
        addReviewUseCase: sl(),
        getMyBookingsUseCase: sl(),
        createBookingUseCase: sl(),
        cancelBookingUseCase: sl(),
        modifyBookingUseCase: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));
  sl.registerLazySingleton(() => ModifyBookingUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Source
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(client: sl(), userLocalDataSource: sl()),
  );
  //!-----------------------Features - Owner-------------------------------

  sl.registerFactory(() => OwnerCubit(
        addApartmentUseCase: sl(),
        updateApartmentUseCase: sl(),
        deleteApartmentUseCase: sl(),
        respondBookingUseCase: sl(),
      ));

  sl.registerLazySingleton(() => AddApartmentUseCase(sl()));
  sl.registerLazySingleton(() => UpdateApartmentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteApartmentUseCase(sl()));
  sl.registerLazySingleton(() => RespondBookingUseCase(sl()));

  sl.registerLazySingleton<OwnerRepository>(
    () => OwnerRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<OwnerRemoteDataSource>(
    () => OwnerRemoteDataSourceImpl(client: sl(), userLocalDataSource: sl()),
  );

  //! ---------------- Core ----------------

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // User/Session Local Data Source (Shared)
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(),
  );

  // Navigation Service
  sl.registerLazySingleton<NavigationService>(() => NavigationService());

  //! ---------------- External ----------------
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}

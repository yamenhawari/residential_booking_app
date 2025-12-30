import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:residential_booking_app/core/api/api_consumer.dart';
import 'package:residential_booking_app/core/api/http_api_consumer.dart';
import 'package:residential_booking_app/core/datasources/user_local_data_source.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';
import 'package:residential_booking_app/core/network/network_info.dart';
import 'package:residential_booking_app/core/utils/repository_utils.dart';
import 'package:residential_booking_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:residential_booking_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:residential_booking_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:residential_booking_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:residential_booking_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:residential_booking_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:residential_booking_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:residential_booking_app/features/auth/domain/usecases/update_fcm_token_usecase.dart';
import 'package:residential_booking_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:residential_booking_app/features/bookings/data/datasources/booking_remote_data_source.dart';
import 'package:residential_booking_app/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:residential_booking_app/features/bookings/domain/repositories/booking_repository.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/add_review_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/checkout_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/get_my_bookings_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/modify_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_cubit.dart';
import 'package:residential_booking_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:residential_booking_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:residential_booking_app/features/home/domain/repositories/home_repository.dart';
import 'package:residential_booking_app/features/home/domain/usecases/get_aparment_by_id_usecase.dart';
import 'package:residential_booking_app/features/home/domain/usecases/get_apartments_usecase.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/apartmentDetails/apartment_details_cubit.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/filter/filter_cubit.dart';
import 'package:residential_booking_app/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:residential_booking_app/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:residential_booking_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:residential_booking_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:residential_booking_app/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:residential_booking_app/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:residential_booking_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:residential_booking_app/features/owner/data/datasources/owner_remote_data_source.dart';
import 'package:residential_booking_app/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:residential_booking_app/features/owner/domain/repositories/owner_repository.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/activate_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/add_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/delete_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/get_my_apartments_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/get_owner_earnings_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/get_owner_requests_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/orce_delete_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/respond_booking_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/update_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features

  // ---------------------------------------------------------------------------
  // AUTH FEATURE
  // ---------------------------------------------------------------------------
  // Cubit
  sl.registerFactory(() => AuthCubit(
        registerUseCase: sl(),
        loginUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
        updateFcmTokenUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFcmTokenUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      userLocalDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // ---------------------------------------------------------------------------
  // HOME FEATURE
  // ---------------------------------------------------------------------------
  // Cubits
  sl.registerFactory(() => HomeCubit(
        getApartmentsUseCase: sl(),
      ));
  sl.registerFactory(
    () => ApartmentDetailsCubit(getApartmentByIdUseCase: sl()),
  );
  sl.registerFactory(() => FilterCubit());

  // Use Cases
  sl.registerLazySingleton(() => GetApartmentsUseCase(sl()));
  sl.registerLazySingleton(() => GetApartmentBYIdUseCase(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Source
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // ---------------------------------------------------------------------------
  // BOOKINGS FEATURE
  // ---------------------------------------------------------------------------
  // Cubit
  sl.registerFactory(() => BookingCubit(
      addReviewUseCase: sl(),
      getMyBookingsUseCase: sl(),
      createBookingUseCase: sl(),
      cancelBookingUseCase: sl(),
      modifyBookingUseCase: sl(),
      checkoutBookingUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));
  sl.registerLazySingleton(() => ModifyBookingUseCase(sl()));
  sl.registerLazySingleton(() => AddReviewUseCase(sl()));
  sl.registerLazySingleton(() => CheckoutBookingUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Source
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // ---------------------------------------------------------------------------
  // OWNER FEATURE
  // ---------------------------------------------------------------------------
  // Cubit
  sl.registerFactory(() => OwnerCubit(
        addApartmentUseCase: sl(),
        updateApartmentUseCase: sl(),
        deleteApartmentUseCase: sl(),
        activateApartmentUseCase: sl(),
        forceDeleteApartmentUseCase: sl(),
        respondBookingUseCase: sl(),
        getOwnerApartmentsUseCase: sl(),
        getOwnerRequestsUseCase: sl(),
        getOwnerEarningsUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => AddApartmentUseCase(sl()));
  sl.registerLazySingleton(() => UpdateApartmentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteApartmentUseCase(sl()));
  sl.registerLazySingleton(() => ActivateApartmentUseCase(sl()));
  sl.registerLazySingleton(() => ForceDeleteApartmentUseCase(sl()));
  sl.registerLazySingleton(() => RespondBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetOwnerApartmentsUseCase(sl()));
  sl.registerLazySingleton(() => GetOwnerRequestsUseCase(sl()));
  sl.registerLazySingleton(() => GetOwnerEarningsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<OwnerRepository>(
    () => OwnerRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Source
  sl.registerLazySingleton<OwnerRemoteDataSource>(
    () => OwnerRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // ---------------------------------------------------------------------------
  // NOTIFICATION FEATURE
  // ---------------------------------------------------------------------------
  // Cubit
  sl.registerFactory(() => NotificationCubit(
      getNotificationsUseCase: sl(), markNotificationReadUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUseCase(sl()));

  // Repository
  sl.registerLazySingleton<NotificationRepository>(() =>
      NotificationRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()));

  // Data Source
  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(apiConsumer: sl()));

  // ! Core & External

  // ---------------------------------------------------------------------------
  // CORE UTILS & SERVICES
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<ApiConsumer>(
    () => HttpApiConsumer(
      client: sl(),
      userLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(secureStorage: sl()),
  );

  sl.registerLazySingleton<NavigationService>(() => NavigationService());

  sl.registerLazySingleton<RepositoryUtils>(
    () => RepositoryUtils(sl()),
  );

  // ---------------------------------------------------------------------------
  // EXTERNAL LIBRARIES
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}

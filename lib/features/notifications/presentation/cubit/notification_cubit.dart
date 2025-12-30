import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
  }) : super(NotificationInitial());

  List<NotificationEntity> _allNotifications = [];

  Future<void> getNotifications() async {
    emit(NotificationLoading());
    final result = await getNotificationsUseCase(NoParams());
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (data) {
        _allNotifications = data;
        emit(NotificationLoaded(List.from(_allNotifications)));
      },
    );
  }

  Future<void> markAsRead(int id) async {
    if (state is NotificationLoaded) {
      final updatedList = _allNotifications.where((n) => n.id != id).toList();

      _allNotifications = updatedList;
      emit(NotificationLoaded(List.from(_allNotifications)));
    }

    await markNotificationReadUseCase(id);
  }
}

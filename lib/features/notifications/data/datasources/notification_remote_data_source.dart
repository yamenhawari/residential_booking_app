import 'package:dartz/dartz.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_consumer.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<Unit> markAsRead(int id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiConsumer apiConsumer;
  NotificationRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await apiConsumer.get(ApiConstants.notifications);
    final List data = response['data'];
    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<Unit> markAsRead(int id) async {
    await apiConsumer.put("${ApiConstants.baseUrl}/notifications/$id/read");
    return unit;
  }
}

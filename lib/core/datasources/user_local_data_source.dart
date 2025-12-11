import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../error/exceptions.dart';
import '../models/user_model.dart';
import '../resources/app_constants.dart';

abstract class UserLocalDataSource {
  Future<Unit> saveUser(UserModel user);
  Future<UserModel> getUser();
  Future<String> getToken();
  Future<Unit> deleteUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  Future<Unit> saveUser(UserModel user) async {
    try {
      final box = await Hive.openBox(AppConstants.kUserBox);
      await box.put(AppConstants.kCachedUserKey, json.encode(user.toJson()));
      return unit;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final box = await Hive.openBox(AppConstants.kUserBox);
      final jsonString = box.get(AppConstants.kCachedUserKey);

      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString));
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String> getToken() async {
    try {
      final user = await getUser();
      return user.token;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Unit> deleteUser() async {
    try {
      final box = await Hive.openBox(AppConstants.kUserBox);
      await box.delete(AppConstants.kCachedUserKey);
      return unit;
    } catch (e) {
      throw CacheException();
    }
  }
}

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<Unit> cacheUser(UserModel user);
  Future<Unit> deleteUser();
  Future<String> getCachedToken();
  Future<UserModel> getCachedUser();
}

const String kUserBox = "user_box";
const String kCachedUserKey = "cached_user";

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<Unit> cacheUser(UserModel user) async {
    try {
      final box = await Hive.openBox(kUserBox);
      await box.put(kCachedUserKey, json.encode(user.toJson()));
      return unit;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Unit> deleteUser() async {
    try {
      final box = await Hive.openBox(kUserBox);
      await box.delete(kCachedUserKey);
      return unit;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String> getCachedToken() async {
    try {
      final box = await Hive.openBox(kUserBox);
      final jsonString = box.get(kCachedUserKey);
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return jsonMap['token'];
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<UserModel> getCachedUser() async {
    try {
      final box = await Hive.openBox(kUserBox);
      final jsonString = box.get(kCachedUserKey);
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return UserModel.fromJson(jsonMap);
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }
}

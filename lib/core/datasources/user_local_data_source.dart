import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage secureStorage;
  static const String _kSecureTokenKey = 'auth_token';

  UserLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<Unit> saveUser(UserModel user) async {
    try {
      await secureStorage.write(key: _kSecureTokenKey, value: user.token);
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
      final token = await secureStorage.read(key: _kSecureTokenKey);
      if (token != null && token.isNotEmpty) {
        return token;
      }
      throw CacheException();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Unit> deleteUser() async {
    try {
      await secureStorage.delete(key: _kSecureTokenKey);
      final box = await Hive.openBox(AppConstants.kUserBox);
      await box.delete(AppConstants.kCachedUserKey);
      return unit;
    } catch (e) {
      throw CacheException();
    }
  }
}

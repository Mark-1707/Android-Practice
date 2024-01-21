// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';

import '../../common_export.dart';

class AuthenticationRepository {
  Future<dynamic> logoutUser(String userId) async {
    await Future.delayed(const Duration(seconds: 1));

    FormData formData = FormData.fromMap({
      'userId': userId,
    });
    //final response = await ApiSdk.logoutUser(formData);

    //return response;
  }

// Instance level

  Future<dynamic> loginUser(String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    Map<String, String> body = {
      'phone': phone,
      'password': password,
    };
    final response = await ApiSdk.loginUser(body);
    return response;
  }

  Future<dynamic> signUpUser(
      {required String phone,
      required String password,
      required String email,
      required String name,
      required int dept_id,
      required int user_type,
      required int activation}) async {
    await Future.delayed(const Duration(seconds: 1));
    Map<String, dynamic> body = {
      'phone': phone,
      'password': password,
      'email': email,
      'name': name,
      'dept_id': dept_id,
      'user_type': user_type,
      'activation': activation
    };

    final response = await ApiSdk.signUpUser(body);
    return response;
  }

  Future<dynamic> updatePassword(
      {required String phone,
      required String oldPassword,
      required String newPassword}) async {
    await Future.delayed(const Duration(seconds: 1));
    Map<String, String> body = {
      'phone': phone,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
    final response = await ApiSdk.updatePassword(body);
    return response;
  }
}

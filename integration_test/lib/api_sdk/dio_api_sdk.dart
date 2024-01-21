import 'package:flutter/foundation.dart';
import 'dio/dio_service.dart';

class ApiSdk {
  static loginUser(dynamic body) async {
    final response = await DioService.loginUser(body);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static signUpUser(dynamic body) async {
    final response = await DioService.signUpUser(body);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static updateAddress(dynamic body) async {
    final response = await DioService.updateAddress(body);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static getRailway() async {
    final response = await DioService.getRailway();
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static getZones(int id) async {
    final response = await DioService.getZones(id);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static getDivision(int id) async {
    final response = await DioService.getDivision(id);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static getDepartment(int id) async {
    final response = await DioService.getDepartment(id);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static getEmployeeID(int id) async {
    final response = await DioService.getEmployeeID(id);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static showAddress(int id) async {
    final response = await DioService.showAddress(id);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static updateEmpActivation(int id, dynamic body) async {
    final response = await DioService.updateEmpActivation(id, body);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static showDeptById(int id) async {
    final response = await DioService.showDeptById(id);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static updatePassword(dynamic body) async {
    final response = await DioService.updatePassword(body);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }

  static deleteUser(int id) async {
    final response = await DioService.deleteUser(id);
    if (kDebugMode) {
      print(response);
    }
    return response;
  }
}

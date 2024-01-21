import 'package:integration_test/api_sdk/dio_api_sdk.dart';

class RailwayRepository {
  Future<dynamic> getRailway() async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await ApiSdk.getRailway();
    return response;
  }

  Future<dynamic> getZones(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await ApiSdk.getZones(id);
    return response;
  }

  Future<dynamic> getDivisions(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await ApiSdk.getDivision(id);
    return response;
  }

  Future<dynamic> getDepartments(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await ApiSdk.getDepartment(id);
    return response;
  }

  Future<dynamic> getEmployeeID(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await ApiSdk.getEmployeeID(id);
    return response;
  }

  Future<dynamic> showAddress(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await ApiSdk.showAddress(id);
    return response;
  }

  Future<dynamic> updateEmpActivation(
      {required int id, required int activation}) async {
    await Future.delayed(const Duration(seconds: 1));
    Map<String, dynamic> body = {
      'activation': activation,
    };
    final response = await ApiSdk.updateEmpActivation(id, body);
    return response;
  }

  Future<dynamic> updateAddress({
    required String latitude,
    required String longitude,
    required String time,
    required int eId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    Map<String, String> body = {
      'latitude': latitude,
      'longitude': longitude,
      'time': time,
      'eId': eId.toString(),
    };
    final response = await ApiSdk.updateAddress(body);
    return response;
  }

  Future<dynamic> showDeptById(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await ApiSdk.showDeptById(id);
    return response;
  }

  Future<dynamic> deleteUser(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await ApiSdk.deleteUser(id);
    return response;
  }
}

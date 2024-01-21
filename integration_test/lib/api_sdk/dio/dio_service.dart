import 'package:dio/dio.dart';
import 'dio_helpers/dio_client.dart';
import 'dio_helpers/dio_interceptor.dart';

class DioApi {
  DioApi._internal();

  static final _singleton = DioApi._internal();

  factory DioApi() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      receiveTimeout: const Duration(seconds: 15000),
      connectTimeout: const Duration(seconds: 15000),
      sendTimeout: const Duration(seconds: 15000),
    ));

    dio.interceptors.addAll({
      DioInterceptor(),
    });
    return dio;
  }
}

class DioService {
  static loginUser(dynamic body) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.loginUser(body);
    return response;
  }

  static signUpUser(dynamic body) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.signUpUser(body);
    return response;
  }

  static updateAddress(dynamic body) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.updateAddress(body);
    return response;
  }

  static getRailway() async {
    final client = DioClient(DioApi.createDio());
    final response = await client.getRailway();
    return response;
  }

  static getZones(int id) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.getZones(id);
    return response;
  }

  static getDivision(int id) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.getDivision(id);
    return response;
  }

  static getDepartment(int id) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.getDepeartment(id);
    return response;
  }

  static getEmployeeID(int id) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.getEmployeeID(id);
    return response;
  }

  static showAddress(int id) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.showAddress(id);
    return response;
  }

  static updateEmpActivation(int id, dynamic body) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.updateEmpActivation(id, body);
    return response;
  }

  static showDeptById(int id) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.showDeptById(id);
    return response;
  }

  static updatePassword(dynamic body) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.updatePassword(body);
    return response;
  }

  static deleteUser(int id) async {
    final client = DioClient(DioApi.createDio());
    final response = await client.deleteUser(id);
    return response;
  }
}

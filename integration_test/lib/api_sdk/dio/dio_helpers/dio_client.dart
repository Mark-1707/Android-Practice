import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../config/config.dart';
import 'dio_apis.dart';

part 'dio_client.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class DioClient {
  factory DioClient(Dio dio, {String baseUrl}) = _DioClient;

  // @GET(DioApis.users)
  // Future<dynamic> getUsers(@Path("id") int id);

  @POST(DioApis.login)
  Future<dynamic> loginUser(@Body() dynamic body);

  @POST(DioApis.signUp)
  Future<dynamic> signUpUser(@Body() dynamic body);

  @POST(DioApis.updateAddress)
  Future<dynamic> updateAddress(@Body() dynamic body);

  @GET(DioApis.getRailway)
  Future<dynamic> getRailway();

  @GET(DioApis.getZone)
  Future<dynamic> getZones(@Path("id") int id);

  @GET(DioApis.getDivision)
  Future<dynamic> getDivision(@Path("id") int id);

  @GET(DioApis.getDepartment)
  Future<dynamic> getDepeartment(@Path("id") int id);

  @GET(DioApis.getEmployeeID)
  Future<dynamic> getEmployeeID(@Path("id") int id);

  @GET(DioApis.showAddress)
  Future<dynamic> showAddress(@Path("id") int id);

  @PATCH(DioApis.updateEmpActivation)
  Future<dynamic> updateEmpActivation(@Path("id") int id, @Body() dynamic body);

  @GET(DioApis.showDeptById)
  Future<dynamic> showDeptById(@Path("id") int id);

  @POST(DioApis.updatePassword)
  Future<dynamic> updatePassword(@Body() dynamic body);

  @GET(DioApis.deleteUser)
  Future<dynamic> deleteUser(@Path("id") int id);
  
}

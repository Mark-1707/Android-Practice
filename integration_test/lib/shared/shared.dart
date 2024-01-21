import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._();

  static final SharedPrefs _instance = SharedPrefs._();
  static SharedPrefs get instance => _instance;

  late SharedPreferences _prefs;

  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  Future<void> remove(String key) async => await _prefs.remove(key);

  Future<void> clear() async => await _prefs.clear();

  /// Setters
  Future<bool> setUserId(String value) async =>
      await _prefs.setString('userId', value);
  Future<bool> setUsername(String value) async =>
      await _prefs.setString('name', value);
  Future<bool> setUserphone(String value) async =>
      await _prefs.setString('phone', value);
  Future<bool> setPassword(String value) async =>
      await _prefs.setString('password', value);
  Future<bool> setUseremail(String value) async =>
      await _prefs.setString('email', value);
  Future<bool> setUsertype(String value) async =>
      await _prefs.setString('usertype', value);
  Future<bool> setUserdeptid(String value) async =>
      await _prefs.setString('departid', value);
  Future<bool> setEid(String value) async =>
      await _prefs.setString('eid', value);
  Future<bool> setChechIn(bool value) async =>
      await _prefs.setBool('checkIn', value);
  Future<bool> setGroupCount(int value) async =>
      await _prefs.setInt('groupCount', value);
  Future<bool> setGroupCreatedCount(int value) async =>
      await _prefs.setInt('groupCreatedCount', value);
  Future<bool> setGroupMemberCount(int value) async =>
      await _prefs.setInt('groupMemberCount', value);
  /// Getters
  String? getToken() => _prefs.getString('authtoken');
  String? getUserId() => _prefs.getString('userId');
  String? getrId() => _prefs.getString('rId');
  String? getName() => _prefs.getString('name');
  String? getPhone() => _prefs.getString('phone');
  String? getPassword() => _prefs.getString('password');
  String? getEmail() => _prefs.getString('email');
  String? getUsertype() => _prefs.getString('usertype');
  String? getUserdeptid() => _prefs.getString('departid');
  String? getEid() => _prefs.getString('eid');
  bool? getCheckIn() => _prefs.getBool('checkIn');
  int? getGroupCount() => _prefs.getInt('groupCount');
  int? getGroupCreateCount() => _prefs.getInt('groupCreatedCount');
  int? getGroupMemberCount() => _prefs.getInt('groupMemberCount');
}

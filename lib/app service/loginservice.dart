import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String?> getToken() async {
    String? result = (await _prefs).getString('token');
    return result;
  }

  Future<bool> removeToken() async {
    dynamic result = (await _prefs).remove('token');
    return result;
  }

  Future<bool> setToken(String token) async {
    dynamic result = (await _prefs).setString('token', token);
    return result;
  }
}

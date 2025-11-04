import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usernameKey = 'username';

  // Đăng ký user mới
  Future<bool> register(String phone, String password, String username) async {
    final prefs = await SharedPreferences.getInstance();

    // Kiểm tra xem số điện thoại đã tồn tại chưa
    final existingUser = prefs.getString('user_$phone');
    if (existingUser != null) {
      return false; // Số điện thoại đã tồn tại
    }

    // Lưu thông tin user
    final userData = {
      'phone': phone,
      'password': password,
      'username': username,
    };

    await prefs.setString('user_$phone', json.encode(userData));
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userKey, json.encode(userData));
    await prefs.setString(_usernameKey, username); // LƯU USERNAME RIÊNG

    print('Registered user: $username, phone: $phone'); // Debug
    return true;
  }

  // Đăng nhập
  Future<bool> login(String phone, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_$phone');

    if (userDataString == null) {
      print('User not found for phone: $phone'); // Debug
      return false; // User không tồn tại
    }

    final userData = json.decode(userDataString);
    if (userData['password'] == password) {
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userKey, userDataString);
      await prefs.setString(_usernameKey, userData['username']); // LƯU USERNAME

      print('Login successful for user: ${userData['username']}'); // Debug
      return true;
    }

    print('Wrong password for phone: $phone'); // Debug
    return false; // Sai mật khẩu
  }

  // Đăng xuất
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_userKey);
    // KHÔNG xóa username để lần sau còn hiển thị
    print('User logged out'); // Debug
  }

  // Kiểm tra đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Lấy thông tin user hiện tại
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);

    if (userDataString != null) {
      return json.decode(userDataString);
    }

    return null;
  }

  // Lấy username hiện tại
  Future<String> getCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();

    // Ưu tiên lấy từ key riêng
    final username = prefs.getString(_usernameKey);
    if (username != null && username.isNotEmpty) {
      return username;
    }

    // Fallback: lấy từ user data
    final userDataString = prefs.getString(_userKey);
    if (userDataString != null) {
      final userData = json.decode(userDataString);
      return userData['username'] ?? 'User';
    }

    return 'User'; // Mặc định
  }

  // Kiểm tra số điện thoại đã tồn tại chưa
  Future<bool> isPhoneExists(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_$phone') != null;
  }

  // Debug: in tất cả user data
  Future<void> debugPrintAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    print('=== DEBUG AUTH SERVICE ===');
    for (final key in keys) {
      if (key.startsWith('user_') || key == _userKey || key == _isLoggedInKey || key == _usernameKey) {
        final value = prefs.get(key);
        print('$key: $value');
      }
    }
    print('==========================');
  }
}
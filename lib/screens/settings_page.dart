import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_navigation.dart';
import 'pin_lock_screen.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onLanguageChange;
  final VoidCallback? onLogout;

  const SettingsPage({
    super.key,
    this.onLanguageChange,
    this.onLogout,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isVietnamese = true;
  bool hasPin = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isVietnamese = prefs.getBool('isVietnamese') ?? true;
      hasPin = prefs.getString('app_pin') != null;
    });
  }

  Future<void> _toggleLanguage(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVietnamese', value);
    setState(() => isVietnamese = value);
    widget.onLanguageChange?.call();
  }

  Future<void> _setPin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PinLockScreen(mode: 'set')),
    );
    if (result == true) {
      setState(() => hasPin = true);
    }
  }

  Future<void> _removePin() async {
    final verified = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PinLockScreen(mode: 'remove')),
    );
    if (verified == true) {
      setState(() => hasPin = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isVietnamese ? "Đăng xuất" : "Logout"),
        content: Text(isVietnamese
            ? "Bạn có chắc chắn muốn đăng xuất?"
            : "Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(isVietnamese ? "Hủy" : "Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: Text(
              isVietnamese ? "Đăng xuất" : "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final authService = AuthService();
      await authService.logout();
      widget.onLogout?.call();

      // Fallback nếu onLogout không được cung cấp
      if (widget.onLogout == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage(
            onLoginSuccess: () {
              // Xử lý khi login thành công - quay lại MainNavigation
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainNavigation()),
              );
            },
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isVietnamese ? "Cài đặt" : "Settings",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            title: Text(isVietnamese ? "Ngôn ngữ" : "Language"),
            subtitle: Text(isVietnamese ? "Tiếng Việt" : "English"),
            trailing: Switch(
              value: isVietnamese,
              onChanged: _toggleLanguage,
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(isVietnamese ? "Mã PIN" : "App PIN"),
            subtitle: Text(hasPin
                ? (isVietnamese ? "Đã bật PIN" : "PIN enabled")
                : (isVietnamese ? "Chưa đặt PIN" : "No PIN set")),
            trailing: ElevatedButton(
              onPressed: hasPin ? _removePin : _setPin,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasPin ? Colors.redAccent : Colors.blueAccent,
              ),
              child: Text(
                hasPin
                    ? (isVietnamese ? "Gỡ" : "Remove")
                    : (isVietnamese ? "Đặt PIN" : "Set PIN"),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              isVietnamese ? "Đăng xuất" : "Logout",
              style: TextStyle(color: Colors.redAccent),
            ),
            leading: Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }
}

// Thêm import cho MainNavigation ở đầu file nếu chưa có
// import 'main_navigation.dart';
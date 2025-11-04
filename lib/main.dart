// // // // import 'package:flutter/material.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'screens/main_navigation.dart';
// // // // import 'screens/pin_lock_screen.dart';
// // // // import 'services/notification_service.dart';
// // // //
// // // // Future<void> main() async {
// // // //   WidgetsFlutterBinding.ensureInitialized();
// // // //   // await NotificationService.initialize(); // chỉ thêm đúng dòng này thôi
// // // //   runApp(const MyApp());
// // // // }
// // // //
// // // // class MyApp extends StatelessWidget {
// // // //   const MyApp({super.key});
// // // //
// // // //   Future<bool> _hasPin() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     return prefs.getString('app_pin') != null;
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       debugShowCheckedModeBanner: false,
// // // //       routes: {
// // // //         '/main': (_) => const MainNavigation(),
// // // //       },
// // // //       home: FutureBuilder<bool>(
// // // //         future: _hasPin(),
// // // //         builder: (context, snapshot) {
// // // //           if (!snapshot.hasData) {
// // // //             return const Scaffold(
// // // //               body: Center(child: CircularProgressIndicator()),
// // // //             );
// // // //           }
// // // //           return snapshot.data == true
// // // //               ? const PinLockScreen(mode: 'verify')
// // // //               : const MainNavigation();
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'screens/main_navigation.dart';
// // // import 'screens/pin_lock_screen.dart';
// // // import 'screens/login_page.dart';
// // // import 'services/auth_service.dart';
// // //
// // // Future<void> main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   runApp(const MyApp());
// // // }
// // //
// // // class MyApp extends StatelessWidget {
// // //   const MyApp({super.key});
// // //
// // //   Future<Widget> _getInitialScreen() async {
// // //     final authService = AuthService();
// // //     final prefs = await SharedPreferences.getInstance();
// // //
// // //     // Kiểm tra đăng nhập
// // //     final isLoggedIn = await authService.isLoggedIn();
// // //     final hasPin = prefs.getString('app_pin') != null;
// // //
// // //     print('Debug: isLoggedIn = $isLoggedIn, hasPin = $hasPin');
// // //
// // //     if (!isLoggedIn) {
// // //       return LoginPage(
// // //         onLoginSuccess: () {
// // //           // Xử lý sau khi login thành công
// // //         },
// // //       );
// // //     }
// // //
// // //     if (hasPin) {
// // //       return const PinLockScreen(mode: 'verify');
// // //     }
// // //
// // //     return const MainNavigation();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       debugShowCheckedModeBanner: false,
// // //       home: FutureBuilder<Widget>(
// // //         future: _getInitialScreen(),
// // //         builder: (context, snapshot) {
// // //           if (!snapshot.hasData) {
// // //             return const Scaffold(
// // //               body: Center(child: CircularProgressIndicator()),
// // //             );
// // //           }
// // //           return snapshot.data!;
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'screens/main_navigation.dart';
// // import 'screens/pin_lock_screen.dart';
// // import 'screens/login_page.dart';
// // import 'services/auth_service.dart';
// //
// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: _AppInitializer(),
// //     );
// //   }
// // }
// //
// // class _AppInitializer extends StatefulWidget {
// //   @override
// //   State<_AppInitializer> createState() => _AppInitializerState();
// // }
// //
// // class _AppInitializerState extends State<_AppInitializer> {
// //   Widget _initialScreen = const Scaffold(
// //     body: Center(child: CircularProgressIndicator()),
// //   );
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeApp();
// //   }
// //
// //   Future<void> _initializeApp() async {
// //     final authService = AuthService();
// //     final prefs = await SharedPreferences.getInstance();
// //
// //     final isLoggedIn = await authService.isLoggedIn();
// //     final hasPin = prefs.getString('app_pin') != null;
// //
// //     print('🔄 App init - isLoggedIn: $isLoggedIn, hasPin: $hasPin');
// //
// //     if (!isLoggedIn) {
// //       print('👉 Chuyển đến LoginPage (chưa đăng nhập)');
// //       setState(() {
// //         _initialScreen = LoginPage(
// //           onLoginSuccess: () {
// //             Navigator.of(context).pushAndRemoveUntil(
// //               MaterialPageRoute(builder: (context) => const MainNavigation()),
// //                   (route) => false,
// //             );
// //           },
// //         );
// //       });
// //     } else if (hasPin) {
// //       print('👉 Chuyển đến PinLockScreen (đã login + có PIN)');
// //       setState(() {
// //         _initialScreen = const PinLockScreen(mode: 'verify');
// //       });
// //     } else {
// //       print('👉 Chuyển đến MainNavigation (đã login + không PIN)');
// //       setState(() {
// //         _initialScreen = const MainNavigation();
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return _initialScreen;
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'screens/main_navigation.dart';
// import 'screens/pin_lock_screen.dart';
// import 'screens/login_page.dart';
// import 'services/auth_service.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: _AppInitializer(),
//     );
//   }
// }
//
// class _AppInitializer extends StatefulWidget {
//   @override
//   State<_AppInitializer> createState() => _AppInitializerState();
// }
//
// class _AppInitializerState extends State<_AppInitializer> {
//   Widget _initialScreen = const Scaffold(
//     body: Center(child: CircularProgressIndicator()),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }
//
//   Future<void> _initializeApp() async {
//     final authService = AuthService();
//     final prefs = await SharedPreferences.getInstance();
//
//     final isLoggedIn = await authService.isLoggedIn();
//     final hasPin = prefs.getString('app_pin') != null;
//
//     print('🔄 App init - isLoggedIn: $isLoggedIn, hasPin: $hasPin');
//
//     if (!isLoggedIn) {
//       print('👉 Chuyển đến LoginPage');
//       setState(() {
//         _initialScreen = LoginPage(
//           onLoginSuccess: () {
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(builder: (context) => const MainNavigation()),
//                   (route) => false,
//             );
//           },
//         );
//       });
//     } else if (hasPin) {
//       print('👉 Chuyển đến PinLockScreen');
//       setState(() {
//         _initialScreen = PinLockScreen(
//           mode: 'verify',
//           onSuccess: () {
//             // Khi verify PIN thành công, quay lại MainNavigation đã có data
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(builder: (context) => const MainNavigation()),
//                   (route) => false,
//             );
//           },
//         );
//       });
//     } else {
//       print('👉 Chuyển đến MainNavigation');
//       setState(() {
//         _initialScreen = const MainNavigation();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _initialScreen;
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_navigation.dart';
import 'screens/pin_lock_screen.dart';
import 'screens/login_page.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize(); // ⚡ Khởi tạo thông báo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final authService = AuthService();
    final prefs = await SharedPreferences.getInstance();

    final isLoggedIn = await authService.isLoggedIn();
    final hasPin = prefs.getString('app_pin') != null;

    print('Debug: isLoggedIn = $isLoggedIn, hasPin = $hasPin');

    // Nếu chưa đăng nhập → về LoginPage
    if (!isLoggedIn) {
      return LoginPage(
        onLoginSuccess: () {
          // Sau khi login, chuyển sang MainNavigation
          runApp(const MyApp());
        },
      );
    }

    // Nếu đã đăng nhập → kiểm tra có PIN không
    if (hasPin) {
      return const PinLockScreen(mode: 'verify');
    } else {
      return const MainNavigation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/main': (_) => const MainNavigation(),
      },
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }
}

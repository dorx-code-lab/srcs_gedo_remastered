import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constants/basic.dart';
import 'constants/ui.dart';
import 'services/auth_provider_widget.dart';
import 'services/auth_service.dart';
import 'views/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: AuthService(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: capitalizedAppName,
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 10,
              right: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: standardBorderRadius,
            ),
          ),
          primarySwatch: primaryColor,
        ),
        home: SplashScreenView(),
      ),
    );
  }
}

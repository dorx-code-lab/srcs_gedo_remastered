import 'dart:async';
import 'package:flutter/material.dart';
import 'package:srcs_gedo/constants/images.dart';
import 'package:srcs_gedo/views/home_screen.dart';
import 'package:srcs_gedo/widgets/pulser.dart';
import 'package:srcs_gedo/services/navigation.dart';

import '../services/auth_provider_widget.dart';

class SplashScreenView extends StatefulWidget {
  SplashScreenView({Key key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigationPage() async {
    NavigationService().pushReplacement(
      HomeScreen(),
    );
  }

  startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider.of(context).auth.reloadAccount(context);

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 1,
              ),
              Center(
                child: Pulser(
                  duration: 800,
                  child: Image(
                    width: MediaQuery.of(context).size.width * 0.4,
                    image: AssetImage(
                      srcsLogo,
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

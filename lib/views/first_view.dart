import 'package:flutter/material.dart';
import 'package:srcs_gedo/widgets/single_image.dart';

import '../constants/basic.dart';
import '../constants/images.dart';
import '../constants/ui.dart';
import '../services/ui_services.dart';

class FirstView extends StatelessWidget {
  const FirstView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        width: screenwidth,
        height: screenheight,
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset(
                  creditCard,
                  color: Colors.black.withOpacity(0.7),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: SafeArea(
                child: SingleImage(
                  height: 200,
                  fit: BoxFit.contain,
                  width: 200,
                  image: srcsLogo,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                //height: _screenheight * 0.4,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.grey,
                      ],
                      stops: [
                        0,
                        0.9
                      ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: screenwidth,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            capitalizedAppName,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            ".",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "This is the ultimate app for managing your finances and project expenses. Please sign in to proceed.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: screenheight * 0.03,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 30,
                            right: 30,
                            bottom: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () {
                          UIServices().showLoginSheet(
                            AuthFormType.signIn,
                            (v) {},
                            context,
                          );
                        },
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

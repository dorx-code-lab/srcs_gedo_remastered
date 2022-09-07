import 'package:flutter/material.dart';
import 'package:srcs_gedo/constants/ui.dart';
import 'package:srcs_gedo/services/text_service.dart';

import 'package:srcs_gedo/widgets/custom_divider.dart';
import 'package:srcs_gedo/widgets/top_back_bar.dart';

import '../constants/basic.dart';
import '../constants/images.dart';
import '../widgets/custom_sized_box.dart';

class AboutUs extends StatefulWidget {
  AboutUs({
    Key key,
  }) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BackBar(
              icon: null,
              onPressed: null,
              text: "About $capitalizedAppName",
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  height: 100,
                                  image: AssetImage(
                                    srcsLogo,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        appName.capitalizeFirstOfEach
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor,
                                          fontSize: 25,
                                        ),
                                      ),
                                      Text(
                                        ".",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Version $versionNumber",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      CustomSizedBox(
                        sbSize: SBSize.small,
                        height: true,
                      ),
                      Text(
                        appCatchPhrase,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      CustomSizedBox(
                        sbSize: SBSize.normal,
                        height: true,
                      ),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                          arab,
                        ),
                      ),
                      CustomSizedBox(
                        sbSize: SBSize.normal,
                        height: true,
                      ),
                      CustomDivider(),
                      ListTile(
                        leading: Icon(
                          Icons.info,
                        ),
                        title: Text(
                          "This app was custom designed and built for Mr. Arab",
                        ),
                      ),
                      CustomDivider(),
                      CustomSizedBox(
                        sbSize: SBSize.large,
                        height: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

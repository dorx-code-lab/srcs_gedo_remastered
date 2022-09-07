import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srcs_gedo/constants/constants_used_in_the_ui.dart';
import 'package:srcs_gedo/models/project.dart';
import 'package:srcs_gedo/services/auth_provider_widget.dart';
import 'package:srcs_gedo/services/date_service.dart';
import 'package:srcs_gedo/services/navigation.dart';
import 'package:srcs_gedo/services/ui_services.dart';
import 'package:srcs_gedo/views/about_us_view.dart';
import 'package:srcs_gedo/widgets/custom_dialog_box.dart';
import 'package:srcs_gedo/widgets/custom_divider.dart';
import 'package:srcs_gedo/widgets/headline_text.dart';
import 'package:srcs_gedo/widgets/informational_box.dart';
import 'package:srcs_gedo/widgets/loading_widget.dart';
import 'package:srcs_gedo/widgets/only_when_logged_in.dart';
import 'package:srcs_gedo/widgets/paginate_firestore/paginate_firestore.dart';
import 'package:srcs_gedo/widgets/proceed_button.dart';
import 'package:srcs_gedo/widgets/top_back_bar.dart';

import '../constants/basic.dart';
import '../services/communications.dart';
import '../widgets/single_project.dart';
import 'first_view.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      CommunicationServices().showSnackBar(
        "Press back once more to exit $capitalizedAppName",
        context,
      );
      return Future.value(false);
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return OnlyWhenLoggedIn(
      notSignedIn: FirstView(),
      loadingView: Scaffold(
        body: Center(
          child: LoadingWidget(),
        ),
      ),
      signedInBuilder: (uid) {
        return WillPopScope(
          onWillPop: onWillPop,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  BackBar(
                    actions: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialogBox(
                                bodyText:
                                    "Do you really want to log out? We'll be sad to see you go.",
                                buttonText: "Log out",
                                onButtonTap: () {
                                  AuthProvider.of(context).auth.signOut();
                                },
                                showOtherButton: true,
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.logout,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          NavigationService().push(
                            AboutUs(),
                          );
                        },
                        icon: Icon(
                          Icons.info,
                        ),
                      ),
                    ],
                    icon: null,
                    onPressed: null,
                    showBackButton: false,
                    text: "My Projects",
                  ),
                  Expanded(
                    child: PaginateFirestore(
                      padding: EdgeInsets.only(
                        bottom: 50,
                      ),
                      isLive: true,
                      itemBuilderType: PaginateBuilderType.listView,
                      itemBuilder: (context, snapshot, index) {
                        Project project = Project.fromSnapshot(snapshot[index]);

                        return SingleProject(
                          project: project,
                          projectID: project.id,
                        );
                      },
                      query: FirebaseFirestore.instance
                          .collection(
                            Project.DIRECTORY,
                          )
                          .where(
                            Project.OWNERS,
                            arrayContains: uid,
                          ),
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                UIServices().showDatSheet(
                  AddAProjectBottomSheet(
                    project: null,
                  ),
                  true,
                  context,
                );
              },
              icon: Icon(Icons.add),
              label: Text(
                "Add A Project",
              ),
            ),
          ),
        );
      },
    );
  }
}

class AddAProjectBottomSheet extends StatefulWidget {
  final Project project;
  AddAProjectBottomSheet({
    Key key,
    @required this.project,
  }) : super(key: key);

  @override
  State<AddAProjectBottomSheet> createState() => _AddAProjectBottomSheetState();
}

class _AddAProjectBottomSheetState extends State<AddAProjectBottomSheet> {
  TextEditingController nameController = TextEditingController();
  DateTime dateOfPRoject;
  TextEditingController amountController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool processing = false;
  TextEditingController extraInfoController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  String paymentFrequency = MONTHLY;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      nameController = TextEditingController(text: widget.project.name);
      descController = TextEditingController(text: widget.project.desc);
      amountController =
          TextEditingController(text: widget.project.amountGiven.toString());
      extraInfoController =
          TextEditingController(text: widget.project.extraInfo);
      referenceController =
          TextEditingController(text: widget.project.reference);
      paymentFrequency = widget.project.paymentFrequency;
      dateOfPRoject =
          DateTime.fromMillisecondsSinceEpoch(widget.project.dateOfProject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BackBar(
            icon: null,
            onPressed: null,
            text: "Add A Project",
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.project != null)
                    InformationalBox(
                      visible: true,
                      onClose: null,
                      message:
                          "IMPORTANT: You are currently updating the project \"${widget.project.name}\".\nPlease note that if you edit the given amount, the amount remaining and the amount spent will all be automatically reset.\n\nIncase you received some additional income received for use in the project, you can simply add it as an adding return instead of modifying the project from here.",
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  HeadLineText(
                    onTap: null,
                    plain: true,
                    text: "Provide us with some details about this project",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Name of the project",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: descController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Description of the project",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: referenceController,
                    decoration: InputDecoration(
                      hintText: "Reference",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDivider(),
                  ListTile(
                    onTap: () async {
                      dateOfPRoject = await showDatePicker(
                        context: context,
                        initialDate: dateOfPRoject ?? DateTime.now(),
                        firstDate: DateTime(1800),
                        lastDate: DateTime.now(),
                      );

                      setState(() {});
                    },
                    title: Text(
                      dateOfPRoject != null
                          ? "Date of the project: ${DateService().dateFromMilliseconds(
                              dateOfPRoject.millisecondsSinceEpoch)}"
                          : "Date of the project",
                    ),
                    subtitle: dateOfPRoject != null
                        ? null
                        : Text(
                            "Tap here to select when the project was assigned",
                          ),
                  ),
                  CustomDivider(),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 5,
                    controller: extraInfoController,
                    decoration: InputDecoration(
                      hintText: "Any Additional Information",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Given Amount"),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: amountController,
                    decoration: InputDecoration(
                      hintText: "Amount Given",
                      suffix: Text("USD"),
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
      bottomNavigationBar: Wrap(children: [
        ProceedButton(
          processable: true,
          processing: processing,
          onTap: () {
            if (nameController.text.trim().isEmpty) {
              CommunicationServices().showToast(
                "Please provide a name.",
                Colors.red,
              );
            } else {
              if (descController.text.trim().isEmpty) {
                CommunicationServices().showToast(
                  "Please provide a description.",
                  Colors.red,
                );
              } else {
                if (dateOfPRoject == null) {
                  CommunicationServices().showToast(
                    "Please provide the date of the project.",
                    Colors.red,
                  );
                } else {
                  if (amountController.text.trim().isEmpty) {
                    CommunicationServices().showToast(
                      "Please provide an amount.",
                      Colors.red,
                    );
                  } else {
                    setState(() {
                      processing = true;
                    });

                    if (widget.project != null) {
                      FirebaseFirestore.instance
                          .collection(Project.DIRECTORY)
                          .doc(widget.project.id)
                          .update({
                        Project.ADDITIONALINFO: extraInfoController.text.trim(),
                        if (widget.project.amountGiven !=
                            int.parse(amountController.text.trim()))
                          Project.AMOUNT:
                              int.parse(amountController.text.trim()),
                        if (widget.project.amountGiven !=
                            int.parse(amountController.text.trim()))
                          Project.AMOUNTLEFT:
                              int.parse(amountController.text.trim()),
                        Project.DATEOFPROJECT:
                            dateOfPRoject.millisecondsSinceEpoch,
                        Project.DESCRIPTION: descController.text.trim(),
                        Project.NAME: nameController.text.trim(),
                        Project.OWNERS: [
                          AuthProvider.of(context).auth.getCurrentUID(),
                        ],
                        Project.PAYMENTFREQUENCY: paymentFrequency,
                        Project.REFERENCE: referenceController.text.trim(),
                      }).then(
                        (value) {
                          NavigationService().pop();

                          CommunicationServices().showToast(
                            "Successfully updated the project",
                            Colors.green,
                          );
                        },
                      );
                    } else {
                      FirebaseFirestore.instance
                          .collection(Project.DIRECTORY)
                          .add({
                        Project.ADDITIONALINFO: extraInfoController.text.trim(),
                        Project.AMOUNT: int.parse(amountController.text.trim()),
                        Project.AMOUNTLEFT:
                            int.parse(amountController.text.trim()),
                        Project.DATE: DateTime.now().millisecondsSinceEpoch,
                        Project.DESCRIPTION: descController.text.trim(),
                        Project.DATEOFPROJECT:
                            dateOfPRoject.millisecondsSinceEpoch,
                        Project.NAME: nameController.text.trim(),
                        Project.OWNERS: [
                          AuthProvider.of(context).auth.getCurrentUID(),
                        ],
                        Project.PAYMENTFREQUENCY: paymentFrequency,
                        Project.REFERENCE: referenceController.text.trim(),
                      }).then(
                        (value) {
                          NavigationService().pop();

                          CommunicationServices().showToast(
                            "Successfully added the project",
                            Colors.green,
                          );
                        },
                      );
                    }
                  }
                }
              }
            }
          },
          text: "Proceed",
        )
      ]),
    );
  }
}

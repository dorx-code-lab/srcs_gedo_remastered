import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srcs_gedo/constants/basic.dart';
import 'package:srcs_gedo/constants/ui.dart';
import 'package:srcs_gedo/models/project.dart';
import 'package:srcs_gedo/models/return.dart';
import 'package:srcs_gedo/services/text_service.dart';
import 'package:srcs_gedo/services/ui_services.dart';
import 'package:srcs_gedo/views/home_screen.dart';
import 'package:srcs_gedo/widgets/custom_dialog_box.dart';
import 'package:srcs_gedo/widgets/custom_sliver_app_bar.dart';
import 'package:srcs_gedo/widgets/headline_text.dart';
import 'package:srcs_gedo/widgets/informational_box.dart';
import 'package:srcs_gedo/widgets/loading_widget.dart';
import 'package:srcs_gedo/widgets/paginate_firestore/paginate_firestore.dart';
import 'package:srcs_gedo/widgets/row_selector.dart';
import 'package:srcs_gedo/widgets/single_big_button.dart';
import 'package:srcs_gedo/widgets/top_back_bar.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../services/communications.dart';
import '../services/date_service.dart';
import '../services/firebase_service.dart';
import '../services/navigation.dart';
import '../widgets/custom_divider.dart';
import '../widgets/proceed_button.dart';

class DetailedProjectView extends StatefulWidget {
  final Project project;
  DetailedProjectView({
    Key key,
    @required this.project,
  }) : super(key: key);

  @override
  State<DetailedProjectView> createState() => _DetailedProjectViewState();
}

class _DetailedProjectViewState extends State<DetailedProjectView>
    with TickerProviderStateMixin {
  TabController tabController;
  bool processing = false;

  List modes = [
    "funds / returns",
    "details",
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: modes.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (gh, hj) {
          return [
            CustomSliverAppBar(
              title: widget.project.name,
            ),
            SliverPersistentHeader(
              delegate: MySliverAppBarDelegate(
                TabBar(
                  isScrollable: true,
                  controller: tabController,
                  labelColor: getTabColor(context, true),
                  unselectedLabelColor: getTabColor(context, false),
                  tabs: modes
                      .map(
                        (e) => Tab(
                          text: e.toString().toUpperCase(),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            ProjectReturnsView(
              projectID: widget.project.id,
            ),
            ProjectDetailsView(
              projectID: widget.project.id,
            ),
          ],
        ),
      ),
      floatingActionButton: processing
          ? FloatingActionButton(
              heroTag: "loading",
              onPressed: () {},
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : FloatingActionButton.extended(
              icon: Icon(Icons.add),
              heroTag: "add",
              onPressed: () {
                setState(() {
                  processing = true;
                });

                FirebaseFirestore.instance
                    .collection(Project.DIRECTORY)
                    .doc(widget.project.id)
                    .get()
                    .then(
                  (v) {
                    Project project = Project.fromSnapshot(v);

                    setState(() {
                      processing = false;
                    });

                    UIServices().showDatSheet(
                      AddAReturnBottomSheet(
                        project: project,
                        theReturn: null,
                      ),
                      true,
                      context,
                    );
                  },
                ).timeout(Duration(seconds: 10), onTimeout: () {
                  CommunicationServices().showToast(
                    "Error getting project info. Please check oyur internet connection.",
                    Colors.red,
                  );

                  setState(() {
                    processing = false;
                  });
                });
              },
              label: Text("Add"),
            ),
    );
  }
}

class ProjectDetailsView extends StatefulWidget {
  final String projectID;
  //TODO: Change add to funds and reducing to returns
  ProjectDetailsView({
    Key key,
    @required this.projectID,
  }) : super(key: key);

  @override
  State<ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<ProjectDetailsView> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(Project.DIRECTORY)
          .doc(widget.projectID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        } else {
          Project project = Project.fromSnapshot(snapshot.data);

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  project.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                /* if (project.desc != null)
                  Text(
                    project.desc,
                  ),
                SizedBox(
                  height: 10,
                ),
                if (project.extraInfo != null)
                  Text(
                    project.extraInfo,
                  ),
                if (project.extraInfo != null) */
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Amount Given: ${TextService().putCommas(project.amountGiven.toString())} USD",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "Amount Used: ${TextService().putCommas(project.amountSpent.toString())} USD",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "Amount Left: ${TextService().putCommas(project.amountLeft.toString())} USD",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SingleBigButton(
                        text: "Delete",
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialogBox(
                                  bodyText:
                                      "Do you really want to delete this project?",
                                  buttonText: "DO it",
                                  onButtonTap: () {
                                    FirebaseFirestore.instance
                                        .collection(Project.DIRECTORY)
                                        .doc(widget.projectID)
                                        .delete();
                                  },
                                  showOtherButton: true,
                                );
                              });
                        },
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: SingleBigButton(
                        text: "Edit",
                        onPressed: () {
                          UIServices().showDatSheet(
                            AddAProjectBottomSheet(
                              project: project,
                            ),
                            true,
                            context,
                          );
                        },
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SingleBigButton(
                  color: primaryColor,
                  onPressed: () {
                    CommunicationServices().showToast(
                      "Obtaining project data. Please wait. This may take a few seconds.",
                      Colors.green,
                    );
                    generateReport(
                      project,
                    );
                  },
                  text: "Generate Report",
                  processing: processing,
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          );
        }
      },
    );
  }

  generateReport(
    Project project,
  ) {
    setState(() {
      processing = true;
    });

    FirebaseFirestore.instance
        .collection(Return.DIRECTORY)
        .where(Return.PROJECT, isEqualTo: project.id)
        .get()
        .then((v) async {
      List<Return> returns = [];

      for (var element in v.docs) {
        Return singleReturn = Return.fromSnapshot(element);

        returns.add(singleReturn);
      }

      PdfDocument document = PdfDocument();
      final page1 = document.pages.add();

      page1.graphics.drawString(
        "Project Report for ${project.name}\ngenerated on ${DateService().dateFromMilliseconds(
          DateTime.now().millisecondsSinceEpoch,
        )}\nfrom the $capitalizedAppName app.\n\nThis project was started on\n${DateService().dateFromMilliseconds(
          project.dateOfProject,
        )}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          18,
        ),
      );

      final page2 = document.pages.add();
      PdfGrid grid = PdfGrid();

      grid.style = PdfGridStyle(
        font: PdfStandardFont(
          PdfFontFamily.helvetica,
          15,
        ),
        cellPadding: PdfPaddings(
          left: 5,
          right: 5,
          top: 2,
          bottom: 2,
        ),
      );

      grid.columns.add(
        count: 6,
      );

      grid.headers.add(1);

      PdfGridRow header = grid.headers[0];
      header.cells[0].value = "Date";
      header.cells[1].value = "Title";
      header.cells[2].value = "Description";
      header.cells[3].value = "Amount (USD)";
      header.cells[4].value = "Nature";
      header.cells[5].value = "Reference";

      for (var element in returns) {
        PdfGridRow row = grid.rows.add();
        row.cells[0].value =
            DateService().dateFromMilliseconds(element.dateOfReturn);
        row.cells[1].value = element.name;
        row.cells[2].value = element.description;
        row.cells[3].value = TextService().putCommas(element.amount.toString());
        row.cells[4].value = element.type == "adding" ? "Funds" : "Returns";
        row.cells[5].value = element.reference;
      }

      grid.rows.add();
      grid.rows.add();
      grid.rows.add();

      PdfGridRow spentRow = grid.rows.add();
      spentRow.cells[1].value = "TOTAL GIVEN";
      spentRow.cells[3].value =
          TextService().putCommas(project.amountGiven.toString());

      PdfGridRow row = grid.rows.add();
      row.cells[1].value = "TOTAL SPENT";
      row.cells[3].value =
          TextService().putCommas(project.amountSpent.toString());

      PdfGridRow leftOverrow = grid.rows.add();
      leftOverrow.cells[1].value = "TOTAL LEFTOVER";
      leftOverrow.cells[3].value =
          TextService().putCommas(project.amountLeft.toString());

      grid.draw(
        page: page2,
      );

      List<int> bytes = document.save();
      document.dispose();

      setState(() {
        processing = false;
      });

      StorageServices().saveAndLaunchDocument(
        bytes,
        "${project.name} report on ${DateTime.now()}.pdf",
      );
    }).timeout(Duration(seconds: 20), onTimeout: () {
      setState(() {
        processing = false;
      });

      CommunicationServices().showToast(
        "Error getting returns. Please check your internet connection.",
        Colors.red,
      );
    });
  }
}

class ProjectReturnsView extends StatefulWidget {
  final String projectID;
  ProjectReturnsView({
    Key key,
    @required this.projectID,
  }) : super(key: key);

  @override
  State<ProjectReturnsView> createState() => _ProjectReturnsViewState();
}

class _ProjectReturnsViewState extends State<ProjectReturnsView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PaginateFirestore(
      isLive: true,
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (context, snapshot, index) {
        Return rr = Return.fromSnapshot(snapshot[index]);

        return SingleReturn(
          theReturn: rr,
        );
      },
      query: FirebaseFirestore.instance.collection(Return.DIRECTORY).where(
            Return.PROJECT,
            isEqualTo: widget.projectID,
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SingleReturn extends StatefulWidget {
  final Return theReturn;
  final bool showButtons;
  SingleReturn({
    Key key,
    @required this.theReturn,
    this.showButtons = true,
  }) : super(key: key);

  @override
  State<SingleReturn> createState() => _SingleReturnState();
}

class _SingleReturnState extends State<SingleReturn> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UIServices().showDatSheet(
          ResultDetailsBottomSheet(
            theReturn: widget.theReturn,
          ),
          true,
          context,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5,
        ),
        child: Material(
          elevation: standardElevation,
          borderRadius: standardBorderRadius,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: standardBorderRadius,
              color: (widget.theReturn.type == "adding"
                      ? Colors.green
                      : Colors.red)
                  .withOpacity(0.1),
            ),
            padding: EdgeInsets.only(
              top: 8,
              bottom: 3,
              left: 10,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.theReturn.name,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                if (widget.theReturn.description != null &&
                    widget.theReturn.description.trim().isNotEmpty)
                  Text(
                    widget.theReturn.description,
                    maxLines: widget.showButtons ? 2 : 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(
                  height: 10,
                ),
                if (widget.showButtons)
                  Text(
                    "TAP HERE TO VIEW DETAILS",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                if (widget.showButtons)
                  SizedBox(
                    height: 10,
                  ),
                Text(
                  "${(widget.theReturn.type == "adding" ? "Funds" : "Returns")} amount: ${TextService().putCommas(widget.theReturn.amount.toString())} USD",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (widget.showButtons)
                  Row(
                    children: [
                      Expanded(
                        child: SingleBigButton(
                          color: Colors.red,
                          text: "Delete",
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialogBox(
                                  bodyText:
                                      "Do you really want to delete the return?",
                                  buttonText: "Delete",
                                  onButtonTap: () {
                                    FirebaseFirestore.instance
                                        .collection(Return.DIRECTORY)
                                        .doc(widget.theReturn.id)
                                        .delete();
                                  },
                                  showOtherButton: true,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: SingleBigButton(
                          color: Colors.green,
                          processing: processing,
                          text: "Edit",
                          onPressed: () {
                            setState(() {
                              processing = true;
                            });

                            FirebaseFirestore.instance
                                .collection(Project.DIRECTORY)
                                .doc(widget.theReturn.projectID)
                                .get()
                                .then(
                              (v) {
                                Project project = Project.fromSnapshot(v);

                                setState(() {
                                  processing = false;
                                });

                                UIServices().showDatSheet(
                                  AddAReturnBottomSheet(
                                    project: project,
                                    theReturn: widget.theReturn,
                                  ),
                                  true,
                                  context,
                                );
                              },
                            ).timeout(Duration(seconds: 10), onTimeout: () {
                              CommunicationServices().showToast(
                                "Error getting project info. Please check oyur internet connection.",
                                Colors.red,
                              );

                              setState(() {
                                processing = false;
                              });
                            });
                          },
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddAReturnBottomSheet extends StatefulWidget {
  final Project project;
  final Return theReturn;
  AddAReturnBottomSheet({
    Key key,
    @required this.project,
    @required this.theReturn,
  }) : super(key: key);

  @override
  State<AddAReturnBottomSheet> createState() => _AddAReturnBottomSheetState();
}

class _AddAReturnBottomSheetState extends State<AddAReturnBottomSheet> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool processing = false;
  String mode = "reducing";
  DateTime dateOfPRoject;
  TextEditingController referenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.theReturn != null) {
      nameController = TextEditingController(text: widget.theReturn.name);
      amountController =
          TextEditingController(text: widget.theReturn.amount.toString());
      mode = widget.theReturn.type;
      referenceController =
          TextEditingController(text: widget.theReturn.reference);
      descController =
          TextEditingController(text: widget.theReturn.description);
      dateOfPRoject =
          DateTime.fromMillisecondsSinceEpoch(widget.theReturn.dateOfReturn);
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
            text: "Add A Return",
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadLineText(
                      onTap: null,
                      plain: true,
                      text: "Please enter details about the return",
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Text(
                          "Amount left for use in the project: ${TextService().putCommas(widget.project.amountLeft.toString())} USD"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Name of the return",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Nature of the return",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    InformationalBox(
                      visible: true,
                      onClose: null,
                      message:
                          "NOTE: Select \"Funds\" if you're recording a new deposit and select \"Returns\" if you're recording an expenditure",
                    ),
                    SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          "adding",
                          "reducing",
                        ]
                            .map(
                              (e) => Expanded(
                                child: RowSelector(
                                  onTap: () {
                                    setState(() {
                                      mode = e;
                                    });
                                  },
                                  text: (e == "adding" ? "funds" : "returns")
                                      .toString()
                                      .toUpperCase(),
                                  selected: mode == e,
                                ),
                              ),
                            )
                            .toList(),
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
                            ? "Date of the return / fund: ${DateService().dateFromMilliseconds(dateOfPRoject.millisecondsSinceEpoch)}"
                            : "Date of the return / fund",
                      ),
                      subtitle: dateOfPRoject != null
                          ? null
                          : Text(
                              "Tap here to select when the return / fund happened",
                            ),
                    ),
                    CustomDivider(),
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: "Amount Given",
                              suffix: Text("USD"),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "USD",
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
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
              if (dateOfPRoject == null) {
                CommunicationServices().showToast(
                  "Please provide a date of the return.",
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

                  if (widget.theReturn == null) {
                    FirebaseFirestore.instance
                        .collection(Return.DIRECTORY)
                        .add({
                      Return.AMOUNT: int.parse(amountController.text.trim()),
                      Return.DATE: DateTime.now().millisecondsSinceEpoch,
                      Return.DESCRIPTION: descController.text.trim(),
                      Return.NAME: nameController.text.trim(),
                      Return.NATURE: mode,
                      Return.DATEOFRETURN: dateOfPRoject.millisecondsSinceEpoch,
                      Return.PROJECT: widget.project.id,
                      Return.REFERENCE: referenceController.text.trim(),
                    }).then(
                      (value) {
                        NavigationService().pop();

                        CommunicationServices().showToast(
                          "Successfully added the return",
                          Colors.green,
                        );
                      },
                    );
                  } else {
                    FirebaseFirestore.instance
                        .collection(Return.DIRECTORY)
                        .doc(widget.theReturn.id)
                        .update({
                      Return.AMOUNT: int.parse(amountController.text.trim()),
                      Return.DESCRIPTION: descController.text.trim(),
                      Return.NAME: nameController.text.trim(),
                      Return.NATURE: mode,
                      Return.DATEOFRETURN: dateOfPRoject.millisecondsSinceEpoch,
                      Return.PROJECT: widget.project.id,
                      Return.REFERENCE: referenceController.text.trim(),
                    }).then(
                      (value) {
                        NavigationService().pop();

                        CommunicationServices().showToast(
                          "Successfully updated the return",
                          Colors.green,
                        );
                      },
                    );
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

class ResultDetailsBottomSheet extends StatefulWidget {
  final Return theReturn;
  ResultDetailsBottomSheet({
    Key key,
    @required this.theReturn,
  }) : super(key: key);

  @override
  State<ResultDetailsBottomSheet> createState() =>
      _ResultDetailsBottomSheetState();
}

class _ResultDetailsBottomSheetState extends State<ResultDetailsBottomSheet> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BackBar(
          icon: null,
          onPressed: null,
          text: "Detailed Result",
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SingleReturn(
                  theReturn: widget.theReturn,
                  showButtons: false,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SingleBigButton(
                color: Colors.red,
                text: "Delete",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialogBox(
                        bodyText: "Do you really want to delete the return?",
                        buttonText: "Delete",
                        onButtonTap: () {
                          FirebaseFirestore.instance
                              .collection(Return.DIRECTORY)
                              .doc(widget.theReturn.id)
                              .delete();
                        },
                        showOtherButton: true,
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: SingleBigButton(
                color: Colors.green,
                processing: processing,
                text: "Edit",
                onPressed: () {
                  setState(() {
                    processing = true;
                  });

                  FirebaseFirestore.instance
                      .collection(Project.DIRECTORY)
                      .doc(widget.theReturn.projectID)
                      .get()
                      .then(
                    (v) {
                      Project project = Project.fromSnapshot(v);

                      setState(() {
                        processing = false;
                      });

                      UIServices().showDatSheet(
                        AddAReturnBottomSheet(
                          project: project,
                          theReturn: widget.theReturn,
                        ),
                        true,
                        context,
                      );
                    },
                  ).timeout(Duration(seconds: 10), onTimeout: () {
                    CommunicationServices().showToast(
                      "Error getting project info. Please check oyur internet connection.",
                      Colors.red,
                    );

                    setState(() {
                      processing = false;
                    });
                  });
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

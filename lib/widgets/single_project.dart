import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:srcs_gedo/constants/ui.dart';
import 'package:srcs_gedo/models/project.dart';
import 'package:srcs_gedo/services/navigation.dart';
import 'package:srcs_gedo/services/text_service.dart';
import 'package:srcs_gedo/services/ui_services.dart';
import 'package:srcs_gedo/views/detailed_project_view.dart';
import 'package:srcs_gedo/views/home_screen.dart';
import 'package:srcs_gedo/widgets/custom_dialog_box.dart';

class SingleProject extends StatefulWidget {
  final Project project;
  final String projectID;
  SingleProject({
    Key key,
    @required this.project,
    @required this.projectID,
  }) : super(key: key);

  @override
  State<SingleProject> createState() => _SingleProjectState();
}

class _SingleProjectState extends State<SingleProject> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService().push(
          DetailedProjectView(
            project: widget.project,
          ),
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
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.project.name,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.project.desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "TAP HERE TO VIEW DETAILS",
                  style: TextStyle(
                    fontStyle: FontStyle.italic
                  )
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${TextService().putCommas(widget.project.amountGiven.toString())} USD",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                LinearProgressIndicator(
                  color: widget.project.percentageSpent < 0.5
                      ? Colors.purple
                      : widget.project.percentageSpent < 0.8
                          ? Colors.orange
                          : widget.project.percentageSpent <= 1
                              ? Colors.green
                              : Colors.red,
                  value: widget.project.percentageSpent > 1
                      ? 1
                      : double.parse(widget.project.percentageSpent.toString()),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          UIServices().showDatSheet(
                            AddAProjectBottomSheet(project: widget.project),
                            true,
                            context,
                          );
                        },
                        child: CircleAvatar(
                          child: Icon(
                            Icons.edit,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialogBox(
                                  bodyText:
                                      "Do you really want to delete this project?",
                                  buttonText: "Do It",
                                  onButtonTap: () {
                                    FirebaseFirestore.instance
                                        .collection(Project.DIRECTORY)
                                        .doc(widget.project.id)
                                        .delete();
                                  },
                                  showOtherButton: true,
                                );
                              });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.delete,
                          ),
                        ),
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

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constants_used_in_the_ui.dart';

class Project {
  static const DIRECTORY = "projects";
  static const OWNERS = "owners";
  static const DATE = "date";
  static const NAME = "name";
  static const DATEOFPROJECT = "dateOfProject";
  static const DESCRIPTION = "description";
  static const AMOUNT = "amountGiven";
  static const AMOUNTLEFT = "amountLeft";
  static const REFERENCE = "reference";
  static const PAYMENTFREQUENCY = "paymentFrequency";
  static const ADDITIONALINFO = "additionalInformation";

  String _name;
  String _desc;
  String _reference;
  String _extraInfo;
  String _paymentFrequency;
  List _owners;
  dynamic _percentageSpent;
  int _date;
  int _amountGiven;
  int _dateOfProject;
  int _amountSpent;
  String _id;
  int _amountLeft;

  String get name => _name;
  int get amountSpent => _amountSpent;
  String get id => _id;
  int get dateOfProject => _dateOfProject;
  String get desc => _desc;
  dynamic get percentageSpent => _percentageSpent;
  String get reference => _reference;
  String get extraInfo => _extraInfo;
  String get paymentFrequency => _paymentFrequency;
  List get owners => _owners;
  int get date => _date;
  int get amountGiven => _amountGiven;
  int get amountLeft => _amountLeft;

  Project.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.id;

    Map pp = snapshot.data() as Map;
    _name = pp[NAME] ?? "";
    _desc = pp[DESCRIPTION] ?? "";
    _amountGiven = pp[AMOUNT] ?? 0;
    _amountLeft = pp[AMOUNTLEFT] ?? 0;
    _date = pp[DATE] ?? DateTime.now().millisecondsSinceEpoch;
    _extraInfo = pp[ADDITIONALINFO] ?? "";
    _owners = pp[OWNERS] ?? [];
    _paymentFrequency = pp[PAYMENTFREQUENCY] ?? MONTHLY;

    _amountSpent = _amountGiven - _amountLeft;
    _percentageSpent = _amountSpent / _amountGiven;
    _dateOfProject = pp[DATEOFPROJECT] ?? _date;
  }
}

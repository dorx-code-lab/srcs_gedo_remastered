import 'package:cloud_firestore/cloud_firestore.dart';

class Return {
  static const DIRECTORY = "returns";

  static const PROJECT = "projectID";
  static const AMOUNT = "amount";
  static const REFERENCE = "reference";
  static const NATURE = "nature";
  static const DATE = "date";
  static const NAME = "name";
  static const DATEOFRETURN = "dateOfReturn";
  static const DESCRIPTION = "description";

  String _name;
  String _description;
  int _date;
  String _reference;
  int _dateOfReturn;
  String _type;
  String _id;
  dynamic _amount;
  String _project;

  String get name => _name;
  String get id => _id;
  String get description => _description;
  String get type => _type;
  int get dateOfReturn => _dateOfReturn;
  int get date => _date;
  String get reference => _reference;
  String get projectID => _project;
  dynamic get amount => _amount;

  Return.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.id;

    Map pp = snapshot.data() as Map;
    _name = pp[NAME];
    _project = pp[PROJECT];
    _description = pp[DESCRIPTION];
    _type = pp[NATURE] ?? "adding";
    _amount = pp[AMOUNT];
    _reference = pp[REFERENCE];
    _date = pp[DATE] ?? DateTime.now().millisecondsSinceEpoch;

    _dateOfReturn = pp[DATEOFRETURN];
  }
}

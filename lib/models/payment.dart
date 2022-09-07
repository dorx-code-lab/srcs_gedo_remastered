import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srcs_gedo/constants/constants_used_in_the_ui.dart';

import 'thing_type.dart';

class Payment {
  static const USUALRECEPIENTS = "usualRecepients";
  static const DIRECTORY = "payments";
  static const ACCOUNTBALANCEDIRECTORY = "accountBalances";
  static const WITHDRAWALREQUESTS = "withdrawalRequests";
  static const PLOTITCHARGEDIRECTORY = "chargedPercentage";

  static const PAYMENTSPHONENUMBERS = "paymentPhoneNumbers";
  static const CANCELLATIONFEE = "cancellationFee";

  static const TIME = "time";
  static const AMOUNT = "amount";
  static const THINGID = "thingID";
  static const THINGTYPE = "thingType";
  static const PAYMENTREASON = "paymentReason";
  static const WITHDRAWAL = "withdrawal";
  static const SENDER = "sender";
  static const SENDERTYPE = "senderType";
  static const FLUTTERWAVETRANSACTIONID = "flutterwaveTransactionID";
  static const RECEPIENTTYPE = "recepientType";
  static const RECEPIENT = "recepient";
  static const DEPOSIT = "deposit";
  static const PARTICIPANTS = "participants";
  static const FROMWALLET = "fromWallet";
  static const DECREASESENDER = "decreaseSender";
  static const INCREASERECEPIENT = "increaseRecepient";

  static const RESETFINANCIALYEAR = "resetFinancialYear";
  static const RESETTER = "resetter";

  static const COMMISSION = "commission";
  static const MONEYSOURCE = "moneySource";
  static const PENDING = "pending";
  static const REJECTOR = "rejector";
  static const REJECTED = "rejected";
  static const APPROVER = "approver";
  static const APPROVED = "approved";

  static const PROMOTIONPAYMENT = "promotionPayment";
  static const COMMISSIONPAYMENT = "commissionPayment";
  static const TICKETPURCHASE = "ticketPurchase";

  int _time;
  dynamic _amount;
  String _id;
  String _recepient;
  bool _withdrawal;
  String _thingType;
  String _mode;
  bool _left;
  String _paymentReason;
  List _participants;
  bool _financialYearReset;
  String _partner;
  bool _deposit;
  String _senderType;
  String _sender;
  String _resetter;
  String _partnerType;
  String _recepientType;

  dynamic get amount => _amount;
  String get paymentReason => _paymentReason;
  int get time => _time;
  String get mode => _mode;
  bool get withdrawal => _withdrawal;
  String get id => _id;
  String get resetter => _resetter;
  List get participants => _participants;
  String get senderType => _senderType;
  bool get deposit => _deposit;
  String get thingType => _thingType;
  bool get financialYearReset => _financialYearReset;
  String get sender => _sender;
  String get partnerType => _partnerType;
  String get partner => _partner;
  String get recepientType => _recepientType;
  String get recepient => _recepient;
  bool get left => _left;

  Payment.fromSnapshot(
    DocumentSnapshot snapshot,
    String uid,
  ) {
    Map pp = snapshot.data() as Map;

    _time = pp[TIME];
    _thingType = pp[THINGTYPE];
    _senderType = pp[SENDERTYPE];
    _participants = pp[PARTICIPANTS];
    _paymentReason = pp[PAYMENTREASON];
    _recepientType = pp[RECEPIENTTYPE];
    _sender = pp[SENDER];
    _deposit = pp[DEPOSIT] ?? false;
    _resetter = pp[RESETTER];
    _mode = pp[MONEYSOURCE] ?? CASH;
    _amount = pp[AMOUNT] ?? 0;
    _withdrawal = pp[WITHDRAWAL] ?? false;
    _financialYearReset = pp[RESETFINANCIALYEAR] ?? false;
    _recepient = pp[RECEPIENT];
    _id = snapshot.id;

    if (_thingType == "debit") {
      _left = true;
    } else {
      _left = false;
    }

    String ff;
    for (var element in _participants) {
      if (element != uid) {
        ff = element;
      }
    }

    _partner = ff;

    String mye;
    if (_recepient == uid) {
      mye = _senderType;
    } else {
      mye = _recepientType;
    }

    _partnerType = mye;
  }
}

class UsualRecepients {
  String _id;
  int _date;
  String _type;

  String get id => _id;
  int get date => _date;
  String get type => _type;

  UsualRecepients.fromSnapshot(DocumentSnapshot snapshot) {
    Map pp = snapshot.data() as Map;

    _id = pp[Payment.THINGID];
    _type = pp[Payment.THINGTYPE] ?? ThingType.USER;
  }
}

class WithdrawalRequest {
  int _date;
  dynamic _amount;
  String _id;
  String _recepient;

  String get recepient => _recepient;
  dynamic get amount => _amount;
  String get id => _id;
  int get date => _date;

  WithdrawalRequest.fromSnapshot(DocumentSnapshot snapshot) {
    Map pp = snapshot.data() as Map;

    _recepient = pp[Payment.RECEPIENT];
    _date = pp[Payment.TIME];
    _id = snapshot.id;
    _amount = pp[Payment.AMOUNT];
  }
}

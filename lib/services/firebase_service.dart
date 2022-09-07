import 'dart:io';

import 'package:better_open_file/better_open_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/constants_used_in_the_ui.dart';
import '../models/payment.dart';
import '../models/user.dart';
import 'navigation.dart';

class StorageServices {
  saveAndLaunchDocument(
    List<int> bytes,
    String fileName,
  ) async {
    final path = (await getExternalStorageDirectory()).path;

    final file = File("$path/$fileName");
    await file.writeAsBytes(bytes, flush: true);

    OpenFile.open("$path/$fileName");
  }

  String getEmailLink(
    String email,
    String header,
    String body,
  ) {
    return "mailto:$email?subject=$header&body=$body";
  }

  paySomeone(
    double amount,
    bool withdrawal,
    String sender,
    String recepient,
    String thingID,
    String paymentReason,
    String type,
    String senderType,
    String recepientType,
    bool increaseRecepient,
    bool decreaseSender,
    bool deposit,
    String selectedMode,
    Function(String) after,
  ) {
    FirebaseFirestore.instance.collection(Payment.DIRECTORY).add({
      Payment.AMOUNT: amount,
      Payment.WITHDRAWAL: withdrawal,
      Payment.TIME: DateTime.now().millisecondsSinceEpoch,
      Payment.DEPOSIT: deposit,
      Payment.SENDER: sender,
      Payment.SENDERTYPE: senderType,
      Payment.RECEPIENT: recepient,
      Payment.DECREASESENDER: selectedMode == WALLET,
      Payment.MONEYSOURCE: selectedMode,
      Payment.RECEPIENTTYPE: recepientType,
      Payment.INCREASERECEPIENT: selectedMode != CASH && increaseRecepient,
      Payment.THINGID: thingID,
      Payment.THINGTYPE: type,
      Payment.PAYMENTREASON: paymentReason,
      Payment.PARTICIPANTS: [
        sender,
        recepient,
      ],
    }).then((value) {
      after(value.id);
    });
  }

  handleClick(
    String type,
    String id,
    BuildContext context, {
    String secondaryID,
  }) async {
    NavigationService().push(
      null,
    );
  }

  int getPrice(String priceText, {double deMoney}) {
    int price = deMoney == null
        ? double.parse(priceText.trim()).toInt()
        : deMoney.toInt();

    int pricetoShow = price;

    return pricetoShow;
  }

  updateLastLogin(String uid) {
    FirebaseDatabase.instance
        .ref()
        .child(UserModel.LASTLOGINTIME)
        .child(uid)
        .update({
      DateTime.now().millisecondsSinceEpoch.toString(): true,
    });
  }

  updateLastLogout(String uid) {
    FirebaseDatabase.instance
        .ref()
        .child(UserModel.LASTLOGOUTTIME)
        .child(uid)
        .update({
      DateTime.now().millisecondsSinceEpoch.toString(): true,
    });
  }
}

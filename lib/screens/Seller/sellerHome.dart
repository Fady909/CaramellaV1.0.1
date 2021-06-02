
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/screens/Seller/sellerFillform.dart';
import 'package:flutter_eapp/screens/Seller/sellerVerifyedHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerHome extends StatefulWidget {

  static String id = "SellerHome";

  @override
  _SellerHomeState createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  final FirebaseAuth fireauth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  User loggedSeller;

  String IsNew;
  String Verified = '';
  String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(


        body: IsNew == null ? Center(child: Text('حاول الدخول في وقت آخر ، تقوم الإدارة بتقييم المتجر الخاص بك'),)
            : IsNew == 'No' && Verified == 'No' ? Center(
          child: Text('من فضلك انتظر .. متجرك قيد المراجعه'),)
            : IsNew == 'yes' && Verified == 'No' ? SellerFillForm()
            : IsNew == 'No' && Verified == 'Yes' ? ShowHome()
            : IsNew == 'No' && Verified == 'Blocked' ? Center(child: Text('لقد تم حظرك'),)
            : Text('ٍSomethingWeird Happened')

    );
  }

  @override
  void initState() {
    getData();
  }


  Future<dynamic> getData() async {
    loggedSeller = fireauth.currentUser;
    String UID = loggedSeller.uid;
    String Email = loggedSeller.email;

    final DocumentReference document = Firestore.instance.collection(
        ksellercollection)
        .doc(UID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        IsNew = snapshot.get('IsNew').toString();
        Verified = snapshot.get('Verified').toString();
        userName= snapshot.get('Seller Name').toString();
      });
    });



  }




}
















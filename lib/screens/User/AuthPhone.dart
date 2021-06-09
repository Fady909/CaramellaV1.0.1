import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/screens/User/SubCategoryPage.dart';
import 'package:flutter_eapp/screens/User/UserProfile.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'home.dart';

class AuthPhone extends StatefulWidget {
  static String id = "AuththPhone";

  @override
  _AuthPhoneState createState() => _AuthPhoneState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
User loggeduser = fireauth.currentUser ;
final auth = Auth();



String uID = loggeduser.uid;

final _scaffoldKey = GlobalKey<ScaffoldState>();
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final TextEditingController _phoneNumberController = TextEditingController();
final TextEditingController _smsController = TextEditingController();
String _verificationId;
final SmsAutoFill _autoFill = SmsAutoFill();


class _AuthPhoneState extends State<AuthPhone> {

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
        appBar: AppBar(
          foregroundColor: klight,
          backgroundColor: klight,
          title: Text("Caramella"),
        ),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Padding(padding: const EdgeInsets.all(8),
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    maxLength: 9,
                    obscureText: false,
                    decoration: InputDecoration(
                        prefix: Text("+962"),
                        border: InputBorder.none,
                        labelText: 'رقم الهاتف  (+xx xxx-xxx-xxxx)',
                        fillColor: Color(0xfff3f3f4),
                        filled: true),
                    controller: _phoneNumberController,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: ElevatedButton(child: Text("احصل علي الرقم الحالي"),
                        onPressed: () async => {
                         _phoneNumberController.text = await _autoFill.hint
                        },
                       ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text("تأكيد الرقم"),
                      onPressed: () async {
                        verifyPhoneNumber(context);
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _smsController,
                    decoration: const InputDecoration(labelText: 'رمز التأكيد'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: () async {
                          signInWithPhoneNumber();
                        },
                        child: Text("التأكيد")),
                  ),
                ],
              )
          ),
        )
    );








  }






  Future<void> verifyPhoneNumber( _context) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+962${_phoneNumberController.text}',
          timeout: const Duration(seconds: 100),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$eفشل في أرسال الكود ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kdark,
          textColor: Colors.white,
          fontSize: 16.0);


    }

  }
  PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
  //  showSnackbar('Please check your phone for the verification code.');
    _verificationId = verificationId;

    Fluttertoast.showToast(
        msg: "تم إرسال كود التفعيل",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kdark,
        textColor: Colors.white,
        fontSize: 16.0);



  };

  PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
        print("verification code: " + verificationId);
    _verificationId = verificationId;
  };

  PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
        Fluttertoast.showToast(
            msg: "$authExceptionفشل في التحقق من الكود ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kdark,
            textColor: Colors.white,
            fontSize: 16.0);

      };

  PhoneVerificationCompleted verificationCompleted =
      (PhoneAuthCredential phoneAuthCredential) async {
        final auth = Auth();

        loggeduser = fireauth.currentUser;

        String uID = loggeduser.uid;


        try {
          loggeduser.linkWithCredential(phoneAuthCredential).then((e) =>

          loggeduser.phoneNumber != null ?
          firestore.collection('Users').doc(uID).collection('Userdata')
              .doc(uID)
              .update(
              {

                "phoneverified": "yes",
                'Phone': _phoneNumberController.text
              }

          ).then((value) async =>
          await firestore
              .collection('Sellers')
              .doc(
            '+962${_phoneNumberController.text}'.trim(),
          )
              .update({
            'Phone': '+962${_phoneNumberController.text}'.trim(),
          }))


              : print('not true')

          ).then((value) =>

          Get.to(Home())

          );
        } catch (e) {
          Fluttertoast.showToast(
              msg: " $e   فشل التحقق من الهاتف حاول مرة أخرى ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: kdark,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      };






  Future<void> signInWithPhoneNumber() async {
    final auth = Auth();

    loggeduser = fireauth.currentUser;

    String uID = loggeduser.uid;


    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,);

 loggeduser.linkWithCredential(credential).whenComplete(() =>

 loggeduser.phoneNumber != null ?
 firestore.collection('Users').doc(uID).collection('Userdata')
     .doc(uID)
     .update(
     {

       "phoneverified": "yes",
           'Phone' : _phoneNumberController.text
     }

 ).then((value) async =>  await firestore
     .collection('Sellers')
     .doc(
   '+962${_phoneNumberController.text}'.trim(),
 )
     .update({
   'Phone': '+962${_phoneNumberController.text}'.trim(),
 }))








     : print('not true')

 ).whenComplete(() =>

 Navigator.pushReplacementNamed(this.context, UserInfo1.id)
 );





    } catch (e) {
      Fluttertoast.showToast(
          msg: " $e   فشل التحقق من الهاتف حاول مرة أخرى ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kdark,
          textColor: Colors.white,
          fontSize: 16.0);    }
  }



  }


import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/Provider/modelhut.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'home.dart';
import 'loginsccreen.dart';

class Signupscreen extends StatefulWidget {
  static String id = 'signupscreen';
  final auth = Auth();
  final store = Store();
  User firebaseUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  _SignupscreenState createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  var email = TextEditingController();
  var password = TextEditingController();
  var username = TextEditingController();
  var phone = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;
  final SmsAutoFill _autoFill = SmsAutoFill();

  var verifycode;

  String ava;

  get auth => widget.auth;

  get firebaseUser => widget.firebaseUser;

  get firestore => FirebaseFirestore.instance;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('رجوع',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false, controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(

            obscureText: isPassword,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            controller: controller,
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [klight, kdark])),
      child: GestureDetector(
        onTap: () {
          VerifyAlert(context, "تأكيد الهويه", "ادخل كود التفعيل", phone);
        },
        child: Text(
          'التسجيل الان',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'تسجيل الدخول',
              style: TextStyle(
                  color: kdark, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'لديك حساب بالقعل ؟',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Ca',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: kdark,
            ),
            children: [
              TextSpan(
                text: 'ram',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              TextSpan(
                text: 'ella',
                style: TextStyle(color: kdark, fontSize: 30),
              ),
            ]),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("اسم المستخدم", isPassword: false, controller: username),
         Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
    Text(
    "رقم الهاتف",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    ),
    SizedBox(
    height: 10,
    ),
    TextField(
      keyboardType: TextInputType.phone,
      maxLength: 15,
    obscureText: false,
    decoration: InputDecoration(
    prefix: Text("+2"),
    border: InputBorder.none,
    fillColor: Color(0xfff3f3f4),
    filled: true),
    controller: phone,
    )
    ],
    ),
    ),
    Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[



      Text(
    "البريد الألكتروني",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    ),
    SizedBox(
    height: 10,
    ),
    TextFormField(
      validator: (value) => EmailValidator.validate(value) ? sendverifyemail(email) :"أدخل إيميل صالح",
      decoration: InputDecoration(
    border: InputBorder.none,
    fillColor: Color(0xfff3f3f4),
    filled: true),
    controller: email,
    )
    ],
    ),
    ),
        _entryField("كلمه السر", isPassword: true, controller: password),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(
        strokeWidth: 0.5,
      ),
      inAsyncCall: Provider.of<Modelhut>(context).isLoading,
      child: Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(
                        height: 50,
                      ),
                      _emailPasswordWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      _submitButton(),
                      SizedBox(height: height * .14),
                      _loginAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    print(ava);
  }

  void signup() async {
    final model = Provider.of<Modelhut>(context, listen: false);

    model.changeisLoading(true);

    User firebaseUser;

    if (password.text.isEmpty ||
        email.text.isEmpty ||
        username.text.isEmpty ||
        phone.text.isEmpty) {
      model.changeisLoading(false);

      Fluttertoast.showToast(
          msg: "من فضلك اكمل كل الحقول الفارغه",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kdark,
          textColor: Colors.white,
          fontSize: 16.0);
    } else
      try {
        final AuthResult = await auth
            .signUp(email.text.trim(), password.text.trim())
            .then((auth) =>
        firebaseUser = auth.user



        );


        if (firebaseUser != null) {
          await firestore
              .collection('Users')
              .doc(firebaseUser.uid)
              .collection('Userdata')
              .doc(firebaseUser.uid)
              .set({
            'uid': firebaseUser.uid,
            'Email': firebaseUser.email,
            'name': username.text.trim(),
            'FirstTime': 'Yes',
            'AreaCode': 'Not Set',
            'Address': 'Not Set',
            "Time": DateTime.now(),
            "Points": 5,
            'Phone': '+2${phone.text}'.trim(),
            'emailverified' : "No",
            'photo':
                'https://image.shutterstock.com/image-vector/man-icon-vector-260nw-1040084344.jpg',
          });
          await firestore.collection('UserReports').doc(firebaseUser.uid).set({
            'uid': firebaseUser.uid,
            'Email': firebaseUser.email,
            'name': username.text.trim(),
            "Time": DateTime.now(),
            'Phone': '+2${phone.text}'.trim(),
            'photo':
                'https://image.shutterstock.com/image-vector/man-icon-vector-260nw-1040084344.jpg',
            "AskedOrders": 0,
            "CancelledOrders": 0,
            "CompletedOrders": 0,
          });

          await firestore
              .collection('Sellers')
              .doc(
            '+2${phone.text}'.trim(),
              )
              .set({
            'name': username.text.trim(),
            'Phone': '+2${phone.text}'.trim(),
          });
        }
        model.changeisLoading(false);

        Navigator.pushNamed(context, Home.id);
      } catch (e) {
        model.changeisLoading(false);
print (e.toString()+'لخطااا  + ');

      }
  }

  VerifyAlert(BuildContext context, title, desc, phone) async {
    final bool isValid = EmailValidator.validate( email.text);


if (isValid == false){{


  Fluttertoast.showToast(
      msg: "الايميل المدخل غير صحيح",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: kdark,
      textColor: Colors.white,
      fontSize: 16.0);
}}




    if (password.text.isEmpty ||
        email.text.isEmpty ||
        username.text.isEmpty ||
        phone.text.isEmpty
    ) {


      Fluttertoast.showToast(
          msg: "من فضلك اكمل كل الحقول الفارغه",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kdark,
          textColor: Colors.white,
          fontSize: 16.0);
    }


    if (password.text.isNotEmpty &&
        email.text.isNotEmpty &&
        username.text.isNotEmpty &&
        phone.text.isNotEmpty &&isValid == true ){
      {
        print("phone  : " + phone.text.toString());

        var usersRef =
        await firestore.collection('Sellers').doc('+2${phone.text}'.trim());

        AlertStyle alertStyle;
        usersRef.get().then((docSnapshot) => {
          if (docSnapshot.exists)
            {
              Fluttertoast.showToast(
                  msg: "تم التسجيل بهذا الرقم بالفعل",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: kdark,
                  textColor: Colors.white,
                  fontSize: 16.0)
            }
          else
            {
              alertStyle = AlertStyle(
                animationType: AnimationType.shrink,
                isCloseButton: false,
                isOverlayTapDismiss: false,
                descStyle: TextStyle(fontWeight: FontWeight.bold),
                animationDuration: Duration(milliseconds: 250),
                alertBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                titleStyle: TextStyle(color: klight),
              )
            },
          Alert(
              context: context,
              style: alertStyle,
              title: title,
              desc: desc,
              buttons: [
                DialogButton(
                    child: Text(
                      "الرجوع",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.blueGrey),
                DialogButton(
                    child: Text(
                      "موافق",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => _smsController.text == verifycode
                        ? signup()
                        : _smsController.text.isEmpty == true
                        ? Fluttertoast.showToast(
                        msg: "من فضلك قم بتأكيد الهوية",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: kdark,
                        textColor: Colors.white,
                        fontSize: 16.0)
                        : verifycode == null ?  Fluttertoast.showToast(
                        msg: "الكود المدخل فارغ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: kdark,
                        textColor: Colors.white,
                        fontSize: 16.0) : Fluttertoast.showToast(
    msg: "خطأأ",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: kdark,
    textColor: Colors.white,
    fontSize: 16.0),
                    color: kdark),
              ],
              content: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: klight,
                      child: Text("ارسال كود التفعيل"),
                      onPressed: () async {
                        verifyPhoneNumber();
                      },
                    ),
                  ),
                  Padding(


                      padding: EdgeInsets.all(10),



                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 5),
                              child: TextField(
                                  controller: _smsController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color: klight,
                                      ),
                                    ),
                                    labelText: 'كود التفعيل',
                                    labelStyle:
                                    TextStyle(color: Colors.black),
                                    hintStyle: TextStyle(
                                        fontSize: 20.0, color: klight),
                                  ))))),

                ],
              )).show()
        });
      }

    }






  }

  Future<void> verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+2${phone.text}',
          timeout: const Duration(seconds: 30),
          verificationCompleted: (val) {
            verifycode = val.smsCode;
print ('code'+ val.smsCode);
          },
          verificationFailed: (val) {
            print("verification failed val = $val");
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            Fluttertoast.showToast(
                msg: "تم إرسال كود التفعيل",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: kdark,
                textColor: Colors.white,
                fontSize: 16.0);
            print('verficatioUD     '+ _verificationId + verificationId + " verfviccation COde    "+ verifycode );

          },
          codeAutoRetrievalTimeout: (val) {
            print("code auto retrieval timeout val = $val");
          });

    } catch (e) {
      print("Failed to Verify Phone Number: ${e}");
    }
  }

  sendverifyemail(TextEditingController email) {



  }
}

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
      angle: -pi / 3.5,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [klight, kdark])),
        ),
      ),
    ));
  }
}

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, height);
    path.lineTo(size.width, 0);

    /// [Top Left corner]
    var secondControlPoint = Offset(0, 0);
    var secondEndPoint = Offset(width * .1, height * .4);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    /// [Left Middle]
    var fifthControlPoint = Offset(width * .3, height * .5);
    var fiftEndPoint = Offset(width * .23, height * .6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy,
        fiftEndPoint.dx, fiftEndPoint.dy);

    /// [Bottom Left corner]
    var thirdControlPoint = Offset(0, height);
    var thirdEndPoint = Offset(width, height);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

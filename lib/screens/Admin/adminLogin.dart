
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/Provider/modelhut.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/screens/Admin/Adminmain.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class AdminLogin extends StatefulWidget {
  static String id = "AdminLogin";

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  bool isChecked = false;

  @override
  void initState() {
    getAdminData();
    super.initState();
  }

  static String id = "LoginScreen";
  final store = Store();
  final auth = Auth();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var Email;
  var Password;
  final FirebaseAuth fireauth = FirebaseAuth.instance;
  var adminmail = TextEditingController();
  var adminpass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final email = TextField(
      controller: adminmail,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        //  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextField(
      controller: adminpass,
      autofocus: false,
      //initialValue: '',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final loginButton = Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 2.5,
      child: RaisedButton(
        onPressed: () {
          validateadmin(context);
        },
        padding: EdgeInsets.all(1),
        color: Colors.blue,
        child: Text('Log In',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );
    return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(strokeWidth: 0.5 ,),

      inAsyncCall: Provider.of<Modelhut>(context).isLoading,

      child: Scaffold(
        backgroundColor: klight,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  color: Colors.white,
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: kdark,
                  ),
                ),
              ],
            ),
            Center(
              child: Card(
                elevation: 2.0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 1.15,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 1.5,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30.0),
                      Center(
                          child: Text(
                            "Admin Page",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(height: 48.0),
                      email,
                      SizedBox(height: 8.0),
                      password,
                      SizedBox(height: 24.0),
                      /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value;
                                  });
                                },
                              ),
                              Text("Remember Me")
                            ],
                          ),
                          forgotLabel,
                        ],
                      ),
              */
                      //  SizedBox(height: 18.0),
                      loginButton,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateadmin(BuildContext context) async {

    final model = Provider.of<Modelhut>(context, listen: false);

    model.changeisLoading(true);



    if (adminmail.text.isEmpty || adminmail.text.length < 2 ||
        adminpass.text.isEmpty) {

      model.changeisLoading(false);

      Fluttertoast.showToast(
          msg: "Please insert all fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

    else if (Email ==adminmail.text.trim() && Password == adminpass.text.trim()) {
      model.changeisLoading(false);

      Navigator.of(context).pushReplacementNamed(AdminMain.id);

    }

    else {

      model.changeisLoading(false);

      Fluttertoast.showToast(
          msg:'دخول غير مصرح ... تأكد من بياناتك',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);



      }



  }


  getAdminData() async{


      final DocumentReference document1 = Firestore.instance.collection(
          'Admins')
          .doc('jH0aY4MrsfAMDaHZ7qYp');


      await document1.get().then<dynamic>((DocumentSnapshot snapshot) async {
        setState(() {
          Email = snapshot.get('Email').toString();
          Password = snapshot.get('Password').toString();
        });
      });


  }


}


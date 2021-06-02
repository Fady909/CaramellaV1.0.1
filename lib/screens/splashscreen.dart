
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/screens/User/home.dart';
import 'package:flutter_eapp/screens/User/loginsccreen.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Seller/sellerHome.dart';


class SplashScreenPage extends StatefulWidget

{
  static const id = 'splashscreen';
  @override
  SplashScreenPageState createState() => new SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  Animation<double> topCircelAnimation;
  Animation<double> bottomCircelAnimation;
  Animation<double> logoAnimation;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    topCircelAnimation = Tween<double>(begin: 0, end: 200).animate(controller)
      ..addListener(() {
        setState(() {
          print(topCircelAnimation.value);
        });
      });

    bottomCircelAnimation =
    Tween<double>(begin: 0, end: 350).animate(controller)
      ..addListener(() {
        setState(() {
          print(bottomCircelAnimation.value);
        });
      });

    logoAnimation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          print(logoAnimation.value);
        });
      });
    controller.forward();

    Timer(const Duration(seconds:4), () {
      signsilent();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              height: topCircelAnimation.value,
              width: topCircelAnimation.value,
              decoration: BoxDecoration(
                color: klight,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -150,
            child: Container(
              height: bottomCircelAnimation.value,
              width: bottomCircelAnimation.value,
              decoration: BoxDecoration(
                color: klight,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: logoAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/cramela.jpg',
                    height: 300,
                    width: 300,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // Text(
                  //   'كراميلا',
                  //   style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 40,
                  //       fontFamily: 'Tajawal',
                  //
                  //       fontWeight: FontWeight.bold),
                  // ),


                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  signsilent() async {
    final store = Store();
    final auth = Auth();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    //  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    final FirebaseAuth fireauth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    {
      var getemail = await prefs.getString('email');
      var getpass = await prefs.getString("passord");
      var getselleremail = await prefs.get('selleremail');
      var getsellepassword = await prefs.get('sellerpassword');

      if (getemail != null && getpass != null) {
        try {
          auth.signInsilently(getemail, getpass).then((value) =>


              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Home()))


          );
        } catch (e) {

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));



        }
      }

     else if (getselleremail != null && getsellepassword != null) {
        try {

          print("Not null"+ getsellepassword+ getselleremail );

auth.signInsilently(getselleremail, getsellepassword).then((value) async =>
           await  store.signseller(getselleremail, getsellepassword,context ,SellerHome.id, false));





        }catch(e){

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      }











      else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));


    }


  }













}



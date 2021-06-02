import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/screens/Admin/adminManage.dart';
import 'package:flutter_eapp/screens/Admin/adminSellerApprove.dart';
import 'package:flutter_eapp/screens/Admin/adminSellerControl.dart';
import 'package:flutter_eapp/screens/Admin/manageCoupones.dart';
import 'package:flutter_eapp/screens/User/loginsccreen.dart';
import 'package:flutter_eapp/widgets/profile_list_item.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'Reports.dart';


class AdminMain extends StatelessWidget {
  static String id = 'AdminMain';

  @override
  Widget build(BuildContext context) {


    Firebase.initializeApp();

    return Scaffold  (
     body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppBarButton(
                        icon: Icons.arrow_back,
                      ),

                    ],
                  ),
                ),
                //AvatarImage(),
             //   SizedBox(
               //   height: 30,
                //),
                //SocialIcons(),
                SizedBox(height: 30),
                Text(
                  'مرحبا',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Poppins"),
                ),
              //  Text(
                //  '@amFOSS',
                  //style: TextStyle(fontWeight: FontWeight.w300),
                //),
                SizedBox(height: 15),
                Text(
                  'مرحبا بك في لوحه تحكم المدير',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
                ),
                ProfileListItems(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AppBarButton extends StatelessWidget {
  final IconData icon;
  const AppBarButton({this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kAppPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: kLightBlack,
              offset: Offset(1, 1),
              blurRadius: 10,
            ),
            BoxShadow(
              color: kWhite,
              offset: Offset(-1, -1),
              blurRadius: 10,
            ),
          ]),
      child: Icon(
        icon,
        color: fCL,
      ),
    );
  }
}


class ProfileListItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[


          GestureDetector(
              child: ProfileListItem(
                icon: LineAwesomeIcons.list,
                text: ' أداره المنتجات' ,
              ),
              onTap:() {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return AdminManage();}));}
          ),
          GestureDetector(
              child: ProfileListItem(
                icon: Icons.segment,
                text: 'كل البائعين' ,
              ),
              onTap:() {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return AdminSellerControl();}));}
          ),

          GestureDetector(
              child: ProfileListItem(
                icon: Icons.contact_mail,
                text: ' توثيق بائعين' ,
              ),
              onTap:() {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return AdminSellerAprove();}));}
          ),


          GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(manageCoupones.id);


            },
            child: ProfileListItem(
              icon: Icons.card_giftcard_outlined,
              text: 'كوبونات الخصم',
            ),
          ),

          GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(Reports.id);

            },

            child: ProfileListItem(
              icon: Icons.report_sharp,
              text: 'التقارير',
            ),
          ),

         
          GestureDetector(
            onTap: () async {

              FirebaseAuth.instance.signOut();
              User user = FirebaseAuth.instance.currentUser;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');
              prefs.remove('passord');
              Navigator.of(context).pushReplacementNamed(LoginScreen.id);


            },
            child: ProfileListItem(
              icon: LineAwesomeIcons.alternate_sign_out,
              text: 'تسجيل الخروج',
              hasNavigation: false,
            ),
          ),
        ],
      ),
    );
  }
}
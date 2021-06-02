import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/Provider/Adminmode.dart';
import 'package:flutter_eapp/Provider/modelhut.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/screens/User/signupscreen.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";
  final store =Store();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  final auth = Auth();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth fireauth = FirebaseAuth.instance;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

var name = TextEditingController();
var password = TextEditingController();
var emailcontroller = TextEditingController();
  bool checkedValue = false;

  String toastval = " ";

  get auth => widget.auth;



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
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false , controller}) {
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
    return ChangeNotifierProvider<AdminMode>(
     create: (_) => AdminMode(),
      child: Container(


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
          onTap: (){
            Provider.of<AdminMode>(context, listen: false).enterseller(context);
         // print (name.text);
          validate(context);
          },
          child: Text(
            "تسجيل الدخول",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>Signupscreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'تسجيل مستخدم جديد',
              style: TextStyle(
                  color: kdark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),

            SizedBox(
              width: 10,
            ),
            Text(
              'ليس لديك حساب؟',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return GestureDetector(
      onTap: () {

        Provider.of<AdminMode>(context, listen: false).enteradmin(context);

      },
      child:Center(
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
      ),


      
    /*  
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'd',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10),
            ),
            children: [
              TextSpan(
                text: 'ev',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              TextSpan(
                text: 'rnz',
                style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
              ),
            ]),
      ),
    */
    
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("    البريد الالكتروني     " , isPassword: false , controller:name ),
        _entryField("كلمه السر", isPassword: true , controller: password),
      ],
    );
  }

@override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {


    Firebase.initializeApp();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;


    final height = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(strokeWidth: 0.5 ,),

      inAsyncCall: Provider.of<Modelhut>(context).isLoading,

      child: Scaffold(
          body: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: -height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: BezierContainer()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .2),
                        _title(),
                        SizedBox(height: 50),
                        _emailPasswordWidget(),
                        SizedBox(height: 20),
                        _submitButton(),

                       Row(children: [

                         Expanded(

                           child: CheckboxListTile(
                             title: Text("تسجيل دخول تلقائي؟"),
                             value: checkedValue,
                             onChanged: (newValue) {
                               setState(() {
                                 checkedValue = newValue;
                               });
                             },
                             controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                           ),
                         ),

                         GestureDetector(
                           onTap: (){
                             resetpassword();

                           },
                           child: Container(
                             padding: EdgeInsets.symmetric(vertical: 10),
                             alignment: Alignment.centerRight,
                             child: Text('استرجاع كلمه السر؟',
                                 style: TextStyle(
                                     fontSize: 14, fontWeight: FontWeight.w500)),
                           ),
                         ),


                       ],)
,
                        //_facebookButton(),
                        SizedBox(height: height * 0.1),









                        _createAccountLabel(),
                      ],
                    ),
                  ),
                ),
              //  Positioned(top: 40, left: 0, child: _backButton()),
              ],
            ),
          )),
    );
  }

void validate(BuildContext context) async{
  final model = Provider.of<Modelhut>(context, listen: false);

  model.changeisLoading(true);


if (name.text.isEmpty || name.text.length<2 || password.text.isEmpty ) {
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


else var document = await   widget.firestore.collection('SellerEmails').doc(name.text.trim()).get().then((value) =>
   value.exists ?
 stopseller(model)
       :

    goforit(model)




   );










}

  goforit(Modelhut model) async {
try {
 await widget.auth.signIn(name.text.trim() , password.text.trim() , checkedValue).then((value) =>
     model.changeisLoading(false)

 ).then((value) =>
     Navigator.of(context).pushReplacementNamed(Home.id)

    );

}catch(e){
    model.changeisLoading(false);
  Fluttertoast.showToast(
      msg: e.message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0

  );
    model.changeisLoading(false);
Navigator.of(context).pushReplacementNamed(LoginScreen.id);

}




}

  stopseller(Modelhut model) {
    model.changeisLoading(false);
    Fluttertoast.showToast(
        msg:'لا يمكن للبائعين الدخول',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0

    ).then((value) =>

        Navigator.of(context).pushReplacementNamed(LoginScreen.id)

    );



  }

   resetpassword() {

    var alertStyle = AlertStyle(
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
      titleStyle: TextStyle(
        color: kdark,
      ),
    );
    return     Alert(
      context: context,
      style: alertStyle,
   //   type: AlertType.success,
      title: "استرجاع كلمة السر",
      //desc: "تمت اضافة المنتج المطلوب لسلة التسوق",
      buttons: [
        DialogButton(
          child: Text(
            "رجوع",
            style: TextStyle(color: Colors.black, fontSize: 10),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.grey,
        ),

      ],

      content: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'قم بإدخال الإيميل الخاص بك',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              TextFormField(
               controller: emailcontroller,
                style: TextStyle(color:  Colors.black),
                decoration: InputDecoration(
                  labelText: 'الايميل',
                  icon: Icon(
                    Icons.mail,
                    color: kdark,
                  ),
                  errorStyle: TextStyle(color:  Colors.black12),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black12),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(

                child: Text('ارسل ايميل الأسترجاع'),
                onPressed: () {
try {
 if (emailcontroller.text.isNotEmpty )

  widget.fireauth.sendPasswordResetEmail(email: emailcontroller.text.trim()).then((value) =>

Navigator.pop(context)
  ).then((value) =>
      Fluttertoast.showToast(
      msg: "تم إرسال أيميل الاسترجاع",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 10.0
  )

  )


          .catchError((e){


          Fluttertoast.showToast(
      msg: "من فضلك تأكد من أنك مسجل لدينا وأن الإيميل صالح",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 10.0
  );
      });

}catch(e){
  Fluttertoast.showToast(
      msg: "من فضلك تأكد من أنك مسجل لدينا وأن الإيميل صالح",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 10.0
  );



}
                },
              ),

            ],
          ),
        ),
      ),

    ).show();





  }


}



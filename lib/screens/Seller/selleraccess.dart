import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/Provider/modelhut.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/screens/Seller/sellerHome.dart';
import 'package:flutter_eapp/screens/Seller/sellrNew.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Selleraccess extends StatefulWidget {
  static String id = "SellerAccessScreen";

  @override
  _SelleraccessState createState() => _SelleraccessState();
}

class _SelleraccessState extends State<Selleraccess> {
  var getemail;

  var store = Store();

  final auth = Auth();

  var uemail = TextEditingController();

  var upass = TextEditingController();
  var emailcontroller = TextEditingController();

  final _auth = FirebaseAuth.instance;

  bool sellercheckedValue = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(

      progressIndicator: const CircularProgressIndicator(strokeWidth: 0.5 ,),

      inAsyncCall: Provider.of<Modelhut>(context).isLoading,

      child: Scaffold(
        backgroundColor: kdark,
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 40),
          child: Center(
            child: ListView(
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(100, 50.0, 10.0, 50.0),
                        child: Image(
                          image:  AssetImage('assets/SellerIcon.png'),

                           height: 100,
                          width: 100,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            // E-mail TextField
                            Container(
                              child: TextField(
                                controller: uemail,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(30)),
                                    contentPadding: EdgeInsets.all(15),
                                    suffixIcon: Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                    ),
                                    filled: true,
                                    fillColor: Colors.blue,
                                    focusColor: Colors.blue,
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'البريد الالكتروني'),
                                //onSaved: (input) => _email = input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            // Password TextField
                            Container(
                              child: TextField(
                                controller: upass,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                obscureText: true,

                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(30)),
                                    contentPadding: EdgeInsets.all(15),
                                    suffixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    filled: true,
                                    fillColor: Colors.blue,
                                    focusColor: Colors.blue,
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'كلمه السر'),
                                //  onSaved: (input) => _passwaord = input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),


                            Row(children: [

                              Expanded(

                                child: CheckboxListTile(
                                  title: Text("تسجيل دخول تلقائي؟", style: TextStyle(fontSize: 12),),
                                  value: sellercheckedValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      sellercheckedValue = newValue;
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


                            ],),







                            //  Sign In button
                            RaisedButton(
                                onPressed: () {
                                  authUser(uemail.text, upass.text, context);
                                },
                                padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(30),
                                ),
                                child: Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            // Text Button to Sign Up page
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, SellerNew.id),
                              child: Text(
                                'قم بأنشاء حساب',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.blue),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),

                            /*
                            GoogleSignInButton(
                              onPressed: () {
                                _signInWithGoogle()
                                    .then((FirebaseUser user) => print(user))
                                    .catchError((e) => print(e));
                              },
                              borderRadius: 20,
                            )
                          */
                          ],
                        ),
                      )
                    ],
                  ),
                  elevation: 20,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(150),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  authUser(email, pass, context) async {
    final model = Provider.of<Modelhut>(context, listen: false);

    model.changeisLoading(true);



    if (email.toString().isEmpty || pass.toString().isEmpty) {
      model.changeisLoading(false);

      Fluttertoast.showToast(
          msg: 'اكمل كل الحقول الفارغه',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: klight,
          textColor: Colors.white,
          fontSize: 10.0);
    }


    else if (email.toString().isNotEmpty && pass.toString().isNotEmpty) {

      try {

        sellercheckedValue == true ?
        putsellerinshared(email,pass) : print('notInshared');




        await _auth.signInWithEmailAndPassword(email: email, password: pass).whenComplete(() =>

         store.signseller(email, pass , context , SellerHome.id,  sellercheckedValue )).then((value) =>
            model.changeisLoading(false)


    ).then((value) =>
            sellercheckedValue == true ?
            putsellerinshared(email,pass) : print('notInshared')




    );

      } catch (e) {
        model.changeisLoading(false);

        Fluttertoast.showToast(
            msg: "انت لست مسجل لدينا",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 20.0);
      }


    }
  }


  putsellerinshared(email , password) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selleremail', email);
    await prefs.setString("sellerpassword", password);
    print('SellerInshared');
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

                      _auth.sendPasswordResetEmail(email: emailcontroller.text.trim()).then((value) =>

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






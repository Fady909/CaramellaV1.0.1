import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/Provider/modelhut.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/screens/Seller/sellerHome.dart';
import 'package:flutter_eapp/screens/Seller/selleraccess.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class SellerNew extends StatefulWidget {
  static String id = "SellerCreate";
  var store = Store();
  final auth = Auth();

  @override
  _SellerNewState createState() => _SellerNewState();
}

class _SellerNewState extends State<SellerNew> {


 var guser = TextEditingController();
  var gemail = TextEditingController();
  var gpass = TextEditingController();
 var gphone = TextEditingController();

  navigateToSignInScreen() {
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(strokeWidth: 0.5 ,),

      inAsyncCall: Provider.of<Modelhut>(context).isLoading,

      child: Scaffold(
        backgroundColor: kdark,
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text('Sign Up'),
//      ),
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 40),
          child: Center(
            child: ListView(
              children: <Widget>[
                Card(
                  elevation: 20,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(150),
                      )),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(100, 50.0, 10.0, 50.0),
                        child: Image(
                          image: AssetImage('assets/SellerIcon.png'),
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
//                        Name box
                            Container(
                              child: TextField(
                                controller: guser,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.blue),
                                        borderRadius:
                                        BorderRadius.circular(30)),
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
                                        borderRadius:
                                        BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'الاسم'),
                               // onSaved: (input) => _name = input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
//                      email
                            Container(
                              child: TextFormField(
                                controller: gemail,
                                validator: (value) => EmailValidator.validate(value) ? null :showworingemail(),
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),

                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.blue),
                                        borderRadius:
                                        BorderRadius.circular(30)),
                                    contentPadding: EdgeInsets.all(15),
                                    suffixIcon: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    filled: true,
                                    fillColor: Colors.blue,
                                    focusColor: Colors.blue,
                                    border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'البريد الالكتروني'),
                                //onSaved: (input) => _email = input,
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Container(
                              child: TextField(
                                controller: gphone,
                                maxLength: 11,
                                keyboardType: TextInputType.phone,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),

                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.blue),
                                        borderRadius:
                                        BorderRadius.circular(30)),
                                    contentPadding: EdgeInsets.all(15),
                                    suffixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    filled: true,

                                    fillColor: Colors.blue,
                                    focusColor: Colors.blue,
                                    border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'رقم الهاتف'),
                                //onSaved: (input) => _email = input,
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Container(
                              child: TextField(
                                controller: gpass,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                obscureText: true,

                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.blue),
                                        borderRadius:
                                        BorderRadius.circular(30)),
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
                                        borderRadius:
                                        BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'كلمه السر'),
                                //onSaved: (input) => _password = input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
//                    button
                            RaisedButton(
                                padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadiusDirectional.circular(30),
                                ),
                               onPressed:() {RegresterUser(guser.text , gemail.text, gpass.text , gphone.text);},
                                child: Text(
                                  'تسجيل',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
//                      redirect to signup page
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            GestureDetector(
                              onTap: (){Navigator.of(context).pushNamed(Selleraccess.id);},
                              child: Text(
                                'لديك حساب ؟ تسجيل الدخول',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );



  }

   RegresterUser(user , email , pass , phone)async {
     final model = Provider.of<Modelhut>(context, listen: false);

     model.changeisLoading(true);



     if (user.toString().isEmpty  || email.toString().isEmpty  || pass.toString().isEmpty || pass.toString().isEmpty ) {
       model.changeisLoading(false);

  Fluttertoast.showToast(
      msg: 'اكمل كل الحقول الفارغه',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 10.0
  );
}

if (user.toString().isNotEmpty  && email.toString().isNotEmpty && pass.toString().isNotEmpty && pass.toString().isNotEmpty  ) {
try {
  await widget.auth.signUp(email, pass).then((value) =>

      widget.store.regSeller(user, email, pass , value.user.uid , phone)).then((value) =>
      model.changeisLoading(false)


  ).then((value) =>
      Navigator.of(context).pushNamed(SellerHome.id )


     );
}catch(e){
  model.changeisLoading(false);

  Fluttertoast.showToast(
      msg: 'من فضلك راجع بياناتك',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 10.0
  );

}

}



  // await store.regSeller(user,  email, pass);
  }

  showworingemail() {
    Fluttertoast.showToast(
        msg: 'الايميل المدخل غير صحيح',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 10.0
    );

  }

}
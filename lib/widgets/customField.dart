
import 'package:flutter/material.dart';
class CustomField extends StatelessWidget {
  final  String hint ;
  final IconData icon;
  final Function onClick;

  var type;


  String errormsg (String str  ){
    switch (hint){
      case 'Enter your Name' : return 'Name is Empty ';
      case 'Enter your E-mail' : return 'E-Mail is Empty ';
      case  'Enter your Password' : return 'Password is Empty ';
      case  'Enter your E-mail ' : return 'E-mail is Empty ';
      case  'Enter your Password ' : return 'Password is Empty ';

    }

  }
  // ignore: empty_constructor_bodies
  CustomField(@required this.onClick,@required this.hint , @required this.icon , [input]);

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      textAlign: TextAlign.right,

      // ignore: missing_return
      validator: (value){
        if(value.isEmpty){return errormsg(hint);}
        }


      ,
      onSaved: onClick
      ,
      obscureText: hint == 'Enter your Password' ? true : false ,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.black),

        filled: true,
        hintText: hint,
        hintMaxLines: 2,
        fillColor: Colors.white30,
        prefixIcon: Icon(icon, color: Colors.black,),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.pinkAccent,
            )
            , borderRadius: BorderRadius.circular(20)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.pink,
            )
            , borderRadius: BorderRadius.circular(20)
        ),
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.redAccent,

            )
            , borderRadius: BorderRadius.circular(20)
            ,

        ),
      ),

    );
  }
}

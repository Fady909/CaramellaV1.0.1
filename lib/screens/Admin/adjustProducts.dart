import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:flutter_eapp/widgets/customField.dart';

class adjustProducts extends StatelessWidget {

// to getthe argument from the push

  static String id =  'AdjustProducts';
  String pname  , pprice , pdescription  , pcategory , plocation;
  final GlobalKey<FormState> globalKey1 = GlobalKey <FormState> ();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final store =Store();
  @override
  Widget build(BuildContext context) {
     Product product = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      resizeToAvoidBottomInset:  false,
        body: Form(
          key: globalKey1,
          child: ListView(


            children: [
              SizedBox(height: MediaQuery.of(context).size.height*.2,),
              Column(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  CustomField( ((value){pname = value;}), 'Product Name', (null),
                  ),
                  SizedBox(height: 10,),
                  CustomField( ((value){pprice = value;}), 'Product Price', (null)),
                  SizedBox(height: 10,),


                  CustomField( ((value){ pdescription = value;}), 'Product Description', (null)),
                  SizedBox(height: 10,),

                  CustomField( ((value){ pcategory = value;}), 'Product Category', (null)),
                  SizedBox(height: 10,),

                  CustomField( ((value){ plocation= value ;}), 'Product Location', (null)),
                  SizedBox(height: 10,),
                  RaisedButton(onPressed:()  {

                    validate(context, product);



                  }
                    ,child: Text('Save your Product' ) ,
                    elevation: 26,

                  )


                ],


              )
            ],
          ),
        ),
        backgroundColor: Colors.purple);

  }


  void validate(BuildContext context, Product product) {
    if (globalKey1.currentState.validate()){
      globalKey1.currentState.save();


store.editproduct((
{kProductName : pname , kProductPrice : pprice , kProductDescription : pdescription , kproductImage : plocation , kProductCategory : pcategory}





), product.pID);

    }









  }







}

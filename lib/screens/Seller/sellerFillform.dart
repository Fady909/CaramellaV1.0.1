import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/Provider/modelhut.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/screens/Seller/sellerHome.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
class SellerFillForm extends StatefulWidget {

  @override
  _SellerFillFormState createState() => _SellerFillFormState();
}

class _SellerFillFormState extends State<SellerFillForm> {
  bool pressed = false;
  User loggedSeller;
  String Photo  = 'https://www.attendit.net/images/easyblog_shared/July_2018/7-4-18/b2ap3_large_totw_network_profile_400.jpg';
  File _image;

  String _uploadedFileURL;
  String IsNew='';
  String Verified = '';
  String userName = 'ائع جديد';
  final FirebaseAuth fireauth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var  uploadname = TextEditingController();
  var  uploadaddress = TextEditingController();
  var  uploadstorename = TextEditingController();
  var  uploadNumber = TextEditingController();
  var  uploadstoreproducts = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(strokeWidth: 0.5 ,),

      inAsyncCall: Provider.of<Modelhut>(context).isLoading,
      child: Scaffold(
        backgroundColor:  Colors.grey[300],
        appBar: AppBar(
          title: Text(
            'تسجيل بائع جديد',
            style:TextStyle(
              color: Colors.grey[800],
            ),
          ),
          centerTitle: true,
          backgroundColor: pressed ? Colors.grey[900] : Colors.grey[100],
        ),
        floatingActionButton: Center(
          child: FloatingActionButton(
          child: Text("رفع"),
            onPressed: () => validate(context),
          ),
        ),
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: pressed ? Colors.grey[700] : Colors.grey[100],
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: chooseFile,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(Photo),
                          radius: 60.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                       userName,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.75,
                            color: pressed ? Colors.grey[200] : Colors.grey[900]),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        loggedSeller.email,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14.0,
                          letterSpacing: 0.75,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: TextField(
                    textAlign: TextAlign.right,
                    controller: uploadname,
                  //  maxLength: 10,
                    textCapitalization:
                    TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                         //   borderRadius:
                        //    BorderRadius.circular(30)

                        ),
                        contentPadding: EdgeInsets.all(15),

                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(1)),
                        hintStyle: TextStyle(color: Colors.black45),
                        hintText: 'الاسم' ),
                    // onSaved: (input) => _name = input,
                  ),
                ),

                Divider(
                  height: 0.20,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: TextField(
                    textAlign: TextAlign.right,
                       controller: uploadaddress,
                    //  maxLength: 10,
                    textCapitalization:
                    TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          //   borderRadius:
                          //    BorderRadius.circular(30)

                        ),
                        contentPadding: EdgeInsets.all(15),

                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(1)),
                        hintStyle: TextStyle(color: Colors.black45),
                        hintText: 'العنوان بالتفصيل' ),
                    // onSaved: (input) => _name = input,
                  ),

                ),

                Divider(
                  height: 0.20,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: TextField(
                    textAlign: TextAlign.right,
                      controller: uploadstorename,
                    //  maxLength: 10,
                    textCapitalization:
                    TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          //   borderRadius:
                          //    BorderRadius.circular(30)

                        ),
                        contentPadding: EdgeInsets.all(15),

                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(1)),
                        hintStyle: TextStyle(color: Colors.black45),
                        hintText: 'اسم المتجر' ),
                    // onSaved: (input) => _name = input,
                  ),
                ),

                Divider(
                  height: 0.20,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: TextField(
                    textAlign: TextAlign.right,
                        controller: uploadNumber,
                    //  maxLength: 10,
              //      textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],


                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          //   borderRadius:
                          //    BorderRadius.circular(30)

                        ),
                        contentPadding: EdgeInsets.all(15),

                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(1)),
                        hintStyle: TextStyle(color: Colors.black45),
                        hintText: 'رقم التليفون .... سيتم الاتصال للتاكيد' ),
                    // onSaved: (input) => _name = input,
                  ),
                ),
                Divider(
                  height: 0.20,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: TextField(
                    textAlign: TextAlign.right,
                        controller: uploadstoreproducts,
                    //  maxLength: 10,
                    textCapitalization:
                    TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          //   borderRadius:
                          //    BorderRadius.circular(30)

                        ),
                        contentPadding: EdgeInsets.all(15),

                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(1)),
                        hintStyle: TextStyle(color: Colors.black45),
                        hintText: "نوع منتجاتك" ),
                    // onSaved: (input) => _name = input,
                  ),
                ),

                Divider(
                  height: 0.20,
                ),
                SizedBox(
                  height: 20,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<dynamic> getData() async {
    loggedSeller = fireauth.currentUser;
    String UID = loggedSeller.uid;
    String Email = loggedSeller.email;

    final DocumentReference document = Firestore.instance.collection(
        ksellercollection)
        .doc(UID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        IsNew = snapshot.get('IsNew').toString();
        Verified = snapshot.get('Verified').toString();
        userName= snapshot.get('Seller Name').toString();
      });
    });

  }

  @override
  void initState() {
    getData();
  }







  Future uploadFile() async {




    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd-hh-mm-ss');
    String formattedDate = formatter.format(now);
    loggedSeller = fireauth.currentUser;

    String uID = loggedSeller.uid;

    final model = Provider.of<Modelhut>(context, listen: false);
    model.changeisLoading(true);

    Reference storageReference = FirebaseStorage.instance
        .ref('SellerProfile')
        .child(formattedDate+' img');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() =>  model.changeisLoading(false)

    );


    storageReference.getDownloadURL().then((fileURL) async {
      setState(() {
        _uploadedFileURL = fileURL;
      });



        {
          firestore.collection(ksellercollection).doc(uID).update(  {
            'photo' : _uploadedFileURL


          });







    }}).then((value) =>

        Fluttertoast.showToast(
            msg: "تم اختيار الصوره بنجاح ... ستظهر في الصفحه الشخصيه بعد اجتمال التسجيل",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0
        )

    );

    model.changeisLoading(false);


  }


  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    }).then((value) =>

        uploadFile()

    );
  }

  void validate(BuildContext context) {

    final model = Provider.of<Modelhut>(context, listen: false);

    model.changeisLoading(true);

    loggedSeller = fireauth.currentUser;

    String uID = loggedSeller.uid;

    if (uploadname.text.isEmpty || uploadname.text == null ||
        uploadNumber.text.isEmpty || uploadNumber.text == null ||
        uploadaddress.text.isEmpty || uploadaddress.text == null ||
        uploadstorename.text.isEmpty || uploadstorename.text == null ||
        uploadstoreproducts.text.isEmpty || uploadstoreproducts.text == null) {

      model.changeisLoading(false);

      Fluttertoast.showToast(
          msg: "من فضلك اكمل جميع الحقول الفارغه",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0
      );
    }
    else
      firestore.collection(ksellercollection).doc(uID)

          .set(
          { 'uid': uID,
            'Email': loggedSeller.email,
            'Address': uploadaddress.text.trim(),
            'Phone': uploadNumber.text.trim(),
            'Store Name': uploadstorename.text.trim(),
            'StarSellers' : 'No',
            "Time" : DateTime.now(),
            'Store Products': uploadstoreproducts.text.trim(),})
          .whenComplete(() =>

      {
        firestore.collection(ksellercollection).doc(uID)
          .update({
          'Seller Name': uploadname.text.trim(),
          'IsNew': 'No',
          'Verified': 'No',
          'photo': _uploadedFileURL
        }).then((value) =>
      model.changeisLoading(false)


        ).then((value) =>
       firestore.collection('SellerReports').doc(uID).set(
      {  'uid' :uID ,
        'Email': loggedSeller.email,
        'Address': uploadaddress.text.trim(),
        'Phone': uploadNumber.text.trim(),
        'Store Name': uploadstorename.text.trim(),
        'StarSellers' : 'No',
        "Time" : DateTime.now(),
        'Store Products': uploadstoreproducts.text.trim(),
        "AddProducts" : 0 ,
        "Cashed" : 0 ,
      }


      ),)

            .then((value) =>
            Navigator.of(context).pushReplacementNamed(SellerHome.id)


        )


      });
  }}

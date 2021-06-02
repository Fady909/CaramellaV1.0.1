import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/Provider/modelhut.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/screens/Seller/sellerVerifyedHome.dart';
import 'package:flutter_eapp/screens/User/UserProfile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerProfile extends StatefulWidget {
  static String id = "SellerProfile";


  @override
  _SellerProfileState createState() => _SellerProfileState();
  var  uploadname = TextEditingController();
  var  uploadaddress = TextEditingController();
  var  uploadstorename = TextEditingController();
  var  uploadNumber = TextEditingController();
  var  uploadstoreproducts = TextEditingController();
  File _image;

  String _uploadedFileURL;
  File _imagepnr;

  String _uploadedFileURLpnr;

  String IsNew='';
  String Verified = '';

}

class _SellerProfileState extends State<SellerProfile> {
  String aaddress="العنوان";

  String aemail='الايميل';
  String aphone='رقم التليفون';
  String aname="الاسم";
  String aproducts='نوع منتجاتك';
  String astore='اسم المتجر';
  String aphoto  = 'https://www.attendit.net/images/easyblog_shared/July_2018/7-4-18/b2ap3_large_totw_network_profile_400.jpg';
  String aphotopn  = 'https://images.unsplash.com/32/Mc8kW4x9Q3aRR3RkP5Im_IMG_4417.jpg?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80';
  final FirebaseAuth fireauth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<FormState> globalKey = GlobalKey <FormState> ();



  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  User loggedSeller;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(

      progressIndicator: const CircularProgressIndicator(strokeWidth: 0.5 ,),

      inAsyncCall: Provider.of<Modelhut>(context).isLoading,

      child: Scaffold(
        backgroundColor:  Colors.white,
        appBar: AppBar(
          title: Text(
            'الصفحه الشخصيه',
            style:TextStyle(
              color: Colors.grey[800],
            ),
          ),
          centerTitle: true,
          leading: GestureDetector(child: Icon(Icons.arrow_back, color: Colors.red,)

         , onTap: (){
            Navigator.pushReplacementNamed(context, ShowHome.id);
        },
          ),
          backgroundColor:  Colors.grey[100],
        ),
        body:SingleChildScrollView(
        child:  Column(children: [

          SizedBox(
            height: 50.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.grey[100],
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),

                   Stack(
                      children: [CircleAvatar(
                        backgroundImage: NetworkImage(aphoto),
                        radius: 60.0,
                      ),
                      GestureDetector(
                        onTap:chooseFile,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50, top: 100),
                          child: Card(color: Colors.red,child: Icon(Icons.edit)),
                        ),
                      )
                      ],

                    ),


                  SizedBox(
                    height: 10.0,
                  ),

                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Card(
            color:  Colors.grey[100],
            elevation: 10,
            child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[









                Text('اسم المستخدم', textAlign: TextAlign.end,)



                ,Container(
                  height: 100,
                  child: Theme(
                    data: new ThemeData(
                      primaryColor: klight,
                      primaryColorDark: kdark,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: TextFormField(
                                    textAlign: TextAlign.end,
                                    controller:widget. uploadname,
                                    decoration: InputDecoration(

                                      border: OutlineInputBorder(

                                        borderSide: BorderSide(
                                          width: 2,
                                          style: BorderStyle.solid,
                                          color: klight,

                                        ),
                                      ),
                                      hintText: aname,
                                      alignLabelWithHint: true,
                                      labelStyle: TextStyle(color: Colors.black),
                                      hintStyle: TextStyle(fontSize: 15.0, color: kdark),


                                    ))))),
                  ),
                ),

                Divider(
                  height: 0.20,
                ),

                Divider(
                  height: 0.20,
                ),


                Divider(
                  height: 0.20,
                ),


                Text('نوعية المنتجات', textAlign: TextAlign.end,),

                SizedBox(
                  height: 5.0,
                ),

                SizedBox(
                  height: 5.0,
                ),


                Container(
                  height: 100,
                  child: Theme(
                    data: new ThemeData(
                      primaryColor: klight,
                      primaryColorDark: kdark,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: TextField(
                                  //controller: couponvalue,
                                    textAlign: TextAlign.right,
                                    controller:widget. uploadstoreproducts,
                                    decoration: InputDecoration(

                                      border: OutlineInputBorder(

                                        borderSide: BorderSide(
                                          width: 2,
                                          style: BorderStyle.solid,
                                          color: klight,

                                        ),
                                      ),
                                      hintText: aproducts,
                                      labelStyle: TextStyle(color: Colors.black),
                                      hintStyle: TextStyle(fontSize: 15.0, color: kdark),


                                    ))))),
                  ),
                ),




                Divider(
                  height: 0.20,
                ),
                SizedBox(
                  height: 20,
                ),

              FloatingActionButton(
                  child: Text("رفع"),
                  onPressed: () => validate(context),
                ),




              ],
            ),


          ),),
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.grey[100],
              child: Column(

                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap:chooseFilepnr,
                          child: Card(color: Colors.red,child: Icon(Icons.photo_size_select_actual)),
                        )
,
                        Text("اختيار بانر للمتجر", textAlign: TextAlign.end,)

                      ]),
                  SizedBox(
                    height: 10.0,
                  ),


                                        Container(
                                        child: Image(image: NetworkImage(aphotopn), fit: BoxFit.fill, )
                                      ,height: 100,
                                        width: 200,
                                      ),


                  SizedBox(
                    height: 10.0,
                  ),

                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),

        ],)

        ),
      ),
    );
  }


  @override
  void initState() {
    getAdminData();
  }

  Future uploadFile() async {

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd-hh-mm-ss');
    String formattedDate = formatter.format(now);


    loggeduser = fireauth.currentUser;
    final SharedPreferences prefs = await _prefs;

    String uID = loggeduser.uid;

    final model = Provider.of<Modelhut>(context, listen: false);
    model.changeisLoading(true);
    try{
    Reference storageReference = FirebaseStorage.instance
        .ref('SellerProfile')
        .child(formattedDate+' img');
    UploadTask uploadTask = storageReference.putFile(widget._image);
    await uploadTask.whenComplete(() =>  model.changeisLoading(false)

    );



    storageReference.getDownloadURL().then((fileURL) async {
      setState(() {
        widget. _uploadedFileURL = fileURL;
      });



      {
        firestore.collection(ksellercollection).doc(uID).update(  {
          'photo' : widget._uploadedFileURL


        });







      }}).then((value) =>


        Fluttertoast.showToast(
            msg: "تم اختيار الصوره بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0
        ).then((value) => setState(() {
        }))
    );





  }catch(e){
  Fluttertoast.showToast(
  msg: "خطأ أتناء أختيار الصورة",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 1,
  backgroundColor: Colors.red,
  textColor: Colors.white,
  fontSize: 10.0
  ).then((value) => setState(() {
    model.changeisLoading(false);


  }));





  }




  }


  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        widget._image = image;
      });
    }).then((value) =>

        uploadFile()

    );
  }

  void validate(BuildContext context)
  {

    final model = Provider.of<Modelhut>(context, listen: false);

    model.changeisLoading(true);
    String uID = fireauth.currentUser.uid;


    if (widget.uploadname.text.isEmpty ||widget. uploadname.text == null ||

        widget.   uploadstoreproducts.text.isEmpty ||widget. uploadstoreproducts.text == null) {

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




            firestore.collection('Sellers').doc(uID)
                .update({
              'Seller Name':widget. uploadname.text.trim(),
              'Store Products':widget. uploadstoreproducts.text.trim(),



          }).whenComplete(() =>

              model.changeisLoading(false)



          ).then((value) =>

              Navigator.pushReplacementNamed(context, ShowHome.id));





  }

  Future<dynamic> getAdminData() async {

    loggedSeller = fireauth.currentUser;
    String uID = loggedSeller.uid;

    final DocumentReference document = Firestore.instance.collection(
        ksellercollection)
        .doc(uID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        aaddress = snapshot.get('Address').toString();
        aphone= snapshot.get('Phone').toString();
        aname= snapshot.get('Seller Name').toString();
        astore= snapshot.get('Store Name').toString();
        aproducts= snapshot.get('Store Products').toString();
        aphoto= snapshot.get('photo').toString();
        aphotopn= snapshot.get('banner').toString();
      });
    });


  }










  Future uploadFilepnr() async {

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd-hh-mm-ss');
    String formattedDate = formatter.format(now);


    loggeduser = fireauth.currentUser;
    final SharedPreferences prefs = await _prefs;

    String uID = loggeduser.uid;

    final model = Provider.of<Modelhut>(context, listen: false);
    model.changeisLoading(true);
try {
  Reference storageReference = FirebaseStorage.instance
      .ref('SellerBanners')
      .child(formattedDate + ' img');
  UploadTask uploadTask = storageReference.putFile(widget._imagepnr);
  await uploadTask.whenComplete(() => model.changeisLoading(false)

  );


  storageReference.getDownloadURL().then((fileURL) async {
    setState(() {
      widget._uploadedFileURLpnr = fileURL;
    });


    {
      firestore.collection(ksellercollection).doc(uID).update({
        'banner': widget._uploadedFileURLpnr
      });
    }
  }).then((value) =>


      Fluttertoast.showToast(
          msg: "تم اختيار الصوره بنجاح",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0
      ).then((value) => setState(() {}))


  );
}catch(e){
  Fluttertoast.showToast(
      msg: "خطأ أتناء أختيار الصورة",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 10.0
  ).then((value) => setState(() {}));



  model.changeisLoading(false);


}


  }


  Future chooseFilepnr() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        widget._imagepnr = image;
      });
    }).then((value) =>

        uploadFilepnr()

    );


  }






}
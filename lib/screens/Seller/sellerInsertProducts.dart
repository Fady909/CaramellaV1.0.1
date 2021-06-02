import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_picture_uploader/firebase_picture_uploader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_eapp/Provider/modelhut.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';




class SellerInsert extends StatefulWidget {
  static String id = "SellerInsertProduct";
  static final DateTime now = DateTime. now();


  @override
  _SellerInsertState createState() => _SellerInsertState();
}

class _SellerInsertState extends State<SellerInsert> {
  File _image;

  String _uploadedFileURL;

  final GlobalKey<FormState> globalKey1 = GlobalKey <FormState> ();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();

  final FirebaseAuth fireauth = FirebaseAuth.instance;


  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  User loggedSeller;

  String Address = '';
  String User_email='';
  String Phone='';
  String Store_name='';
  String Store_product='';
  String User_name='';
  String User_Image='';
  String pname  , pprice , pdescription  , pcategory , plocation , psubcategory , pdisount;
  double pafterdicount;
  List<UploadJob> _profilePictures = [];
  int pstock;

  final store =Store();
  var progess;
  var category  ;

  List<QueryDocumentSnapshot> _queryCat;

  var subcategory;

  String token;
  Color currentColor = Color(0xffeeff41);
  List<dynamic> currentColors = [];
  List<String> colorlist = [];

  var c;

  void changeColor(Color color) {


    setState(()  {currentColor = color; });
    currentColors.add(currentColor);
    colorlist.add(currentColor.value.toString());

    Navigator.pop(context);

    print(currentColors.toList());

  }
  void changeColors(List<dynamic> colors) => setState(() => currentColors = colors);



  Widget build(BuildContext context) {



    return  ModalProgressHUD(
      inAsyncCall: Provider.of<Modelhut>(context).isLoading,
      progressIndicator: const CircularProgressIndicator(strokeWidth: 0.5 ,),

      child: Scaffold(
          body: Form(
            key: globalKey1,
            child: SingleChildScrollView(

              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Card(
                    elevation: 20,
                    color: Colors.white,
                   child: Text('  مرحبا ...هذا القسم مختص برفع منتجاتك   '),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width/1,
                     // height: MediaQuery.of(context).size.height/1,
                      child: SingleChildScrollView(
                        child: Card(

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  topRight: Radius.circular(50)),
                              side: BorderSide(width: 5, color: Colors.pink)),




                          elevation: 20,
                          color: Colors.white,
                          shadowColor: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              SizedBox(height: 50,),


                              TextFormField (

                                  keyboardType: TextInputType.text                                ,


                                textAlign: TextAlign.right,

                                // ignore: missing_return
                                validator: (value){
                                  if(value.isEmpty){ Fluttertoast.showToast(
                                      msg: "لا يمكن ان يكون الاسم فارغ",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);}

                                  else  if (value.isNotEmpty)  {onsave: {pname = value;}}

                                }

                                ,
                                //inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],

                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.black),

                                  filled: true,
                                  hintText: 'اسم المنتج',
                                  hintMaxLines: 2,
                                  fillColor: Colors.white30,
                                  prefixIcon: Icon(Icons.money, color: Colors.black,),
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
                                textInputAction: TextInputAction.done,
                              ),//    keyboardType: TextInputType.numberWithOptions(decimal: true),),
                              SizedBox(height: 10,),
                              TextFormField (
                                textAlign: TextAlign.right,

                                // ignore: missing_return
                                validator: (value){
                                  if(value.isEmpty){ Fluttertoast.showToast(
                                      msg: "لا يمكن ان تكون القيمه فارغه",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);}

                                  else  if (value.isNotEmpty)  {onsave: pprice = value;}

                                }

                                ,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],

                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.black),

                                  filled: true,
                                  hintText: 'ادخل السعر',
                                  hintMaxLines: 2,
                                  fillColor: Colors.white30,
                                  prefixIcon: Icon(Icons.money, color: Colors.black,),
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
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),),
                              SizedBox(height: 10,),
                              TextFormField (
                                textAlign: TextAlign.right,

                                // ignore: missing_return
                                validator: (value){
                                  if(value.isEmpty){ pdisount == '0';}

                                  else  if (value.isNotEmpty)  {onsave: pdisount = value;}

                                }

                                ,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],

                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.black),

                                  filled: true,
                                  hintText: 'التخفيض',
                                  hintMaxLines: 2,
                                  fillColor: Colors.white30,
                                  prefixIcon: Icon(Icons.call_received_sharp, color: Colors.black,),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.pinkAccent,
                                      )
                                      , borderRadius: BorderRadius.circular(20)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.pinkAccent,
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
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),),
                              SizedBox(height: 10,),





                              TextFormField (
                                textAlign: TextAlign.right,

                                // ignore: missing_return
                                validator: (value){
                                  if(value.isEmpty){ Fluttertoast.showToast(
                                      msg: "لا يمكن ان تكون القيمه فارغه",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);}

                                  else  if (value.isNotEmpty)  {onsave: pstock= int.parse(value);}

                                }

                                ,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],

                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.black),

                                  filled: true,
                                  hintText: 'عدد الموجود بالمخزن',
                                  hintMaxLines: 2,
                                  fillColor: Colors.white30,
                                  prefixIcon: Icon(Icons.money, color: Colors.black,),
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
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),),
                              SizedBox(height: 10,),




                             /*
                              CustomField( ((value){ pdescription = value;}), 'وصف المنتج', (null)),
                             */

                              TextFormField (
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.text                                ,

                                // ignore: missing_return
                                validator: (value){
                                  if(value.isEmpty){ Fluttertoast.showToast(
                                      msg: "لا يمكن ان يكون الوصف فارغ",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);}

                                  else  if (value.isNotEmpty)  {onsave:pdescription = value;}

                                }

                                ,
                          //      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],

                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.black),

                                  filled: true,
                                  hintText: 'وصف المنتج',
                                  hintMaxLines: 2,
                                  fillColor: Colors.white30,
                                  prefixIcon: Icon(Icons.money, color: Colors.black,),
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
                                textInputAction: TextInputAction.done,
                                ),
                              SizedBox(height: 10,),

                              SizedBox(height: 10,),


                              showdropdown (),

                              SizedBox(height: 10,),
                              showdropdownsubcat (category),
                              SizedBox(height: 10,),
                              RaisedButton(
                                  elevation: 3.0,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          titlePadding: const EdgeInsets.all(0.0),
                                          contentPadding: const EdgeInsets.all(0.0),
                                          content: SingleChildScrollView(
                                            child: MaterialPicker(
                                              pickerColor: currentColor,
                                              onColorChanged: changeColor,
                                              enableLabel: true,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('إضافة لون'),
                                  color: Colors.white,
                                  textColor:Colors.black
                              ),
                              Container(
                                height: 300,width: 500,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                    itemCount: currentColors.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      // access element from list using index
                                      // you can create and return a widget of your choice
                                      return Row(children: [

                                        GestureDetector(

                                            onTap: (){
                                              currentColors.remove(currentColors[index]);
                                              setState(() {

                                              });
                                            }
                                            ,
                                            child: Icon(Icons.delete)),
                                        Card(
                                        color:   currentColors[index]
                                        ,
                                          child: Text(

                                            "${currentColors[index]} ",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),



                                      ]);
                                    }

                                ),
                              ),










                              Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('الصوره المختاره'),
                                  _image != null
                                      ? Image.asset(
                                    _image.path,
                                    height: 150,
                                  )
                                      : Container(height: 150),
                                  _image == null
                                      ? RaisedButton(
                                    child: Text('اختر صوره'),
                                    onPressed: chooseFile,
                                    color: Colors.pinkAccent,
                                  )
                                      : Container(),
                                  _image != null
                                      ? RaisedButton(
                                    child: Text('ارفع الصوره'),
                                    onPressed: uploadFile,
                                    color: Colors.pinkAccent,
                                  )
                                      : Container(),
                                  _image != null
                                      ? RaisedButton(
                                    child: Text('افرغ الحقول'),
                                    onPressed: clearSelection,
                                  )
                                      : Container(),
                                  Text('الصوره المرفوعه'),
                                  _uploadedFileURL != null
                                      ? Image.network(
                                    _uploadedFileURL,
                                    height: 150,
                                  )
                                      : Container(),
                                ],
                              ),














                            ],


                          ),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(height:50,),


                ],

              ),
            ),
          ),
          backgroundColor: Colors.pinkAccent),
    );   }







  Future<dynamic> getData() async {

    loggedSeller = fireauth.currentUser;
  String  UID = loggedSeller.uid;
    String Email = loggedSeller.email;

    final DocumentReference document = Firestore.instance.collection(
        ksellercollection)
        .doc(UID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        Address = snapshot.get('Address').toString();
        User_email = snapshot.get('Email').toString();
        Phone = snapshot.get('Phone').toString();
        Store_name = snapshot.get('Store Name').toString();
        Store_product = snapshot.get('Store Products').toString();
        User_name = snapshot.get('Seller Name').toString();
        User_Image = snapshot.get('photo').toString();
        token = snapshot.get('token').toString();
      });
    });

    print(
        token

    );
    final model = Provider.of<Modelhut>(context, listen: false);

    model.changeisLoading(false);
  }


  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {



   // final result = new Map.fromIterable(currentColors, key: (v) => v[0], value: (v) => v[1]);










    loggedSeller = fireauth.currentUser;
    String  UID2= loggedSeller.uid;
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd-hh-mm-ss');
    String formattedDate = formatter.format(now);


    final model = Provider.of<Modelhut>(context, listen: false);
    model.changeisLoading(true);

    Reference storageReference = FirebaseStorage.instance
        .ref('ProductMainImage')
        .child(formattedDate+' img');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() =>  model.changeisLoading(false)

    );


    storageReference.getDownloadURL().then((fileURL) async {
      setState(() {
        _uploadedFileURL = fileURL;
      });

      if (globalKey1.currentState.validate()) {
        model.changeisLoading(true);

        globalKey1.currentState.save();

if (pdisount == '0' ||pdisount == null){

  await store.addProduct(Product(
      null, pname, pprice, pdescription, pcategory, _uploadedFileURL,psubcategory,

      pprice, '',null,pstock
      ,  sellername:  User_name,sellershop: Store_name, state: 'No',sellerID: UID2

,           TimePosted: DateTime.now(),
            sellerToken: token,
      colors: colorlist


  ));

  model.changeisLoading(false);

}
else if (pdisount != null )

  {pafterdicount = int.parse(pprice)- (int.parse(pprice)*int.parse(pdisount)/100);






  await store.addProduct(Product(
      null, pname, pprice, pdescription, pcategory, _uploadedFileURL,psubcategory,

      pafterdicount.toString(), pdisount,null,pstock
      ,  sellername:  User_name,sellershop: Store_name, state: 'No',sellerID: UID2
,         TimePosted: DateTime.now(),
           sellerToken: token,
           colors: colorlist



  ));


  model.changeisLoading(false);



  }






        Fluttertoast.showToast(
            msg: "File Uploaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        model.changeisLoading(false);
        clearSelection();

      }


    });
  }



  void clearSelection() {
    setState(() {

      _image = null;
      pname = null;
      pprice=null;
      pdisount=null;
      _uploadedFileURL = null;
      category=null;


      globalKey1.currentState.reset();


    });
  }






  Widget showdropdown (){

    return  new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot){
          if (!snapshot.hasData) return const Center(
            child: const CupertinoActivityIndicator(),
          );
          var length = snapshot.data.documents.length;
          DocumentSnapshot ds = snapshot.data.docs[length - 1];
          _queryCat = snapshot.data.docs;
          return new Container(
            padding: EdgeInsets.only(bottom: 16.0),
            width: 300,
            child: new Row(
              children: <Widget>[
                new Expanded(
                    flex: 2,
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(12.0,10.0,10.0,10.0),
                      child: new Text("القسم",),
                    )
                ),
                new Expanded(
                  flex: 4,
                  child:new InputDecorator(

                    decoration: const InputDecoration(
                      labelText: "اختر",
                      hintText: 'Choose an category',
                      isDense: true,
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    isEmpty: category == 'No Categories',
                    child: DropdownButton
                      (
                      value: category ,
                      isDense: true,
                      onChanged: ( newValue) {

                        if(newValue == "All"){
                          Fluttertoast.showToast(
                              msg: "لا يمكنك اختيار كل الاقسام",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 20.0);

                          setState(() {
                            Navigator.of(context).pushReplacementNamed(SellerInsert.id);

                          });

                        }



                        else
                          setState(() {

                            category = newValue;
                            pcategory =category;
                            print(category + pcategory);

                          });



                      },


                      items: snapshot.data.docs.map((DocumentSnapshot document) {
                        return new DropdownMenuItem<String>(
                            value: document.data()['category'],

                            child: new Container(
                              padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                              child: new Text(document.data()['category'],style:TextStyle(color: Colors.black)),

                              //color: primaryColor,
                            )


                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );











        }






    );








  }

  @override
  void initState() {
  getData();
  }
  Strem(getcategory) {


    if (category != 'All' ) {return Firestore.instance.collection('subCategory').where('CategoryName' , isEqualTo: getcategory).snapshots();}

    else if (category == 'All') return store.loadSubCat();




  }




  showdropdownsubcat(getcategory) {


    return  new StreamBuilder<QuerySnapshot>(



        stream:  Strem(getcategory),



        builder: (context, snapshot){
          if (!snapshot.hasData ) return Center(
            child: Text('No Data'),
          );


          var length = snapshot.data.documents.length;
          DocumentSnapshot ds = snapshot.data.docs[length - 1];
          _queryCat = snapshot.data.docs;
          return new Container(
            padding: EdgeInsets.only(bottom: 16.0),
            width: 500,
            child: new Row(
              children: <Widget>[
                new Expanded(
                    flex: 0,
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(12.0,10.0,10.0,10.0),
                      child: new Text("",),
                    )
                ),
                new Expanded(
                  flex: 5,
                  child:new InputDecorator(

                    decoration: const InputDecoration(
                      labelText: " اختر القسم الفرعي",
                      // hintText: 'Choose an category',
                      isDense: true,
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    isEmpty: subcategory == 'No subCategories',
                    child: DropdownButton
                      (

                      value: subcategory ,
                      isDense: true,
                      onChanged: ( newValue) {
                        setState(() {

                          subcategory = newValue;
                          psubcategory = subcategory;



                        });

                      },


                      items: snapshot.data.docs.map((DocumentSnapshot document) {

                        return new DropdownMenuItem<String>(
                            value: document.data()['subcategory'],
                            child: new Container(
                              padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                              child: new Text(document.data()['subcategory'],style:TextStyle(color: Colors.black)),

                              //color: primaryColor,
                            )


                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );















        }















    );

  }





  Stream(getcategory) {


    if (category != 'All' ) {return Firestore.instance.collection('subCategory').where('CategoryName' , isEqualTo: getcategory).snapshots();}

    else if (category == 'All') return store.loadSubCat();




  }




}

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/Provider/modelhut.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geolocation;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_eapp/screens/User/AuthPhone.dart';

import 'home.dart';


User loggeduser ;
final auth = Auth();
final store = Store();
String username = ' Default';
String Email = 'default';
String phone = ' ';
String isemailver ;
String isphonever ;

String Photo  = 'https://www.attendit.net/images/easyblog_shared/July_2018/7-4-18/b2ap3_large_totw_network_profile_400.jpg';
String pincode = ' ';
String address = ' ';
File _image;

String _uploadedFileURL;

class UserInfo1 extends StatefulWidget {
  static String id = "userinfo";

  UserInfo1({Key key}) : super(key: key);
  String name;
  String email;
  String uemail;
  String uphone;
  String upin;
  String uaddress;
  String ulat;
  String ulong;
  String emailverified;
  String phoneverified;

  String uphoto = 'https://www.attendit.net/images/easyblog_shared/July_2018/7-4-18/b2ap3_large_totw_network_profile_400.jpg';
  _UserInfo1State createState() => _UserInfo1State();


}


class _UserInfo1State extends State<UserInfo1>  with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  String verifiationstatus="تأكيد؟";
  String phoneverifiationstatus="تأكيد؟";

  get name => widget.name;
  final FirebaseAuth fireauth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<FormState> globalKey = GlobalKey <FormState> ();




  @override
  void initState() {
    // TODO: implement initState
    fireauth.currentUser.reload();
    getData();
    super.initState();

    //   widget.name==username;


  }


  @override
  Widget build(BuildContext context) {


      return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(strokeWidth: 0.5 ,),
      inAsyncCall: Provider.of<Modelhut>(context).isLoading,
      child: new Scaffold(
          body: Form(
            key: globalKey,
            child: new Container(
              color: Colors.white,
              child: new ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      new Container(
                        height: 250.0,
                        color: Colors.white,
                        child: new Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 20.0, top: 20.0),
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).pushNamed(Home.id);

                                      },
                                      child: new Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.black,
                                        size: 22.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 25.0),
                                      child: new Text('Profile',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              fontFamily: 'sans-serif-light',
                                              color: Colors.black)),
                                    )
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: new Stack(fit: StackFit.loose, children: <
                                  Widget>[
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Container (
                                        width: 140.0,
                                        height: 140.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            image:


                                            NetworkImage( Photo) ,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 90.0, right: 100.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 25.0,
                                          child: GestureDetector(
                                            onTap: (){
                                              chooseFile();




                                            },
                                            child: new Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ]),
                            )



                          ],
                        ),
                      ),
                      new Container(

                        color: Color(0xffFFFFFF),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 25.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Parsonal Information',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _status
                                              ? _getEditIcon()
                                              : new Container(),
                                        ],
                                      )
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Name' ,

                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                            decoration:  InputDecoration(
                                              hintText: username,
                                              labelText: username,
                                            ),
                                            enabled: !_status,
                                            autofocus: !_status,
                                            // ignore: missing_return
                                            validator: (value) {
                                              if (value.isNotEmpty) {
                                                username = value;

                                              }
                                            }


                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Row(

                                            children: [
                                            Text(
                                              'Email ID '
                                              ,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),

                                              fireauth.currentUser.emailVerified != true ? GestureDetector(
                                                  onTap: (){
                                                   verifyemail(context);


                                                  },
                                                  child: Text( verifiationstatus= "تأكيد؟" ,style: TextStyle(color: Colors.red) ,)):


                                              Text(verifiationstatus= "مفعل", style: TextStyle(color: Colors.green))



                                          ],)



                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                            decoration:  InputDecoration(
                                                hintText: Email,
                                              labelText: Email,


                                            ),
                                            enabled: _status,


                                            // ignore: missing_return
                                            validator: (value) {
                                              if (value.isNotEmpty)  {
                                                Email = value;
                                                print(
                                                    'Email ' + value + Email);
                                              }
                                            }


                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Row(

                                            children: [
                                              Text(
                                                'Phone '
                                                ,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold),
                                              ),

                                              fireauth.currentUser.phoneNumber == null ? GestureDetector(
                                                  onTap: (){
                                                    Navigator.pushNamed(context, AuthPhone.id);


                                                  },
                                                  child: Text( phoneverifiationstatus= "تأكيد؟" ,style: TextStyle(color: Colors.red) ,)):


                                              Text(phoneverifiationstatus= "مؤكد", style: TextStyle(color: Colors.green))



                                            ],)
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                            decoration:  InputDecoration(
                                                hintText: phone,
                                              labelText: phone,

                                            ),
                                            enabled: fireauth.currentUser.phoneNumber == null ? !_status : false,
                                            // ignore: missing_return
                                            validator: (value) {
                                              if (value.isNotEmpty)  {
                                                phone = value;
                                                print(
                                                    'Phone ' + value + phone);
                                              }
                                            }

                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: new Text(
                                            'Area Code',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: new Text(
                                            'Address',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: new TextFormField(
                                              decoration:  InputDecoration(
                                                  hintText: pincode,
                                                labelText: pincode,

                                              ),
                                              enabled: !_status,
                                              // ignore: missing_return
                                              validator: (value) {
                                                if (value.isNotEmpty)  {
                                                  pincode = value;
                                                  print(
                                                      'Pin ' + value + pincode);
                                                }
                                              }
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                      Flexible(
                                        child: new TextFormField(
                                            decoration:  InputDecoration(
                                              suffixIcon: GestureDetector(
                                                  onTap: () async {
                                                  var place =  await getlocationpermession();
                                                 address = place ;
                                                 setState(() {
                                                   address;
                                                 });

                                                  },
                                                  child: Icon(Icons.add_location, color: Colors.green,)),
                                                hintText: address,
                                              labelText: address,

                                            ),
                                            enabled: !_status,
                                            // ignore: missing_return
                                            validator: (value) {
                                              if (value.isNotEmpty)  {
                                                address = value;
                                                print(
                                                    'Address ' + value + address);
                                              }
                                            }
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  )),
                              !_status ? _getActionButtons() : new Container(),
                            ],


                          ),
                        ),
                      ),
                Container(
                    padding: EdgeInsets.only(left: 20.0, right: 10.0),
                    height: 200,
                    width: 500,
                    child: Text("Chosen address : " + address)),



                    ],



                  ),
                ],
              ),
            ),
          )),
    );
  }


  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () async {

                      setState(() {
                        validate(context);

                        _status = true;
                        // validate(context);

                        FocusScope.of(context).requestFocus(new FocusNode());
                      });

                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                        globalKey.currentState.reset();
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }


  void validate(BuildContext context) {
    final model = Provider.of<Modelhut>(context, listen: false);

    model.changeisLoading(true);

    loggeduser = fireauth.currentUser;

    String uID = loggeduser.uid;


    if (globalKey.currentState.validate()) {
      globalKey.currentState.save();
      {
        firestore.collection('Users').doc(uID).collection('Userdata')
            .doc(uID)
            .update(
            { 'uid': uID,
              'Email': Email,
              'name': username,
              'FirstTime' : 'No',
              'AreaCode' : pincode,
              'Address' : address,
              'Phone' : phone,
              'long': widget.ulong,
              'lat' : widget.ulat

            }

        ).then((value) =>

            model.changeisLoading(false)

    );
      }
    }

    if (Email != null)
      fireauth.currentUser.updateEmail(Email);

setState(() {

});
  }



  Future uploadFile() async {






    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd-hh-mm-ss');
    String formattedDate = formatter.format(now);
    loggeduser = fireauth.currentUser;

    String uID = loggeduser.uid;

    final model = Provider.of<Modelhut>(context, listen: false);
    model.changeisLoading(true);

    Reference storageReference = FirebaseStorage.instance
        .ref('UserProfile')
        .child(formattedDate+' img');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() =>  model.changeisLoading(false)

    );


    storageReference.getDownloadURL().then((fileURL) async {
      setState(() {
        _uploadedFileURL = fileURL;
      });

      if (globalKey.currentState.validate()) {
        globalKey.currentState.save();
        {
          firestore.collection('Users').doc(uID).collection('Userdata')
              .doc(uID).update(  {
            'photo' : _uploadedFileURL


          }).then((value) =>

              model.changeisLoading(false)

      );




        }
      }


    });

setState(() {

});

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

  Future<dynamic> getData() async {
    loggeduser = fireauth.currentUser;
    final SharedPreferences prefs = await _prefs;

    String UID = loggeduser.uid;

    final DocumentReference document = Firestore.instance.collection('Users')
        .doc(UID).collection('Userdata')
        .doc(UID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        widget.name = snapshot.get('name').toString();
        widget.email = snapshot.get('Email').toString();
        widget.uaddress = snapshot.get('Address').toString();
        widget.uphone = snapshot.get('Phone').toString();
        widget.upin = snapshot.get('AreaCode').toString();
        widget.uphoto = snapshot.get('photo').toString();
        widget.emailverified = snapshot.get("emailverified").toString();
        widget.phoneverified = snapshot.get("phoneverified").toString() != null ? snapshot.get("phoneverified").toString() : "No";



      });
    }). whenComplete(() =>

        prefs.setString("username", widget.name).whenComplete(() =>
            prefs.setString('Email', widget.email).whenComplete(() =>


                print('done')

            ))

    );

    username = widget.name;
    Email = widget.email;
    address = widget.uaddress;
    phone = widget.uphone;
    pincode = widget.upin;
    Photo = widget.uphoto;
    isemailver = widget.emailverified;
    isphonever = widget.phoneverified;
  }



  Future<dynamic> getlocationpermession() async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    handler.Permission.locationWhenInUse.request();


    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print('Not granted');

      if (_permissionGranted != PermissionStatus.granted) {
        _locationData = await location.getLocation();
      }
    }

    _locationData = await location.getLocation();
    List<geolocation.Placemark> placemarks = await geolocation.placemarkFromCoordinates(_locationData.latitude, _locationData.longitude);


    var place =await  placemarks[0].country.toString()+
        ' '+"   Administrative area "+ placemarks[0].administrativeArea+"  Subadministrative area "+ placemarks[0].subAdministrativeArea
        + ' Street  '+ placemarks[0].street.toString();

  //  print ("StrretName : "+placemarks.toString());
 getlat().then((value) => getlong().then((value) => print('gottern both'))

 );


    return place;

  }



  Future<dynamic> getlong() async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    handler.Permission.locationWhenInUse.request();


    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print('Not granted');

      if (_permissionGranted != PermissionStatus.granted) {
        _locationData = await location.getLocation();
        double long = await _locationData.longitude;

      }
    }

    _locationData = await location.getLocation();
    double long = await _locationData.longitude;
widget.ulong = long.toString();
    return long;

  }
  Future<dynamic> getlat() async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    handler.Permission.locationWhenInUse.request();


    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print('Not granted');

      if (_permissionGranted != PermissionStatus.granted) {
        _locationData = await location.getLocation();
        double lat = await _locationData.latitude;
        widget.ulat = lat.toString();

      }
    }

    _locationData = await location.getLocation();

    double lat = await _locationData.latitude;
    widget.ulat = lat.toString();

    return lat;

  }



  verifyemail(BuildContext context) {
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
          color: klight
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
     // type: AlertType.info,
      title: "ارسال ايميل التفعيل؟",
    //  desc:desc,
      buttons: [
        DialogButton(
            child: Text(
              "رجوع",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: kdark
        ),
        DialogButton(
            child: Text(
              "ارسال؟",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {

            fireauth.currentUser.sendEmailVerification().then((value) =>

                Fluttertoast.showToast(
                    msg: "تم ارسال ايميل التأكيد",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 10.0
                ).then((value) => Navigator.pop(context))

            );

            },
            color: kdark
        ),

      ],
    ).show();
  }



}




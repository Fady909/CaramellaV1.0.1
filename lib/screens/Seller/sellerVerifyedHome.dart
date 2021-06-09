import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/screens/Seller/SellerReports.dart';
import 'package:flutter_eapp/screens/Seller/sellerInsertProducts.dart';
import 'package:flutter_eapp/screens/Seller/sellerOrders.dart';
import 'package:flutter_eapp/screens/Seller/sellerprofile.dart';
import 'package:flutter_eapp/screens/User/loginsccreen.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:flutter_eapp/utils/navigator.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';


class ShowHome extends StatefulWidget {
  static String id = "SellerVerifyiedHome";

  var instocknum = TextEditingController();

  @override
  _ShowHomeState createState() => _ShowHomeState();
}

class _ShowHomeState extends State<ShowHome> {
  var store = Store();
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();

  final FirebaseAuth fireauth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  User loggedSeller;

  String Address = '';
  String User_email='';
  String Phone='';
  String Store_name='';
  String Store_product='';
  String User_name='';
  String User_Image='';
String mainuID ;

  String token;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey1,
      appBar: buildAppBar(context),
      drawer: Drawer(child: leftDrawerMenu(context)),
body: StreamBuilder<QuerySnapshot>(
    stream: store.loadproductsspecifyu(mainuID),
    // ignore: missing_return
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Product> products = [];

        for (var doc in snapshot.data.docs) {
          var data = doc.data();
          products.add(Product(
              doc.id,
              data[kProductName],
              data[kProductPrice],
              data[kProductDescription],
              data[kProductCategory],
              data[kproductImage],null,null,

              data['Product Discount']

              ,null,null,
              sellername: data[ksellername],
              sellershop: data[kshopname],
              colors: List.from(data['Colors'])


            // ignore: missing_return

          ));
        }

        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0.5,
                crossAxisSpacing: 2,
                childAspectRatio: 0.8),
            itemBuilder: ((context, index) => Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GestureDetector(
                onTapUp: (details) {
                  double dx =
                      details.globalPosition.dx; // where from left
                  double dy =
                      details.globalPosition.dy; // where from top
                  double dz = MediaQuery.of(context).size.width -
                      dx; // where from right
                  double db = MediaQuery.of(context).size.height -
                      dy; // where from right

                  showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(dx, dy, dz, db),
                      items: [

                        MyPopUpMenuItem(
                          child: Text('حذف المنتج'),
                          onClick: () {
                            store.deletproduct(products[index].pID);
                            Navigator.pop(context);
                          },
                        ),
                        MyPopUpMenuItem(
                          child: Text('تغيير عدد الموجود بالمخزن'),
                          onClick: () {

                            _emptyalert(context,products[index].pID);

                          },
                        ),
                        MyPopUpMenuItem(
                          child: Text('إالغاء'),
                          onClick: () {
                            Navigator.pop(context);

                          },
                        ),


                      ]);
                },
                child: Card(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                ],
                                stops: [
                                  0.0,
                                  0.8
                                ])),
                        child: Column(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.network(
                                    products[index].Productimage,
                                    // width: 310,
                                    height: 150,
                                    fit: BoxFit.contain,
                                  ),

                                  Text(
                                    products[index].Productname,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Text(
                                   'Price  :' + products[index].Productprice,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 10),
                                  ),
                                  products[index].productDiscount == ''?
                                  Text('')
                                  :Text(
                                    'Discount Value  :' +   products[index].productDiscount + ' %',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 10),
                                  ),

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
            )),
            itemCount: products.length);
      } else {
        return Center(child: Text('Loading ...'));
      }
      ;
    }),

    );


  }

  @override
  void initState() {
    getData();
    super.initState();
    final fcm = FirebaseMessaging();
    fcm.requestNotificationPermissions();
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        showDialog(
          context: context,
          builder: (context) =>  AlertDialog(
            content: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 3.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
              ),
              height: 120,
              child: Column(
                children: [
                  Icon(Icons.notification_important,size: 50, color: klight,),

                  Text(message['notification']['title']),

                  Text(message['notification']['body']),

                ],

              ),
            ),

          ),
        );








      },
      onLaunch: (Map<String, dynamic> message) async {
        AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 3.0
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //                 <--- border radius here
              ),
            ),
            height: 120,
            child: Column(
              children: [
                Icon(Icons.notification_important,size: 50, color: klight,),

                Text(message['notification']['title']),

                Text(message['notification']['body']),

              ],

            ),
          ),

        );
      },
      onResume: (Map<String, dynamic> message) async {
        AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 3.0
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //                 <--- border radius here
              ),
            ),
            height: 120,
            child: Column(
              children: [
                Icon(Icons.notification_important,size: 50, color: klight,),

                Text(message['notification']['title']),

                Text(message['notification']['body']),

              ],

            ),
          ),

        );
      },
    );






  }

  Future<dynamic> getData() async {

    final FirebaseMessaging  firebaseMessaging = FirebaseMessaging();


    firebaseMessaging.getToken().then((token1) {
      print(token1);
      token =  token1;

      // Print the Token in Console
    });



    loggedSeller = fireauth.currentUser;
    String UID = loggedSeller.uid;
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
        mainuID = UID;

      });
    })
        .then((value) =>

        document.update({
          'token' : token })




    );



  }

  leftDrawerMenu(BuildContext context) {

    Color blackColor = Colors.black.withOpacity(0.8);
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            height: 175,
            child: DrawerHeader(
              child: ListTile(
                trailing: Icon(
                  Icons.chevron_right,
                  size: 30,
                ),
                subtitle: GestureDetector(
                  onTap: () {},
                  child: GestureDetector(
                    child: Text(
                      "تفقد منتجاتك",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: blackColor),
                    )    ,

                    onTap: () {
                    },

                  ),
                ),
                title: Text(
                  User_name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: blackColor),
                ),
                leading: CircleAvatar(
                  backgroundImage:


                  NetworkImage(
                      User_Image)
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF8FAFB),
              ),
            ),
          ),


          ListTile(
            leading:
            Icon(Icons.delivery_dining, color: blackColor),
            title: Text('الطلبات',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: blackColor)),
            onTap: () {
              Nav.route(context, SellerOrders());
            },
          ),
          ListTile(
            leading:
            Icon(Icons.add_to_photos_rounded, color: blackColor),
            title: Text('اضافه منتج',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: blackColor)),
            onTap: () {
              Nav.route(context, SellerInsert());
            },
          ),
          ListTile(
            leading:
            Icon(Icons.report_sharp, color: blackColor),
            title: Text('تقارير البيع',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: blackColor)),
            onTap: () {
              Nav.route(context, SellerReportsforseller());


            },
          ),
          ListTile(
            leading: Icon(Feather.settings, color: blackColor),
            title: Text('الاعدادات',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: blackColor)),
            onTap: () {

              Navigator.of(context).pushNamed(SellerProfile.id);

            },
          ),
          ListTile(
            leading: Icon(Feather.x_circle, color: blackColor),
            title: Text('تسجيل خروج',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: blackColor)),
            onTap: () async {
              FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('selleremail');
              prefs.remove('sellerpassword');
              Navigator.of(context).pushReplacementNamed(LoginScreen.id);



              },
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {

    return AppBar(
      title: Text(
         Store_name,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),

      leading: new IconButton(
          icon: new Icon(FlutterIcons.account_settings_mco,
              color: Colors.black),
          onPressed: () =>    _scaffoldKey1.currentState.openDrawer()),

      backgroundColor: Colors.white,


    );

  }

  _emptyalert(BuildContext context , productid) {
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
     // type: AlertType.success,
      title: "",
      desc:"تغيير العدد الموجود بالمخزن",
      content: Column(children: [
        Container(
          height: 100,
          child: Theme(
            data: new ThemeData(
              primaryColor: klight,
              primaryColorDark: kdark,
            ),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextField(
                            controller: widget.instocknum,

                            decoration: InputDecoration(

                              border: OutlineInputBorder(

                                borderSide: BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: klight,

                                ),
                              ),
                              labelText: 'ادخل العدد الموجود لديك',
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(fontSize: 20.0, color: klight),


                            ))))),
          ),
        ),

      ],),
      buttons: [
        DialogButton(
            child: Text(
              "إلغاء",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);

            },
            color:Colors.black26
        ),
        DialogButton(
            child: Text(
              "موافق",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
store.editproduct({"instock" : int.parse(widget.instocknum.text)}, productid);
widget.instocknum.clear();
Navigator.pop(context);

            },
            color: kdark
        ),

      ],
    ).show();
  }


}


class MyPopUpMenuItem<T> extends PopupMenuItem<T> {
  final Widget child;
  final Function onClick;
  MyPopUpMenuItem({@required this.child, @required this.onClick})
      : super(child: child);
  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopUpMenuItemState();
  }
}

class MyPopUpMenuItemState<T, PopupMenuItem>
    extends PopupMenuItemState<T, MyPopUpMenuItem<T>> {
  @override
  void handleTap() {
    widget.onClick();
  }
}
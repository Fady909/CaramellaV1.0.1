import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geolocation;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

final FirebaseAuth fireauth1 = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class Checkout extends StatefulWidget {
  static String id = "checkout";
  User loggeduser;
  final auth = Auth();
  var couponname = TextEditingController();

  final store = Store();
  bool isButtonDisabled = true;
  var totalProce;
  String username = ' Default';
  String Email = 'default';
  String phone = ' ';
  String Photo =
      'https://www.attendit.net/images/easyblog_shared/July_2018/7-4-18/b2ap3_large_totw_network_profile_400.jpg';
  String pincode = ' ';
  String address = 'Not Set';

  String token;

  Checkout([this.totalProce]);

  @override
  _CheckoutState createState() => _CheckoutState();

  String name;
  String email;
  String uemail;
  String uphone;
  String uaddress;
  String ulat;
  String ulong;
}

class _CheckoutState extends State<Checkout> {
  @override
  final store = Store();

  var s;
  int productlength = 0;
  double eachitemprice = 0;
  List<int> shoppingCartCount = List();

  String UID;
  bool data = false;
  bool isvisable = true;
  var coupontext = " لا يوجد كوبون مفعل";
  var showofferdone = true;

  var couponColor = Colors.red;

  double totalProce = 0;

  Widget build(BuildContext context) {
    getData();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الدفع',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.ios_arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: SingleChildScrollView(
                child: buildShoppingCartItem(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 12.0, left: 12.0, right: 12.0, bottom: 12.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 6.0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Center(
                            child:
                                Text("  الاجمالي  :   ${widget.totalProce}")),
                        SizedBox(
                          height: 10,
                        ),

                        Text("عنوان التوصيل"),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: Color(0xFFE7F9F5),
                            border: Border.all(
                              color: Color(0xFF4CD7A5),
                            ),
                          ),
                          child: ListTile(
                            trailing: Icon(
                              widget.address != 'Not Set'
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: widget.address != 'Not Set'
                                  ? Color(0xFF4CD7A5)
                                  : Colors.red,
                            ),
                            title: Text('العنوان'),
                            subtitle: Text(widget.address),
                          ),
                        ),
                        Text("طريقه الدفع"),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: Color(0xFFE7F9F5),
                            border: Border.all(
                              color: Color(0xFF4CD7A5),
                            ),
                          ),
                          child: ListTile(
                            trailing: Icon(
                              Icons.check_circle,
                              color: Color(0xFF10CA88),
                            ),
                            leading: Icon(
                              Icons.home_outlined,
                              color: Color(0xFF10CA88),
                            ),
                            title: Text('الدفع عند الاستلام'),
                          ),
                        ),
                        Text("الرقم أو الأيميل مؤكد؟"),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                            color:
                            fireauth1.currentUser.phoneNumber != null  || fireauth1.currentUser.emailVerified ?
                            Color(0xFFE7F9F5): Colors.red,
                            border: Border.all(
                              color: Color(0xFF4CD7A5),
                            ),
                          ),
                          child: ListTile(
                            trailing: Icon(
                              fireauth1.currentUser.phoneNumber != null  || fireauth1.currentUser.emailVerified ?


                              Icons.check_circle  : Icons.not_interested,
                              color: Color(0xFF10CA88),

                            ),
                            leading: Icon(



                              Icons.verified,
                              color: Color(0xFF10CA88),
                            ),
                            title:



                            Text(
                                fireauth1.currentUser.phoneNumber != null  || fireauth1.currentUser.emailVerified ?

                                'الحساب مفعل'  : "من فضلك قم بالتفعيل أما عن طريق الهاتف أو الأيميل" ),
                          ),
                        ),




                        // Container(
                        //   margin: EdgeInsets.symmetric(vertical: 12.0),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        //     color: Color(0xFFF5F8FB),
                        //   ),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       print('Paypal');
                        //     },
                        //     child: ListTile(
                        //       leading: Icon(
                        //         Icons.card_membership,
                        //         color: Colors.black54,
                        //       ),
                        //       title: Text('بايبال'),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          margin: EdgeInsets.only(top: 24.0),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            color: widget.address != 'Not Set'
                                ? Color(0xFFF93963)
                                : Colors.grey,
                            onPressed: () => {
                              if (widget.isButtonDisabled == false && fireauth1.currentUser.phoneNumber != null || fireauth1.currentUser.emailVerified )
                                {
                                  addorder()
                                      .then((value) => clearCart(context))
                                      .then((value) => Fluttertoast.showToast(
                                              msg: "تم الطلب بنجاح",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: kdark,
                                              textColor: Colors.white,
                                              fontSize: 16.0)
                                          .then((value) =>
                                              Navigator.pushReplacementNamed(
                                                  context, Home.id))),
                                }
                              else if (widget.isButtonDisabled = true)
                                {

                                Fluttertoast.showToast(
                                msg: "من فضلك حدث بياناتك أولاً",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: kdark,
                                textColor: Colors.white,
                                fontSize: 16.0)



                                



                                }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "قم بالدفع",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: isvisable,
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15, top: 5),
                                              child: TextField(
                                                  controller: widget.couponname,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 2,
                                                        style:
                                                            BorderStyle.solid,
                                                        color: klight,
                                                      ),
                                                    ),
                                                    labelText: 'اسم الكوبون',
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    hintStyle: TextStyle(
                                                        fontSize: 20.0,
                                                        color: klight),
                                                  ))))),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    getdiscount(widget.couponname.text);
                                  },
                                  child: Center(child: Text('احصل علي الخصم'))),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: showofferdone,
                            child: Text(
                              coupontext,
                              style: TextStyle(color: couponColor),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  @override
  void initState() {}

  Future<dynamic> getData() async {
    widget.loggeduser = fireauth1.currentUser;
    final SharedPreferences prefs = await _prefs;

    UID = widget.loggeduser.uid;

    final DocumentReference document = Firestore.instance
        .collection('Users')
        .doc(UID)
        .collection('Userdata')
        .doc(UID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        widget.name = snapshot.get('name').toString();
        widget.email = snapshot.get('Email').toString();
        widget.uaddress = snapshot.get('Address').toString();
        widget.uphone = snapshot.get('Phone').toString();
        widget.ulat = snapshot.get("lat").toString()!= null ? snapshot.get("lat").toString() : null;
        widget.ulong = snapshot.get('long').toString()!= null ? snapshot.get('long').toString() : null;;
        widget.token = snapshot.get('token').toString();
      });
    }).whenComplete(() => prefs
        .setString("username", widget.name)
        .whenComplete(() => prefs.setString('Email', widget.email)));

    widget.username = widget.name;
    widget.Email = widget.email;
    widget.address = widget.uaddress;
    widget.phone = widget.uphone;

    if (widget.address == 'Not Set') widget.isButtonDisabled = true;
    if (widget.address != 'Not Set') {
      widget.isButtonDisabled = false;
    }
  }

  Future<dynamic> addorder() async {
    widget.loggeduser = fireauth1.currentUser;
    String UID2 = widget.loggeduser.uid;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(UID2)
        .collection('CartItems')
        .get()
        .then((QuerySnapshot snapShot) async {
      snapShot.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('Orders')
            .doc(element.id)
            .set(element.data())
            .then((value) => secoundQuery());
      });
    });

    await FirebaseFirestore.instance
        .collection('UserReports')
        .doc(UID2)
        .get()
        .then((value) => s = value.get("AskedOrders"))
        .then((value) => FirebaseFirestore.instance
            .collection('UserReports')
            .doc(UID2)
            .update({"AskedOrders": s + 1}))
        .then((value) => store.managepoints(UID2, 10));
  }

  secoundQuery() async {
    widget.loggeduser = fireauth1.currentUser;

    String UID3 = widget.loggeduser.uid;

    await FirebaseFirestore.instance
        .collection('Orders')
        .get()
        .then((QuerySnapshot snapShot) async {
      snapShot.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('Orders')
            .doc(element.id)
            .update({
          "lat": widget.ulat,
          "long": widget.ulong,
          'UID': UID3,
          'Pid': element.id,
          'CashperProduct': (widget.totalProce *
                  double.parse(element.get('amount').toString()))
              .toString(),
          'orderstate': 'Preparing',
          'Address': widget.uaddress,
          'Name': widget.name,
          'phone': widget.phone,
          "token": widget.token
        }).then((value) => store.callOnFcmApiSendPushNotifications(
                element.get('sellertoken'),
                "لديك منتج تم طلبه",
                "   ${element.get('sellername')} مبروك  "));
      });
    }).then((value) => firestore
            .collection('Users')
            .doc(UID3)
            .collection('CartItems')
            .doc()
            .delete());
  }

  getlocationpermession() async {
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
    List<geolocation.Placemark> placemarks =
        await geolocation.placemarkFromCoordinates(
            _locationData.latitude, _locationData.longitude);
    print("StrretName : " + placemarks.toString());
  }

  clearCart(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.loggeduser = fireauth1.currentUser;

    String UID2 = widget.loggeduser.uid;
    try {
      firestore
          .collection('Users')
          .doc(UID2)
          .collection('CartItems')
          .get()
          .then((value) => value.docs.forEach((element) {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(UID2)
                    .collection('CartItems')
                    .doc(element.id)
                    .delete();
              }));
    } catch (error) {
      print(error);
    }
  }

  void getdiscount(String coupon) {
    if (coupon.isNotEmpty == true && coupon != null) {
      String generalCouponName;
      FirebaseFirestore.instance
          .collection('Coupones')
          .doc('General')
          .get()
          .then((DocumentSnapshot) =>
              coupon == DocumentSnapshot.data()['Coupon'].toString()
                  ? checktakenandreload()
                  : checkpointscoupon());
    }
  }

  checktakenandreload() {
    String UID = widget.loggeduser.uid;

    var taken;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(UID)
        .collection("Userdata")
        .doc(UID)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data()['LastCoupon']
                    .toString() ==
                widget.couponname.text
            ? _emptyalert(context, "للأسف", "تم الإستفادة من هذا العرض من قبل ")
            : FirebaseFirestore.instance
                .collection('Coupones')
                .doc('General')
                .get()
                .then((DocumentSnapshot) => widget.totalProce =
                    widget.totalProce -
                        (widget.totalProce *
                            (DocumentSnapshot.data()['DiscountValue'] / 100)))
                .then((value) => FirebaseFirestore.instance
                    .collection('Users')
                    .doc(UID)
                    .collection("Userdata")
                    .doc(UID)
                    .update({"LastCoupon": widget.couponname.text}))
                .then((value) => setState(() {
                      isvisable = false;
                      showofferdone = true;
                      coupontext = "تم تفعيل الكوبون";
                      couponColor = Colors.green;
                    })));
  }

  checkpointscoupon() {
    String UID = widget.loggeduser.uid;

    var taken;

    firestore
        .collection("Users")
        .doc(UID)
        .collection("Coupones")
        .get()
        .then((snapShot) async {
      snapShot.documents.forEach((doc) {
        if (doc.data()["Coupon"].toString() == widget.couponname.text &&
            doc.data()["taken?"].toString() == "No") {
          var dataID = doc.data()["which"].toString();
          widget.totalProce = widget.totalProce -
              (widget.totalProce * (doc.data()["DiscountValue"] / 100));
          firestore
              .collection("Users")
              .doc(UID)
              .collection("Coupones")
              .doc(dataID)
              .update({"taken?": "Yes"}).then(
            (value) => coupontext = "تم تفعيل الكوبون",
          );
          setState(() {
            showofferdone = true;
            couponColor = Colors.green;
            isvisable = false;
          });
        }

        if (doc.data()["Coupon"].toString() != widget.couponname.text ||
            doc.data()["taken?"].toString() == "Yes") {
          showofferdone = true;
          isvisable = true;
          coupontext = 'الكوبون غير صالح';
        }
      });
    });

    setState(() {});
  }

  _emptyalert(BuildContext context, title, desc) {
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
      titleStyle: TextStyle(color: klight),
    );
    Alert(
      context: context,
      style: alertStyle,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
            child: Text(
              "موافق",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: kdark),
      ],
    ).show();
  }

  buildShoppingCartItem() {
    var h = MediaQuery.of(context).size.height * 0.7;

    gettotalprice(List<Product> products, int index) {
      totalProce = 0;

      for (var Product in products) {
        totalProce = totalProce +
            double.parse(Product.productAfterSale) * (Product.amount);
      }
      return totalProce;
    }

    ;

    return Container(
      padding: EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
      height: h,
      child: StreamBuilder<QuerySnapshot>(
          stream: store.loadcartitems(UID),

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
                    data[kproductImage],
                    null,
                    data['product after discount'],
                    data[kProductdiscount],
                    null,
                    data['instock'],
                    amount: data[kproductamountneeded],
                    colors: data['colors'] != null ? data['colors'] : []));
              }

              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    productlength = products.length;
                    if (shoppingCartCount.length < products.length) {
                      shoppingCartCount.add(1);
                    }

                    eachitemprice =
                        double.parse(products[index].productAfterSale) *
                            shoppingCartCount[index];

                    gettotalprice(products, index);

                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: (MediaQuery.of(context).size.width) / 3.5,
                            child: Column(
                              children: <Widget>[
                                Image.network(products[index].Productimage),

                              ],
                            ),
                          ),
                          Container(
                            width:
                                (MediaQuery.of(context).size.width - 37) / 1.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      width: MediaQuery.of(context).size.width/2,
                                      child: Text(
                                        products[index].Productname.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[



                                      Row(children: [

                                        Text('دينار اردني '),
                                        Text(
                                          "    "+eachitemprice.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),




                                      ],),




                  Center (

                                        child: Text(
                                          " " +
                                              products[index].amount.toString()
                                          +"   :  العدد  "
                                          ,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),






                                      ),


                                      Center(
                                          child: products[index].colors.length == 0
                                              ? Container()
                                              : Text('الألوان المطلوبة')),
                                      Container(
                                        height: products[index].colors.length == 0
                                            ? 0
                                            : products[index].colors.length <= 4
                                            ? 100
                                            : 150,
                                        child: GridView.builder(
                                            physics:
                                            products[index].colors.length <= 4
                                                ? NeverScrollableScrollPhysics()
                                                : null,
                                            gridDelegate:
                                            new SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 2,
                                              crossAxisSpacing: 2,
                                              crossAxisCount: 6,
                                              childAspectRatio: 1,
                                            ),
                                            itemCount: products[index].colors.length,
                                            itemBuilder: (BuildContext context,
                                                int colorindex) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    height: 100,
                                                    width: 50,
                                                    child: Card(
                                                      color: Color(int.parse(
                                                          products[index]
                                                              .colors[colorindex])),
                                                      child: Text(''),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else
              return (Text('Loading...'));
          }),
    );
  }
}

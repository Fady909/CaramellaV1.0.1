import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/models/Orders.dart';
import 'package:flutter_eapp/screens/User/home.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class UserOrders extends StatefulWidget {
  static String id = 'UserOrders';

  @override
  _UserOrdersState createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  var store = Store();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth fireauth = FirebaseAuth.instance;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  User loggeduser;

  var s;

  int activeStep = 0;
  int dotCount = 5;

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Center(
          child: Text(
            "طلباتي",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.ios_arrow_back,
              color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacementNamed(Home.id),
        ),
        backgroundColor: kdark,


      ),
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: store.loadOrders(fireauth.currentUser.uid),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Text("لا يوجد طلبات بعد"),
                    );
                  } else
                    print('has');
                  List<Orders> orders = [];
                  for (var doc in snapshot.data.docs) {
                    var data = doc.data();
                    orders.add(Orders(
                      CashPerProduct: data['CashperProduct'],
                      Pid: data['Pid'],
                      Product_Category: data['Product Categroy'],
                      ProductDescription: data['Product Description'],
                      ProductDiscount: data['Product Discount'],
                      Product_Image: data['Product Image'],
                      Product_Name: data['Product Name'],
                      Product_Price: data['Product Price'],
                      UID: data['UID'],
                      // amount: data['amount'],
                      Orderstate: data['orderstate'],
                      Product_after_discount: data['product after discount'],
                      sellerID: data['sellerID'],
                      sellername: data['sellername'],
                      sellershop: data['sellershop'],
                    ));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            textDirection: TextDirection.rtl,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(width: 20,),
                                Text(orders[index].sellershop),
                                SizedBox(width: 20,),
                                Text("  :  اسم المتجر  "),
                                  SizedBox(width: 20,),
                              ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(width: 20,),
                                  Text(orders[index].Product_Name.toString()),
                                  SizedBox(width: 20,),
                                  Text("  : اسم المنتج  "),
                                  SizedBox(width: 20,),
                                ],),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("  دينار أردني  "),
                                  SizedBox(width: 10,),
                                  Text(orders[index].CashPerProduct),
                                  SizedBox(width: 20,),
                                  Text("  : السعر الاجمالي  "),
                                  SizedBox(width: 20,),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(width: 20,),
                                  Text(orders[index].Orderstate == "Preparing" ?  "تحت التحضير" : orders[index].Orderstate),
                                  SizedBox(width: 20,),
                                  Text("  : حاله الطلب  "),
                                  SizedBox(width: 20,),
                                ],),
                              Card(
                                color: Colors.red,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: GestureDetector(
                                        onTap: () async {
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
                                              color: Colors.red,
                                            ),
                                          );
                                          Alert(
                                            context: context,
                                            style: alertStyle,
                                            type: AlertType.warning,
                                            title: "إلغاء الطلب؟",
                                            desc: "هل أنت متأكد من إلغاء الطلب؟",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "الرجوع",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                onPressed: () => Navigator.pop(context),
                                                color: Color.fromRGBO(0, 179, 134, 1.0),
                                              ),
                                              DialogButton(
                                                child: Text(
                                                  "إلغاء الطلب",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                onPressed: () {

                                               CancelOrder(orders[index]);
                                               Navigator.pop(context);


                                                },
                                                color: Colors.red,
                                              ),
                                            ],
                                          ).show();



                                        },
                                        child: Text('إلغاء الطلب')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Loading ...'));
                }
                ;
              }),
        ),
      ),
    );
  }

  void CancelOrder(Orders orders) {
    FirebaseFirestore.instance
        .collection("Orders")
        .where("UID",
        isEqualTo: orders.UID)
        .where("Pid",
        isEqualTo: orders.Pid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Orders")
            .doc(element.id)
            .delete()
            .then((value) {
          print("Success!");
        });
      });
    }).then((value) => FirebaseFirestore
        .instance
        .collection('UserReports')
        .doc(fireauth.currentUser.uid)
        .get()
        .then((value) => s =
        value.get("CancelledOrders"))
        .then((value) => FirebaseFirestore
        .instance
        .collection('UserReports')
        .doc(fireauth.currentUser.uid)
        .update(
        {"CancelledOrders": s + 1}))
        .then((value) => store.managepoints(
        fireauth.currentUser.uid, -15)));



  }




}



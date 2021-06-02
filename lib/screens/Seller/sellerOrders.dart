import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/models/Orders.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';


class SellerOrders  extends StatelessWidget {
  static String id = 'SellerOrders';
  var store = Store();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth fireauth = FirebaseAuth.instance;


  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  User loggedseller;

  var s;

  var c;

  var cashed;


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: store.loadsellerorders(fireauth.currentUser.uid),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length == 0){

                  return Center(
                    child: Text("لا يوجد طلبات بعد"),
                  );
                }

                else
                  print('has');
                List<Orders> orders = [];
                for (var doc in snapshot.data.docs) {var data = doc.data();
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
                    amount: data['amount'].toString(),
                    Orderstate: data['orderstate'],
                    Product_after_discount: data['product after discount'].toString(),
                    sellerID: data['sellerID'],
                    sellername: data['sellername'],
                    sellershop: data['sellershop'],
                    Uname:data['Name'],
                    Uaddress:  data['Address'],
                    Uphone:  data['phone'],
                    ulat: data['lat'],
                    ulong: data['long'],
                    token: data['token'],
                    colors: data['colors'] != null ? data['colors'] : []


                ) );}
                return    ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: orders.length,

                  itemBuilder: (context, index) {
                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      textDirection: TextDirection.rtl,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        AppBar(
                          leading: GestureDetector(
                              onTap: (){

                                showAlertDialog(context, orders[index]);


                              },
                              child: Icon(Icons.person)),
                          elevation: 0,
                          title: Text(orders[index].Uname),
                          backgroundColor:kdark,
                          centerTitle: true,

                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: TextFormField(

                            readOnly: true,
                            initialValue: orders[index].CashPerProduct,
                            decoration: InputDecoration(
                              labelText: "السعر الاجمالي",
                              //hintText: 'Enter your full name',
                              // icon: Icon(Icons.person),
                              isDense: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: orders[index].Product_Name,
                            decoration: InputDecoration(
                              labelText: 'اسم الطلب',
                              //   hintText: 'Enter your email',
                              // icon: Icon(Icons.email),
                              isDense: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: orders[index].Product_after_discount.toString(),
                            decoration: InputDecoration(
                              labelText: 'السعر للواحد',
                              //   hintText: 'Enter your email',
                              // icon: Icon(Icons.email),
                              isDense: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: orders[index].amount.toString(),
                            decoration: InputDecoration(
                              labelText: 'الكميه',
                              //   hintText: 'Enter your email',
                              // icon: Icon(Icons.email),
                              isDense: true,
                            ),
                          ),
                        ),

                            Center(child:
                            orders[index].colors.length ==0 ? Container():

                            Text('الألوان المطلوبة'))
                            ,
                            Container(
                            height: orders[index].colors.length ==0 ? 0 :  orders[index].colors.length <=4? 100 : 150  ,
                    child: GridView.builder(
                      physics: orders[index].colors.length <=4 ? NeverScrollableScrollPhysics() : null ,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    crossAxisCount: 6,
                    childAspectRatio: 1,
                    ),

                    itemCount: orders[index].colors.length,
                    itemBuilder: (BuildContext context, int colorindex) {

                    return   Stack(children: [


                    Container(
                    height: 100  , width: 50
                    ,

                    child: Card(

                    color: Color(int.parse(orders[index].colors[colorindex]))
                    , child: Text(''),
                    ),

                    ),

                    ],);


                    }

                    ),
                    )
                        ,


                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: orders[index].Orderstate,
                            decoration: InputDecoration(
                              labelText: 'حاله الطلب',
                              //   hintText: 'Enter your email',
                              // icon: Icon(Icons.email),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    );

                  },
                );
              } else {
                return Center(child:

                Text('Loading ...'));
              }
              ;
            }),
      ),
    );
  }








  showAlertDialog(BuildContext context, Orders order) {
    // set up the button

    Widget chg1 = FlatButton(
      child: Text("يتم التحضير"),
      onPressed: () {
        firestore.collection('Orders').doc(order.Pid).update({'orderstate' : "يتم التحضير"}).then((value) =>
            Navigator.of(context).pop()


        );      },
    );
    Widget chg2 = FlatButton(
      child: Text("في الطريق"),
      onPressed: () {

        firestore.collection('Orders').doc(order.Pid).update({'orderstate' : 'في الطريق'}).then((value) =>

            store.callOnFcmApiSendPushNotifications(order.token, " في الطريق إليك", " طلبك  في الطريق ${order.Uname} مرحبا  ")
        ).then((value) =>
            Navigator.of(context).pop()


        );


      },
    );
    Widget okButton = FlatButton(
      child: Text("اغلاق"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget chg3 = FlatButton(
      child: Text("تم التوصيل"),
      onPressed: () {
        int x;
        firestore.collection('Orders').doc(order.Pid).delete().then((value) =>
            FirebaseFirestore.instance
                .collection('UserReports')
                .doc(order.UID).get().then((value) =>
            s = value.get("CompletedOrders")
            ).then((value) =>
                FirebaseFirestore.instance
                    .collection('UserReports')
                    .doc(order.UID).update({
                  "CompletedOrders": s + 1
                })
            ).then((value) =>
                FirebaseFirestore.instance
                    .collection('SellerReports')
                    .doc(order.sellerID).get().then((value) =>
                c = value.get("ProductsSold")
                ).then((value) =>
                    FirebaseFirestore.instance
                        .collection('SellerReports')
                        .doc(order.sellerID).update({
                      "ProductsSold" : c +1 ,
                    })
                ).then((value) async =>

                await store.callOnFcmApiSendPushNotifications(order.token, " تم التوصيل", " طلبك تم توصيلة بنجاح ${order.Uname} مرحبا  ")
                )


            ).then((value) => Navigator.pop(context))).then((value) =>

            FirebaseFirestore.instance
                .collection('SellerReports')
                .doc(order.sellerID).collection("CashReports").doc().set({


              "pID" : order.Pid ,
              "sID" : order.sellerID,
              "Cash" : order.CashPerProduct ,
              "TimeOrdered" : DateTime.now()



            })


        );



      },
    );

    Widget openmap = FlatButton(
      child: Text("افتح في الخريطه"),
      onPressed: () {

        double lat = double.parse(order.ulat);
        double long = double.parse(order.ulong);
        try {
          MapUtils.openMap(lat, long);
        }catch(e){
          print(e.toString());

        }







      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Contact Info"),
      content: Container(
        height: 200,
        child: Column(children: [
          Text(order.Uname+"   :الاسم :"),
          Text(order.Uaddress+"  :العنوان :"),
          Text(order.Uphone+"رقم الاتصال :"),
          Text(order.CashPerProduct+"  :القيمه التحصليله :"),



        ],),
      ),
      actions: [

        chg1,
        chg2,
        okButton,
        openmap,
        chg3      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _alert(BuildContext context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 200),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.black,
      ),
    );
    Alert(

      context: context,
      style: alertStyle,
      type: AlertType.info,

      title: "Contact Info",
      desc: "Your product has been added to cart.",
      buttons: [
        DialogButton(
          child: Text(
            "BACK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: kdark,
        ),

      ],
    ).show();
  }








}
class MapUtils {



  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      print("لا يمكن فتح الخريطه ");
    }
  }


}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/models/Sellers.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants.dart';

class AdminSellerAprove extends StatefulWidget {
  static String id = 'AdminSellerApprove';
  var store = Store();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  _AdminSellerAproveState createState() => _AdminSellerAproveState();
}

class _AdminSellerAproveState extends State<AdminSellerAprove> {
  //List<UserForm> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: .0,
        title: Text('توثيق البائع' , style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          FlatButton(
            child: Text('رجوع'),
            textColor: Colors.black, onPressed: () {  },
           // onPressed: onSave,
          )
        ],
      ),
      body: Container(
        key: UniqueKey(),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey,
              Colors.blueAccent,
            ],
            begin: Alignment.center,
            end: Alignment.bottomLeft,
          ),
        ),


        child: Showsellers(),

      ),

    );
  }











  Widget  Showsellers() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: widget.store.loadnewsellers(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length == 0){

               return Center(
                  child: Text('لا يوجد بائعين جدد'),
                );
              }

              else
              print('has');
              List<Sellers> sellers = [];
              for (var doc in snapshot.data.docs) {var data = doc.data(); sellers.add(Sellers(
               isnew: data['IsNew'],
                sellername: data['Seller Name'],
                seller_email: data['Email'],
                verified: data['Verified'],
              shopname:data['Store Name'],
                starseller: data['StarSellers'],
                storeproducts: data['Store Products'],
                address:  data['Address'] ,
                phone:  data['Phone'],
   //             photo: data['photo'],
                uid: data['uid'],


                // ignore: missing_return
              ));}

              return    ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: sellers.length,
                itemBuilder: (context, index) {
                  return  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppBar(
                        leading: GestureDetector(
                            onTap: ()
                  {
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
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                      ),
                    );
                    Alert(
                      context: context,
                      style: alertStyle,
                      type: AlertType.warning,
                      title: "حذف؟",
                      desc: "هل أنت متأكد من حذف هذا البائع؟",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "رجوع",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {

                            Navigator.pop(context);
                            setState(() {

                            });
                          },
                          color: Colors.red,
                        ),
                        DialogButton(
                          child: Text(
                            "موافق",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            delet(sellers[index]);
                            Navigator.pop(context);
                            setState(() {

                            });
                          },
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                        ),

                      ],
                    ).show();
                  },


                            child: Icon(Icons.auto_delete)),
                        elevation: 0,
                        title: Text('بائع'),
                        backgroundColor: Colors.white24,
                        centerTitle: true,
                        actions: <Widget>[
                          GestureDetector(
                              onTap:(){
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
                                    color: Color.fromRGBO(0, 179, 134, 1.0),
                                  ),
                                );
                                Alert(
                                  context: context,
                                  style: alertStyle,
                                  type: AlertType.success,
                                  title: "توثيق؟",
                                  desc: "هل أنت متأكد من توثيق هذا البائع؟",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "رجوع",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {

                                        Navigator.pop(context);
                                        setState(() {

                                        });
                                      },
                                      color: Colors.red,
                                    ),
                                    DialogButton(
                                      child: Text(
                                        "موافق",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        Approve(sellers[index]);
                                        Navigator.pop(context);
                                        setState(() {

                                        });
                                        },
                                      color: Color.fromRGBO(0, 179, 134, 1.0),
                                    ),

                                  ],
                                ).show();



                              }


                              ,
                              child: Icon(Icons.verified , color: Colors.green,)),
                        //   onPressed: verify(sellers[index].seller_email),

                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].phone,
                          decoration: InputDecoration(
                            labelText: 'الاسم بالكامل',
                            hintText: 'Enter your full name',
                            icon: Icon(Icons.person),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].seller_email,
                          decoration: InputDecoration(
                            labelText: 'البريد الالكتروني',
                            hintText: 'Enter your email',
                            icon: Icon(Icons.email),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].address,
                          decoration: InputDecoration(
                            labelText: 'العنوان',
                           // hintText: 'Enter your email',
                            icon: Icon(Icons.email),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].phone,
                          decoration: InputDecoration(
                            labelText: 'رقم التليفون',
                            // hintText: 'Enter your email',
                            icon: Icon(Icons.phone),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].shopname,
                          decoration: InputDecoration(
                            labelText: 'اسم المتجر',
                            // hintText: 'Enter your email',
                            icon: Icon(Icons.shop),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].storeproducts,
                          decoration: InputDecoration(
                            labelText: 'منتجات المتجر',
                            // hintText: 'Enter your email',
                            icon: Icon(Icons.shopping_bag_outlined),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].starseller,
                          decoration: InputDecoration(
                            labelText: 'بائع متميز',
                            // hintText: 'Enter your email',
                            icon: Icon(Icons.star),
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
    );




  }

  void Approve(Sellers sellers) {
    widget.firestore.collection(ksellercollection).doc(sellers.uid).update({
      'Verified': 'Yes',
      "Storefollowers": 0,
      "banner":  "https://images.unsplash.com/32/Mc8kW4x9Q3aRR3RkP5Im_IMG_4417.jpg?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80"
     , "adminpercent" : 0.0
    }).then((value) =>

        widget. firestore.collection("SellerReports").doc(sellers.uid).set({
          ksellername: sellers.sellername,
          kselleremail: sellers.seller_email,
          "Phone": sellers.phone,
          "TotalProducts" : 0,
          "TotalCash" : 0 ,
          "ProductsSold" : 0 ,
          "LastProductSoldTime" : 0,
          "SellerID" : sellers.uid,
          "DateTime" : DateTime.now(),
          "adminpercent":0.0

        })

    );
    setState(() {

    });






  }
  void delet(Sellers sellers) {
    widget.firestore.collection(ksellercollection).doc(sellers.uid).delete();





  }



  _alert(BuildContext context, ttl ,des, fun) {
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
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: ttl,
      desc: des,
      buttons: [
        DialogButton(
          child: Text(
            "موافق",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {},
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),

      ],
    ).show();
  }





}

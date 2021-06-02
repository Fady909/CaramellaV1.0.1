import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/models/Sellers.dart';
import 'package:flutter_eapp/screens/User/Shops.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../constants.dart';

class FollowedStores extends StatelessWidget {
  static String id = 'favouritestores';


  @override
  Widget build(BuildContext context) {
    var mywidth = MediaQuery.of(context).size.width;
    var myheight = MediaQuery.of(context).size.height;
    double rectWidth = MediaQuery.of(context).size.width*0.250;
    double rectHeight = MediaQuery.of(context).size.width*.07;
    double trendCardWidth = MediaQuery.of(context).size.width*0.5;

    return  Scaffold(
        appBar: AppBar(

        title: Text(
        "المتاجر و مفضلتي",
        style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    leading: IconButton(
    icon: Icon(Ionicons.ios_arrow_back,
    color: Colors.black),
    onPressed: () => Navigator.pop(context),
    ),
    backgroundColor: kdark,


),
      body: Showallsellers(),
  );}}




Showallsellers() {
  var store = Store();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String UID;
  final FirebaseAuth fireauth = FirebaseAuth.instance;


  return SingleChildScrollView(
    child: Column(children: [
      SizedBox(height: 20),
    Text(" كل  المتاجر   ",
    textAlign: TextAlign.right,
    style: TextStyle(
    color: Colors.black,
    fontSize: 25,
    fontFamily: 'Tajawal',

    fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
    Container(
    child: StreamBuilder<QuerySnapshot>(
        stream: store.loadallsellers(),
    // ignore: missing_return
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    if (snapshot.data.docs.length == 0){

    return Center(
    child: Text('لا يوجد بائعين'),
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

    return    GridView.builder(
    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
    mainAxisSpacing: 2,
    crossAxisSpacing: 2,
    crossAxisCount: 2,
    childAspectRatio: 5,
    ),
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemCount: sellers.length,

    itemBuilder: (context, index) {
    return  GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                Shops(sellerShop :sellers[index].shopname, sellerID : sellers[index].uid),),);





      },
      child: Card(
      color: kdark,
      elevation: 20,
      child: Center(child: Text(sellers[index].shopname)),

      ),
    );

    },
    );
    } else {
    return Center(child:

    Text('Loading ...'));
    }

    }),
    ),
      SizedBox(height: 100),
      Text(" ----------------------------------------------------------  ",
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: 'Tajawal',

              fontWeight: FontWeight.bold)),
      Text(" متاجري المفضله   ",
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: 'Tajawal',

              fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: store.loadFavouriteshops(fireauth.currentUser.uid),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length == 0){

                  return Center(
                    child: Text('لا يوجد بائعين'),
                  );
                }

                else
                  print('has');
                List<Sellers> sellers = [];
                for (var doc in snapshot.data.docs) {var data = doc.data(); sellers.add(Sellers(
                  sellername: data['Seller Name'],
                  uid : data['SellerID'],




                  // ignore: missing_return
                ));}

                return    GridView.builder(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    crossAxisCount: 2,
                    childAspectRatio: 5,
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: sellers.length,

                  itemBuilder: (context, index) {
                    return  GestureDetector(
                      onTap: (){

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                Shops(sellerShop :sellers[index].sellername, sellerID : sellers[index].uid),),);





                      },
                      child: Card(
                        color: kdark,
                        elevation: 20,
                        child: Center(child: Text(sellers[index].sellername)),

                      ),
                    );

                  },
                );
              } else {
                return Center(child:

                Text('Loading ...'));
              }

            }),
      ),

    ],),
  );




}

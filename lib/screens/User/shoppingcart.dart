import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'checkout.dart';



// ignore: must_be_immutable
class ShoppingCart extends StatefulWidget

{

  static String id = 'shoppingcart';


  bool showAppBar = true;
  ShoppingCart(this.showAppBar);

  _ShoppingCartState createState() => _ShoppingCartState();


}

class _ShoppingCartState extends State<ShoppingCart> {
User loggeduser;
  var store = Store();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<int> shoppingCartCount = List();
  StreamController _event =StreamController<int>.broadcast();

final FirebaseAuth fireauth = FirebaseAuth.instance;

  int productlength=0;
  double eachitemprice = 0;
double totalProce =0 ;
  String UID;
  bool data  = false;
  @override
  Widget build(BuildContext context) {
    getCurrenruser();

    return Scaffold(
backgroundColor: kdark,


      appBar: widget.showAppBar
          ? AppBar(

        title: Text(
          "سلة التسوق",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.ios_arrow_back,
              color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: kdark,
      )
          : null,

      body:

      Container(

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildShoppingCartItem(),
              Container(
                padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                height: 60,
                child: Card(
                  color: kdark,
                  child: Column(

                    children: <Widget>[


                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Center(
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              Text(totalProce.toString(),style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white ), ),
                              Text(
                                "الاجمالي",
                                style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 16.0),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  color: Colors.white,
                  onPressed: () => {

  if (totalProce == 0.0 ) {
    Fluttertoast.showToast(
        msg: "لا وجد منتجات في السله",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kdark,
        textColor: Colors.white,
        fontSize: 16.0
    )

  }


else
                  Navigator.of(context).push(

                  MaterialPageRoute(
                  builder: (context) =>
                  Checkout(totalProce )


                  ,
                  ),




                  )    },
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
                            "أكمل الدفع",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  buildShoppingCartItem()  {
    var  h = MediaQuery.of(context).size.height*0.7;


    gettotalprice (List<Product> products  ,int  index ){


      totalProce=0 ;

      for (var Product in products  ){
        totalProce = totalProce +  double.parse(Product.productAfterSale ) * (Product.amount);

      }
      return totalProce;

    };


    getCurrenruser();
    return Container (
      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      height: h,

  color: kdark,
      child:  StreamBuilder <QuerySnapshot>   (


          stream: store.loadcartitems(UID)  ,

          // ignore: missing_return
          builder:  (context, snapshot)  {


            if (snapshot.hasData )


            {



              List<Product> products = [];




              for (var doc in snapshot.data.docs) {
                var data = doc.data();
                products.add(Product(
                    doc.id,
                    data[kProductName],
                    data[kProductPrice],
                    data[kProductDescription],
                    data[kProductCategory],
                    data[kproductImage]
                    ,
                    null,
                    data['product after discount'],

                    data[kProductdiscount],
                    null,
                    data['instock'],

                amount: data[kproductamountneeded]
                 //   ,colors: List.from(data['Colors'])

                ));





              }


              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: products.length,
                  itemBuilder: (context, index) {

                   productlength = products.length;
                    if(shoppingCartCount.length < products.length){
                      shoppingCartCount.add(1);

                    }

                    eachitemprice = double.parse(products[index].productAfterSale)*shoppingCartCount[index] ;



                 gettotalprice(products , index);





                   return Card(
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: (MediaQuery.of(context).size.width) / 3,
                            child: Column(
                              children: <Widget>[
                                Image.network(products[index].Productimage),
/*
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconButton(

                                        icon: Icon(Icons.remove_circle_outline),
                                        onPressed: () {
                                          setState(() {
                                            _decrementCounter(index ,  products[index]);
                                            gettotalprice(products, index);

                                          });
                                        },
                                      ),
                                      Text(
                                        shoppingCartCount[index].toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add_circle_outline),
                                        onPressed: () {



                                          setState(() {
                                              gettotalprice(products, index);
                                            _incrementCounter( index , products[index]  );

                                            //    shoppingCartCount++;
                                          })
                                          ;
                                        },
                                      ),
                                    ],
                                  ),
                                )
  */
                              ],
                            ),
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width - 37) / 1.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      width: 120,
                                      child: Text(
                                        products[index].Productname.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        size: 26,
                                      ),
                                      onPressed: () {


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
                                              color: Colors.red,
                                            ),
                                          );
                                          Alert(
                                            context: context,
                                            style: alertStyle,
                                            type: AlertType.info,
                                            title: "ازاله",
                                            desc: "هل انت متأكد من إزاله المنتج من السله؟",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "إلغاء",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context)


                                                ,
                                                color: Colors.green,
                                              ),
                                              DialogButton(
                                                child: Text(
                                                  "موافق",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                onPressed: () =>
                                                    setState(() {
                                                      store.removeitemFromCart(products[index], context, products[index].pID);
                                                      Navigator.pop(context);

                                                      Navigator.pushReplacementNamed(context,ShoppingCart.id);

                                                    })


                                                ,
                                                color: Colors.red,
                                              ),

                                            ],
                                          ).show();
                                        }




                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          eachitemprice.toString() ,
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "x"+products[index].amount.toString() ,
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );}
              );}

         else return(Text('Loading...'));




          }

      ),
    );

  }








  Future <dynamic> getCurrenruser() async {

    loggeduser = await fireauth.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = loggeduser.uid;
      prefs.setString('UID', UID);
    });


  }


  void initState() {

    super.initState();

     productlength=0;
     eachitemprice = 0;
     totalProce =0 ;

    _event.add(1);








  }





}

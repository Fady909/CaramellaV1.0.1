import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Comments.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/models/Product2.dart';
import 'package:flutter_eapp/screens/User/Shops.dart';
import 'package:flutter_eapp/screens/User/shoppingcart.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:flutter_eapp/widgets/dotted_slider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'checkout.dart';

class ProductPage extends StatefulWidget {
  static String id = 'Productpage';
  int shoppingCartCount = 1;
  final Product product;

  ProductPage({this.product, Product2 product2});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  User loggeduser;
  var store = Store();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamController _event = StreamController<int>.broadcast();
  var addcomment = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final FirebaseAuth fireauth = FirebaseAuth.instance;
  bool isClicked = false;
  int productlength = 0;
  double eachitemprice = 0;
  double totalProce = 0;

  var key;
bool visable = false;
  var name;

  String photo;

  var discountcoupon;

  List  availablecolors;

  List pickedforbuy=[];
  @override
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: klight,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 11,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    child: Divider(
                      color: Colors.black26,
                      height: 4,
                    ),
                    height: 24,
                  ),
                  Text(
                    "السعر  :  " +
                        widget.product.productAfterSale +
                        "     دينار اردني",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),

              SizedBox(
                width: 6,
              ),
              RaisedButton(
                onPressed: () {
                  addtoCartButton(widget.product, widget.shoppingCartCount);

                  setState(() {
                    isClicked = !isClicked;
                  });
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.9,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xffd64dcf),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        MaterialCommunityIcons.cart_outline,
                        color: Colors.white,
                      ),
                      new Text(
                        " سله التسوق",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: <Widget>[
                Stack(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        MaterialCommunityIcons.cart_outline,
                      ),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: ShoppingCart(true),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: klight,
              expandedHeight: MediaQuery.of(context).size.height / 2.0,
              floating: true,
              pinned: false,
              title: Text(
                this.widget.product.Productname,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Padding(
                  padding: EdgeInsets.only(top: 90),
                  child: dottedSlider(widget.product),
                ),
              ),
            ),
          ];
        },
        body: Container(

          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Visibility(
              visible: visable
,



           child: ClipPath(
                clipper: MovieTicketBothSidesClipper(),
            child: Container(
              height: 100,
              color: Colors.yellow,
              child: Center(child:Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.4, 0.5],
                      colors: [
                        Colors.yellow,
                        Colors.yellowAccent,
                      ],
                    )),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: visable
                      ,child: Text(
                      "  %  $discountcouponأستمتع بخصومات ضخمه من منتجات هذا المتجر تصل إلي   ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                        // fontFamily: 'Pacifico'
                      ),
                    ),
                    ),
                  ],
                ),
              )),
            ),
          ),







                ),
                Container(
                  height: 100,
                  color: klight,
                  child: Center(child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [0.1, 0.5],
                          colors: [
                            klight,
                            kdark,
                          ],
                        )),
                    height: 60,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.product.productDiscount != ""
                                ? Card(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "دينار أردني",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold
                                      // fontFamily: 'Pacifico'
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    this.widget.product.productAfterSale,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                      // fontFamily: 'Pacifico'
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    this.widget.product.Productprice,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        textBaseline: TextBaseline.ideographic,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.red[800],
                                        decorationThickness: 2

                                      // fontFamily: 'Pacifico'
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  discountcoupon != 0 ?




                                  ClipPath(
                                    clipper: SideCutClipper(),
                                    child: Container(
                                      height: 50,
                                      width: 100  ,
                                      color: Colors.yellow,
                                      child: Center(child:  Text(
                                        "-" +
                                            this.widget.product.productDiscount +
                                            "%" + "   +   " +"-" +
                                            discountcoupon.toString() +
                                            "%",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold
                                          // fontFamily: 'Pacifico'
                                        ),
                                      )),
                                    ),
                                  )


                                 : Text(
                                    "-" +
                                        this.widget.product.productDiscount +
                                        "%",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold
                                      // fontFamily: 'Pacifico'
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : Card(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "دينار أردني",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold
                                      // fontFamily: 'Pacifico'
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),


                                  Text(
                                    this.widget.product.productAfterSale,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                      // fontFamily: 'Pacifico'
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),

                                  discountcoupon != 0 ? Text(
                                    "-" +
                                        discountcoupon.toString() +
                                        "%",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold
                                      // fontFamily: 'Pacifico'
                                    ),
                                  ): Text(
                                    "",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold
                                      // fontFamily: 'Pacifico'
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Row(
                              children: [
                                FavoriteButton(
                                  iconColor: kdark,
                                  iconSize: 50,
                                  isFavorite: false,
                                  valueChanged: (isFavorite) {
                                    print('Is Favorite : $isFavorite');
                                    if (isFavorite == true) {
                                      store.additemtoFavourite(
                                          widget.product, context, widget.product.pID);
                                    } else if (isFavorite == false) {
                                      store.removeitemFromFavourite(
                                          widget.product, context, widget.product.pID);
                                    }
                                    print(widget.product.pID);
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),),
                ),



                _buildInfo(context), //Product Info
                _buildDescription(context),








widget.product.colors.isEmpty? Container():
                     Column(


                       children: [

                 Text(
                   "الألوان المتاحة",
                   textAlign: TextAlign.right,
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                     color: Colors.black45,
                     fontSize: 18,
                   ),
                 ),

                 Container(
                   height: 200,width: 500,
                   child: GridView.builder(
                       gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                         mainAxisSpacing: 2,
                         crossAxisSpacing: 2,
                         crossAxisCount: 5,
                         childAspectRatio: 1,
                       ),

                       physics: BouncingScrollPhysics(),
                       itemCount: availablecolors.length,
                       itemBuilder: (BuildContext context, int index) {

                         return   GestureDetector(
                           onTap: (){
                             if (widget.shoppingCartCount == pickedforbuy.length) {
                                 pickedforbuy.remove(availablecolors[index]);


                             }
                             else if (widget.shoppingCartCount != pickedforbuy.length)

                               pickedforbuy.contains(availablecolors[index]) ? pickedforbuy.remove(availablecolors[index]):
                               pickedforbuy.add(availablecolors[index]);
                             setState(() {

                             });



                           },
                           child: Stack(children: [


                             Container(
                               height: 100  , width: 50
                               ,

                               child: Card(

                                 color: Color(int.parse(availablecolors[index]))
                                 , child: Text(''),
                               ),

                             ),
                             Visibility(
                               visible: pickedforbuy.contains(availablecolors[index]) ? true : false,

                               child: Padding(
                                 padding: const EdgeInsets.only(left: 10.0, top: 20),
                                 child: Icon(Icons.check),
                               ),
                             )

                           ],),
                         );


                       }

                   ),
                 ),


               ],)












                ,Center(
                  child: Text(
                    "معلومات المتجر",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 18,
                    ),
                  ),
                ),
                BuildGoToSeller(),
                buildComments(context),
                //   _buildProducts(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("موافق"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("سلة التسوق"),
      content: Text("تمت إضافة منتجك الي سلة التسوق"),
      actions: [
        okButton,
      ],
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
      type: AlertType.success,
      title: "سلة التسوق",
      desc: "تمت إضافة منتجك الي سلة التسوق",
      buttons: [
        DialogButton(
          child: Text(
            "الرجوع",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: kdark,
        ),
        DialogButton(
          onPressed: () {},
          child: Text(
            "الي سلة التسوق",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  _productSlideImage(String imageUrl) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image:
            DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.contain),
      ),
    );
  }

  dottedSlider(Product product) {
    return Center(
      child: Card(
        elevation: 20,
        shadowColor: klight,
        child: Center(
          child: DottedSlider(
            maxHeight: 200,
            children: <Widget>[
              _productSlideImage(product.Productimage),
              //   _productSlideImage(  product.Productimage),
              // _productSlideImage(  product.Productimage),
              // _productSlideImage(  product.Productimage),

              // _productSlideImage('assets/jackets/jacket1.jpg'),
              //_productSlideImage('assets/jackets/jacket2.jpg'),
              //_productSlideImage('assets/jackets/jacket3.jpg'),
              //_productSlideImage('assets/jackets/jacket1.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  _buildInfo(context) {
    return Container(
      //  ِalignment: AlignmentGeometry.right,

      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              /*
              Center(
                child: Text(
                  "تفاصيل" ,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                    fontSize: 18,
                  ),
                ),
              ),
             */
              SizedBox(
                height: 8,
              ),
              Text(
                widget.product.Productname,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Text(
                "السعر  :  " + widget.product.productAfterSale + "     دينار اردني",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildDescription(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.8,
      child: Container(
        //padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            SizedBox(
              height: 8,
            ),
            Text(
              widget.product.Productdescription,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                "العدد المطلوب",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                  fontSize: 18,
                ),
              ),
            ),
            Card(
              elevation: 12,
              color: kdark,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _decrementCounter(
                              widget.product, widget.shoppingCartCount);
                        });
                      },
                    ),
                    Text(
                      widget.shoppingCartCount.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _incrementCounter(
                              widget.product, widget.shoppingCartCount);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),





















          ],
        ),
      ),
    );
  }

  Widget BuildGoToSeller() {
    return Card(
        elevation: 20,
        color: klight,
        child: Container(
            height: 100,
            width: 300,
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Shops(

                          sellerShop: this.widget.product.sellershop,
                          sellerID: this.widget.product.sellerID),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Text(this.widget.product.sellershop,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold)),
                        Text("  :  اسم المتجر",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.store,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Text(this.widget.product.sellername,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold)),
                        Text("  :  اسم البائع",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Text("اضغط هنا",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: kdark,
                                fontSize: 12,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold)),
                        Text("للانتقال للمتجر ",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ))));
  }

  @override
  void initState() {
    pickedforbuy.clear();
   if (widget.product.colors != null || widget.product.colors != 0 ){ availablecolors = widget.product.colors;
if ( availablecolors.isNotEmpty)
     pickedforbuy.add(availablecolors[0]);


}

    getData();
checkseller();
 productlength = 0;
    eachitemprice = 0;
    totalProce = 0;

    _event.add(1);
  }

  _incrementCounter(Product product, int shoppingCartCount) {
    if (widget.shoppingCartCount != product.remainingQuantity) {
      widget.shoppingCartCount++;

      store.addnumberitem(product, context, product.pID,
          amount: widget.shoppingCartCount);
    } else if (widget.shoppingCartCount == product.remainingQuantity)
      Fluttertoast.showToast(
          msg: "لا يوجد العدد الكافي في المخزن",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 20.0);
    // widget. shoppingCartCount = product.remainingQuantity;
  }

  _decrementCounter(Product product, int shoppingCartCount) {
    if (widget.shoppingCartCount <= 1) {
      widget.shoppingCartCount = 1;
    } else {
      widget.shoppingCartCount--;
      store.addnumberitem(product, context, product.pID,
          amount: widget.shoppingCartCount);
    }

    //_event.add(shoppingCartCount);

    //_multiitem.add(eachitemprice);
  }

  Future<void> getnum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUID = prefs.getString('UID');
    var x = firestore
        .collection('Users')
        .doc(userUID)
        .collection('CartItems')
        .doc(widget.product.pID)
        .get()
        .then((value) async => key = await value.get('amount'));
    return key;
  }

  Future<dynamic> getData() async {
    loggeduser = fireauth1.currentUser;
    final SharedPreferences prefs = await _prefs;

    String UID = loggeduser.uid;

    final DocumentReference document = Firestore.instance
        .collection('Users')
        .doc(UID)
        .collection('Userdata')
        .doc(UID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        name = snapshot.get('name').toString();
        photo = snapshot.get("photo").toString();
      });
    });
  }

  void addtoCartButton(Product product, int shoppingCartCount, ) {
    store.additemtocart(product, context, product.pID,
        amount: widget.shoppingCartCount ,
      coorlist: pickedforbuy

    );
  }

  Widget buildComments(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('التعليقات'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 7,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 100,
                  child: TextField(
                    textDirection: ui.TextDirection.rtl,
                    decoration: new InputDecoration(
                        focusColor: klight,
                        border: new OutlineInputBorder(
                          borderSide: BorderSide(color: klight),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                       // hintTextDirection: ui.TextDirection.rtl,
                        hintText: "أكتب تعليقك...",
                        fillColor: Colors.white70),
                    controller: addcomment,
                  )),
              SizedBox(
                width: 7,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                    onTap: () {
                      addComment(addcomment);
                    },
                    child: Text("أضف تعليق")),
              ),
            ],
          ),
          Container(
            height: 500,
            color: Colors.white60,
            width: MediaQuery.of(context).size.width * 0.9,
            child: StreamBuilder<QuerySnapshot>(
              stream: store.loadComments(widget.product),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // ignore: missing_return
                  List<Comments> comments = [];

                  for (var doc in snapshot.data.docs) {
                    var data = doc.data();
                    comments.add(Comments(
                      data['Comment'],
                      data['Pid'],
                      data['Uid'],
                      data['name'],
                      data['Uphoto'],
                      data['Time'],
                    ));
                  }
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Card(

                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 100,

                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(comments[index].name),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(comments[index].Uphoto),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Row(
                                   mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Flexible(
                                      child: SingleChildScrollView(
                                        child: Text(

                                            comments[index].Comment, softWrap: true,),
                                      ),
                                    ),
                                      SizedBox(width: 30,),
                                  ],

                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                } else
                  return Container(
                    child: Text('لا توجد تعليقات'),
                  );

                return Container(
                  child: Center(child: Text('لا توجد تعليقات')),
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  addComment(TextEditingController addcomment) {
    if (addcomment.text.isNotEmpty) {
      print(name);
      fireauth.currentUser == null ? _emptyalert(context, "لا يمكن اضافة تعليق إلا بعد تسجيل الدخول", ""):

      store.addcomment(

          widget.product, name, addcomment.text, loggeduser.uid, photo);
         addcomment.clear();
    }
  }

  void checkseller() async{
  discountcoupon= await store.checksellercoupones(widget.product.sellerID);
  if (discountcoupon != 0){


  setState(() {

  visable = true;

});}
else {setState(() {
  visable = false;
});}



  var x = double.parse(widget.product.productAfterSale)   - (double.parse(widget.product.productAfterSale)  * int.parse(discountcoupon) /100);
//var y = double.parse(widget.product.productAfterSale)   -  int.parse(discountcoupon)/100;
    widget.product.productAfterSale = x.toString();
  print(x.toString());





  }

  // ignore: non_constant_identifier_names






}
_emptyalert(BuildContext context , title, desc) {
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
        color: Colors.black
    ),
  );
  Alert(
    context: context,
    style: alertStyle,
    title: title,
    desc:desc,
    buttons: [
      DialogButton(
          child: Text(
            "موافق",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: kdark
      ),

    ],
  ).show();
}





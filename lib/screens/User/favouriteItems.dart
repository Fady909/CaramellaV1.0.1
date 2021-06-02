import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/screens/User/UserProfile.dart';
import 'package:flutter_eapp/screens/User/product.dart';
import 'package:flutter_eapp/widgets/clip_shadow_path.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class FavouriteItems extends StatefulWidget {
  static String id = 'favouriteItems';

  @override
  _FavouriteItemsState createState() => _FavouriteItemsState();
}

class _FavouriteItemsState extends State<FavouriteItems> {
  String UID;
  final FirebaseAuth fireauth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    var mywidth = MediaQuery.of(context).size.width;
    var myheight = MediaQuery.of(context).size.height;
    double rectWidth = MediaQuery.of(context).size.width*0.250;
    double rectHeight = MediaQuery.of(context).size.width*.07;
    double trendCardWidth = MediaQuery.of(context).size.width*0.5;
    return Scaffold(
      appBar: AppBar(

        title: Text(
          "منتجاتي المفضله",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.ios_arrow_back,
              color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: kdark,
      ),
      body: Card(
        elevation: 400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),

        child: Container(
          color: Colors.white12,
          height: myheight,

          child: StreamBuilder<QuerySnapshot>(
              stream: store.LoadFavourieItems(UID),


              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.size != 0) {
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
                          data['Product SubCategory'],
                          data ['product after discount'],

                          data[kProductdiscount],null,data['instock'],
                          sellername: data['Seller Name'],
                          sellershop: data['Seller shop'],
                          sellerID: data['sellerID'],
                          sellerToken: data['sellertoken']
                          ,colors:data['colors'] != null? data['colors'] : []

                        // ignore: missing_return

                      ));


                    }



                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      itemCount: products.length,

                      itemBuilder: (BuildContext context, int index) => new Container(


                          child: GestureDetector(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: trendCardWidth,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: ClipShadowPath(
                                        shadow: Shadow(blurRadius: 1, color: klight),
                                        clipper: TrendingItemsClipper(rectWidth, rectHeight),
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: (){store.removeitemFromFavourite(products[index], context, products[index].pID);},
                                                      child: Card(

                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(2.0),
                                                          child: Icon(Icons.clear),

                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 5),
                                                      child: Container(
                                                        width: 75,
                                                        height: 30,
                                                        child: Card(
                                                          elevation: 6,
                                                          color: klight,
                                                          child: Center(
                                                            child: Text(
                                                              products[index].productDiscount!= "" ? "- ${products[index].productDiscount} %"
                                                                  : "Onsale",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                _productImage(products[index].Productimage),
                                                _productDetails(products[index].Productname,products[index].Productprice , products[index].productDiscount)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      left: trendCardWidth / 2 - rectWidth / 2,
                                      child: ClipShadowPath(
                                        shadow: Shadow(color: klight, blurRadius: 1),
                                        clipper: CartIconClipper(rectWidth, rectHeight),
                                        child: GestureDetector(
                                          onTap: (){

                                            store.additemtocart(products[index] , context, products[index].pID);

                                          },
                                          child: Container(

                                            width: rectWidth,
                                            height: rectHeight,
                                            color: kdark,
                                            child: Center(
                                              child: Icon(
                                                Icons.shopping_cart,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductPage(
                                          product: products[index],
                                        ),
                                  ),
                                );
                              }         )
                      ),


                      staggeredTileBuilder: (int index) =>

                      new StaggeredTile.count(2, 2.3),
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 3.0,



                    );


                  }
                  if (snapshot.data.size == 0) {
                    return Container(
                      child: Center(child: Text('لا يوجد منتجات بعد ')),
                    );
                  }
                } else if (!snapshot.hasData) {
                  return Container(
                    child: Center(child: Text('لا يوجد منتجات بعد ')),
                  );
                }
              }),

        ),
      ),




    );


  }

  _productImage(String productimage) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: ProductImageContainerClipper(),
          child: Container(
            width: 100,
            height: 70,
            /*
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradientColors)),
         */
          ),
        ),
        Center(
          child: Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(productimage), fit: BoxFit.contain)),
          ),
        )
      ],
    );
  }

  _productDetails(String productname, String productprice , String productdiscount) {
    if (productdiscount == '' ){return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /*
        Text(
          product.company,
          style: TextStyle(fontSize: 12, color: Color(0XFFb1bdef)),
        ),
       */
        Text(
          productname,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),

        SizedBox(height:5),
        //StarRating(rating: product.rating, size: 10),
        Row(
          children: <Widget>[
            Text(productprice,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF85c2ff))),
            /*
            Text(
              '#00.000',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  decoration: TextDecoration.lineThrough),
            )
       */
          ],
        )
      ],
    );}
    else  if(productdiscount != ''){

      double price = double.parse(productprice);
      double discount = double.parse(productdiscount);


      var PricceAfterDiscount =price- ((price*discount)/100);
      var productbefordiscount =  price;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*
        Text(
          product.company,
          style: TextStyle(fontSize: 12, color: Color(0XFFb1bdef)),
        ),
       */
          Text(
            productname,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          //StarRating(rating: product.rating, size: 10),





          Row(
            children: <Widget>[
              Text(PricceAfterDiscount.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF85c2ff))),

              Text(
                productbefordiscount.toString(),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough),
              )
              ,

            ],
          )
          ,
          Text(
            'Discount '+  productdiscount + '%',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
          ),

        ],
      );}
    else {return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /*
        Text(
          product.company,
          style: TextStyle(fontSize: 12, color: Color(0XFFb1bdef)),
        ),
       */
        Text(
          productname,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
        //StarRating(rating: product.rating, size: 10),
        Row(
          children: <Widget>[
            Text(productprice,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF85c2ff))),
            /*
            Text(
              '#00.000',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  decoration: TextDecoration.lineThrough),
            )
       */
          ],
        )
      ],
    );}




    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /*
        Text(
          product.company,
          style: TextStyle(fontSize: 12, color: Color(0XFFb1bdef)),
        ),
       */
        Text(
          productname,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
        //StarRating(rating: product.rating, size: 10),
        Row(
          children: <Widget>[
            Text(productprice,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF85c2ff))),
            /*
            Text(
              '#00.000',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  decoration: TextDecoration.lineThrough),
            )
       */
          ],
        )
      ],
    );
  }


  @override
  void initState() {
    getCurrenruser(UID);
  }

  Future <dynamic> getCurrenruser(String uid) async {

    loggeduser = await fireauth.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = loggeduser.uid;
      prefs.setString('UID', UID);
    });


  }


}

cartIcon(double rectWidth, double rectHeight, BuildContext context, Product product) {
  return ClipShadowPath(
    shadow: Shadow(color: klight, blurRadius: 1),
    clipper: CartIconClipper(rectWidth, rectHeight),
    child: GestureDetector(
      onTap: (){





        print ('pressed');









      },
      child: Container(
        width: rectWidth,
        height: rectHeight,
        color: Color(0XFF3399ff),
        child: Center(
          child: Icon    (
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
class TrendingItemsClipper extends CustomClipper<Path> {
  double rectWidth;
  double rectHeight;
  TrendingItemsClipper(this.rectWidth, this.rectHeight);

  double radius = 35;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(radius, 0);
    path.quadraticBezierTo(0, 0, 0, radius);
    path.lineTo(0, size.height - radius);
    path.quadraticBezierTo(0, size.height, radius, size.height);
    path.lineTo(size.width / 2 - rectWidth / 2 - 4, size.height);
    path.lineTo(
        (size.width / 2 - rectWidth / 2) + 14 - 4, size.height - rectHeight);
    path.lineTo(
        (size.width / 2 + rectWidth / 2) - 14 + 4, size.height - rectHeight);
    path.lineTo(size.width / 2 + rectWidth / 2 + 4, size.height);
    path.lineTo(size.width - radius, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - radius);
    path.lineTo(size.width, radius);
    path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
    path.close();

    return path;
    // Path path = Path();
    // path.lineTo(0, 0);
    // path.lineTo(0, size.height);
    // path.lineTo(size.width/2 - rectWidth/2 - 4, size.height);
    // path.lineTo((size.width/2 - rectWidth/2) + 14 -4, size.height - rectHeight);
    // path.lineTo((size.width/2 + rectWidth/2) - 14 + 4, size.height - rectHeight);
    // path.lineTo(size.width/2 + rectWidth/2 + 4 , size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width, 0);
    // path.close();
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CartIconClipper extends CustomClipper<Path> {
  double rectWidth;
  double rectHeight;

  CartIconClipper(this.rectWidth, this.rectHeight);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(14, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 14, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ProductImageContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.cubicTo(
        0, size.height - 20, 0, size.height, size.width - 20, size.height - 6);
    //path.cubicTo(size.width, size.height, size.width, size.width - 10, size.width, 10);
    // path.lineTo(size.width/2, 0);
    path.quadraticBezierTo(size.width, size.height, size.width - 4, 15);
    // path.quadraticBezierTo(0, 60, 40, size.height);
    // path.quadraticBezierTo(0, 60, 40, size.height);
    //path.lineTo(0, size.height);
    //path.lineTo(size.width, size.height);
    path.lineTo(size.width - 10, 10);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }








}
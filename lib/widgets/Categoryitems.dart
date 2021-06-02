import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/screens/User/product.dart';
import 'package:flutter_eapp/services/store.dart';

import 'clip_shadow_path.dart';

class CategoryItem extends StatefulWidget {
  Product product;
  final categoryname;
  final productname;
  CategoryItem({this.categoryname, this.product, this.productname});

  CategoryItem.get(this.product, this.categoryname, this.productname);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  List<Product> products = [];

  final store = Store();

  double rectWidth = 95;

  double rectHeight = 26;

  double trendCardWidth = 180;

  @override
  Widget build(BuildContext context) {
    if (widget.productname != null && widget.categoryname != null) {
      return SingleChildScrollView(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: widget.categoryname == 'All'
                  ? store.loadproductsWsearch(widget.productname)
                  : store.loadproductsaccordingtocategoryWsearch(
                      widget.categoryname, widget.productname),

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
                          ,colors: List.from(data['Colors'])

                        // ignore: missing_return

                      ));


                    }



                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         //mainAxisSpacing: 5,
                        crossAxisSpacing: 0,
                        crossAxisCount: 2,
                        //  childAspectRatio: (50 / 60) * 1.1,
                      ),
                      controller: ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    product: products[index],
                                  ),
                                ),
                              );
                            },
                            child: GestureDetector(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: trendCardWidth,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 1.0),
                                        child: ClipShadowPath(
                                          shadow: Shadow(
                                              blurRadius: 1, color: kdark),
                                          clipper: CategoryItemsClipper(
                                              rectWidth, rectHeight),
                                          child: Card(
                                            elevation: 5,
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Card(
                                                        color: kdark,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          /*
                                                      child: Text(
                                                        '${product.remainingQuantity} left',
                                                        style: TextStyle(
                                                            color: Colors.white, fontSize: 12.0),
                                                      ),
                                                    */
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      FavoriteButton(
                                                        iconSize: 30,
                                                        isFavorite: false,
                                                        valueChanged:
                                                            (isFavorite) {
                                                          print(
                                                              'Is Favorite : $isFavorite');
                                                          if (isFavorite ==
                                                              true) {
                                                            store.additemtoFavourite(
                                                                products[index],
                                                                context,
                                                                products[index]
                                                                    .pID);
                                                          } else if (isFavorite ==
                                                              false) {
                                                            store.removeitemFromFavourite(
                                                                products[index],
                                                                context,
                                                                products[index]
                                                                    .pID);
                                                          }
                                                          print(products[index]
                                                              .pID);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  _productImage(products[index]
                                                      .Productimage),
                                                  _productDetails(
                                                      products[index]
                                                          .Productname,
                                                      products[index]
                                                          .Productprice,
                                                      products[index]
                                                          .productDiscount)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        left:
                                            trendCardWidth / 2 - rectWidth / 2,
                                        child: _cartIcon(rectWidth, rectHeight,
                                            context, products[index])),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProductPage(
                                        product: products[index],
                                      ),

                                    ),
                                  );
                                }));
                      },
                    );
                  }
                  if (snapshot.data.size == 0) {
                    return Column(
                      children: [
                        SizedBox(height: 50,),
                        Card(
                            elevation: 10,
                            child: Image(image: NetworkImage('https://png.pngtree.com/png-vector/20200116/ourmid/pngtree-man-with-sadness-face-concept-for-expression-character-png-image_2129313.jpg'), fit: BoxFit.fitHeight,)),
                        SizedBox(height: 50,),
                        Text('لا توجد منتجات في هذا القسم بعد'),
                      ],



                    );
                  }
                } else if (!snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(height: 50,),
                      Card(
                          elevation: 10,
                          child: Image(image: NetworkImage('https://png.pngtree.com/png-vector/20200116/ourmid/pngtree-man-with-sadness-face-concept-for-expression-character-png-image_2129313.jpg'), fit: BoxFit.fitHeight,)),
                      SizedBox(height: 50,),
                      Text('لا توجد منتجات في هذا القسم بعد'),
                    ],



                  );
                }
              }),
        ),
      );
    }
    if (widget.productname == null && widget.categoryname != null)
      return SingleChildScrollView(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: widget.categoryname == 'All'
                  ? store.loadproducts()
                  : store.loadproductsaccordingtocategory(widget.categoryname),

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
                          ,colors: List.from(data['Colors'])

                        // ignore: missing_return

                      ));


                    }


                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //  mainAxisSpacing: 5,
                        crossAxisSpacing: 0,
                        crossAxisCount: 2,
                        //  childAspectRatio: (50 / 60) * 1.1,
                      ),
                      controller: ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    product: products[index],
                                  ),
                                ),
                              );
                            },
                            child: GestureDetector(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: trendCardWidth,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 1.0),
                                        child: ClipShadowPath(
                                          shadow: Shadow(
                                              blurRadius: 1, color: klight),
                                          clipper: CategoryItemsClipper(
                                              rectWidth, rectHeight),
                                          child: Card(
                                            elevation: 5,
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Card(
                                                        color: kdark,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      FavoriteButton(
                                                        iconSize: 30,
                                                        isFavorite: false,
                                                        valueChanged:
                                                            (isFavorite) {
                                                          print(
                                                              'Is Favorite : $isFavorite');
                                                          if (isFavorite ==
                                                              true) {
                                                            store.additemtoFavourite(
                                                                products[index],
                                                                context,
                                                                products[index]
                                                                    .pID);
                                                          } else if (isFavorite ==
                                                              false) {
                                                            store.removeitemFromFavourite(
                                                                products[index],
                                                                context,
                                                                products[index]
                                                                    .pID);
                                                          }
                                                          print(products[index]
                                                              .pID);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  _productImage(products[index]
                                                      .Productimage),
                                                  _productDetails(
                                                      products[index]
                                                          .Productname,
                                                      products[index]
                                                          .Productprice,
                                                      products[index]
                                                          .productDiscount)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        left:
                                            trendCardWidth / 2 - rectWidth / 2,
                                        child: _cartIcon(rectWidth, rectHeight,
                                            context, products[index])),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProductPage(
                                        product: products[index],
                                      ),
                                    ),
                                  );
                                }));
                      },
                    );
                  }

                  if (snapshot.data.size == 0) {
                    return Column(
                      children: [
                        SizedBox(height: 50,),
                        Card(
                            elevation: 10,
                            child: Image(image: NetworkImage('https://png.pngtree.com/png-vector/20200116/ourmid/pngtree-man-with-sadness-face-concept-for-expression-character-png-image_2129313.jpg'), fit: BoxFit.fitHeight,)),
                        SizedBox(height: 50,),
                        Text('لا توجد منتجات في هذا القسم بعد'),
                      ],



                    );
                  }
                } else if (!snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(height: 50,),
                      Card(
                          elevation: 10,
                          child: Image(image: NetworkImage('https://png.pngtree.com/png-vector/20200116/ourmid/pngtree-man-with-sadness-face-concept-for-expression-character-png-image_2129313.jpg'), fit: BoxFit.fitHeight,)),
                      SizedBox(height: 50,),
                      Text('لا توجد منتجات في هذا القسم بعد'),
                    ],



                  );
                }
              }),
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

  _productDetails(
      String productname, String productprice, String productdiscount) {
    if (productdiscount == null || productdiscount =='') {
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

          SizedBox(height: 5),
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
      );
    } else if (productdiscount != null) {
      var price = double.parse(productprice);
      var discount = double.parse(productdiscount);

      var PricceAfterDiscount = ((price * discount) / 100);
      var productbefordiscount = price;

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
              ),
            ],
          ),
          Text(
            'Discount ' + productdiscount + '%',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
          ),
        ],
      );
    } else {
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

            ],
          )
        ],
      );
    }

  }

  _cartIcon(double rectWidth, double rectHeight, BuildContext context,
      Product product) {
    return ClipShadowPath(
      shadow: Shadow(color: klight, blurRadius: 1),
      clipper: CartIconClipper(rectWidth, rectHeight),
      child: GestureDetector(
        onTap: () {
          store.additemtocart(product, context, product.pID , );
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
    );
  }
}

class CategoryItemsClipper extends CustomClipper<Path> {
  double rectWidth;
  double rectHeight;
  CategoryItemsClipper(this.rectWidth, this.rectHeight);

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

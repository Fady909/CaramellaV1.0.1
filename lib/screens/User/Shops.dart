import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/screens/User/UserProfile.dart';
import 'package:flutter_eapp/screens/User/product.dart';
import 'package:flutter_eapp/screens/User/search.dart';
import 'package:flutter_eapp/widgets/clip_shadow_path.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants.dart';
import 'home.dart';

class Shops extends StatefulWidget {
  static final id = "shops";
  final sellerShop;
  final sellerID;
 var follow = "متابعه";
 bool yes = false;

  var product;
  Shops({Key key, this.sellerShop, this.sellerID}) : super(key: key);

  @override
  _ShopsState createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  GlobalKey<ScaffoldState> sellerscaffoldkey = new GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  PageController pageController;
  var discountcoupon;
  bool visable = false;

  var followers;

  var bannerlink =  "https://images.unsplash.com/32/Mc8kW4x9Q3aRR3RkP5Im_IMG_4417.jpg?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80";



  @override
  Widget build(BuildContext context) {
    checkfollowernumber();
    checkfollow();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 150,
            flexibleSpace:  Stack(children: [
              Container(

                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
bannerlink                      ,
                    ),
                  ),
                ),
                height: 600,
              ),
              Container(
                height: 600,
                decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          klight,
                          Colors.black26,
                        ],
                        stops: [
                          0.0,
                          1.0
                        ])),
              ),

            ],),
            backgroundColor: Colors.transparent,
            title: Column(
              children: [
                SizedBox(height: 20,),
                Row(children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 14.0,
                    child: new Icon(
                      Icons.store,
                      color: Colors.black,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text(widget.sellerShop.toString()),
                  SizedBox(width: 20,),
                  Card(
                //    semanticContainer: true,
                    elevation: 10,
                    color: Colors.red.withOpacity(0.0),
                    child: Container(
                      height: 30,
                      child: Center(child: GestureDetector(
                          onTap: () async {
                            if (widget.follow == "متابعه") {
                              store.followStore(
                                  context, widget.sellerShop, widget.sellerID, int.parse(followers));
                              Fluttertoast.showToast(
                                  msg: "تم متابعة المتجر بنجاح",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: kdark,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );

                              setState(() {

                                widget.follow ="متابعه";
                              });







                            }

                            else if (widget.follow !="متابعه" ){store.unfollowstore(context, widget.sellerShop , widget.sellerID, int.parse(followers));

                            Fluttertoast.showToast(
                                msg: "تم الغاء متابعة المتجر بنجاح",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: kdark,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                            setState(() {
                              widget.follow ="متابعه";
                            });


                            }

                          },





                          child: Image(image: AssetImage(

                              widget.follow != "متابعه" ?

                                  "assets/unfollow.png" : "assets/follow.png"





                          ),)
                      )

                      ),
                    ),
                  ),



                ],),
                Text("عدد متابعين المتجر : "+followers.toString(), style: TextStyle(fontSize: 12),),

              ],

            ),

            actions: <Widget>[

              IconButton(
                icon: Icon(
                  MaterialCommunityIcons.home,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: Home(),
                    ),
                  );
                },
              ),

              IconButton(
                icon: Icon(
                  MaterialCommunityIcons.shopping_search,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          Search(
                            sellername : widget.sellerShop,
                            sellerID : widget.sellerID,
                          ),
                    ),
                  );
                },
              ),
            ],
            bottom: TabBar(
              indicatorColor: klight,
              tabs: [
                Tab(text: 'المتجر'),
                Tab(text: 'كل المنتجات'),
              ],
            ),

          ),
          body: TabBarView(
            children: [
              sellerHome(widget.yes),
              SellerProducts(widget.yes),
            ],
          ),
        )
    );
  }
  BottomNavyBar buildSellerBottomNavyBar(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: currentIndex,
      showElevation: true,
      onItemSelected: (index) {
        setState(() => currentIndex = index);
        pageController.jumpToPage(index);
      },
      items: [
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text('لمتاجر'),
          activeColor: kdark,
          inactiveColor: CupertinoColors.inactiveGray,
        ),
        BottomNavyBarItem(
            icon: Icon(Icons.table_view_sharp),
            title: Text('الاقسام'),
            activeColor: kdark,
            inactiveColor: CupertinoColors.inactiveGray),
      ],
    );
  }

  @override
  void initState() {
    checkfollowernumber();
checkfollow();
checkstorestate();
checkseller();
    }

  void checkfollow() async{

    await store.checkfollowstate(context, widget.sellerShop, widget.sellerID) == false ?

      widget.follow = "متابعه"
   :
      widget.follow = "الغاء المتابعه";

setState(() {

});


  }

  void checkstorestate() async {
    await  store.checksellerproductstate(context, widget.sellerShop, widget.sellerID) == true ?
    setState(() {
      widget.yes = true;
    }) : setState(() {
      widget.yes = false;
    });



  }



  Widget sellerHome(bool yes) {




    double rectWidth = 95;
    double rectHeight = 26;
    double trendCardWidth = 140;
    return yes == false?

    Column(
      children: [
        SizedBox(height: 50,),
        Image(image: NetworkImage('https://lynethhealthcare.in/images/no-product.png')),
        SizedBox(height: 50,),
        Text('لا توجد منتجات لهذا البائع بعد'),
      ],
      


    ) :

      SingleChildScrollView(



      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 10,),
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
                            fontSize: 15,
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


          GestureDetector(
            onTap: (){



            },
            child: Text("    وصل حديثا         ",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Tajawal',

                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 30,),


          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 8.0, right: 5.0),
              width: 400,
              height: 200,
              child: StreamBuilder<QuerySnapshot>(
                  stream: store.loadproductsellernewlyarrived(widget.sellerID),

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

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
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
                                              const EdgeInsets.only(bottom: 4.0),
                                          child: ClipShadowPath(
                                            shadow: Shadow(
                                                blurRadius: 1, color: klight),
                                            clipper: TrendingItemsClipper(
                                                rectWidth, rectHeight),
                                            child: Card(
                                              elevation: 0,
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Card(
                                                          color: Colors.black,
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
                                                          // ignore: unrelated_type_equality_checks
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
                                          child: ClipShadowPath(
                                            shadow: Shadow(
                                                color: klight, blurRadius: 1),
                                            clipper: CartIconClipper(
                                                rectWidth, rectHeight),
                                            child: GestureDetector(
                                              onTap: () {
                                                store.additemtocart(
                                                    products[index],
                                                    context,
                                                    products[index].pID);
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
                                        builder: (context) => ProductPage(
                                          product: products[index],
                                        ),
                                      ),
                                    );
                                  }));
                        },
                      );
                    }

                    return Container(
                      child: Text('Nothing yet'),
                    );
                  }),
            ),
          ),
          SizedBox(height: 30,),




          SingleChildScrollView(



            child: Container(
              padding: const EdgeInsets.only(left: 8.0, right: 5.0),
              width: 500,
              height: 500,
              child: StreamBuilder<QuerySnapshot>(
                  stream: store.loadproductsellerbyHot(widget.sellerID),

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

                      return Column(
                        crossAxisAlignment:CrossAxisAlignment.end ,

                        children: [

                        Text(" الاشهر   ",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontFamily: 'Tajawal',

                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 30,),
                      Container(
                        height: 200,
                        child: ListView.builder(

                        scrollDirection: Axis.horizontal,
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
                                            const EdgeInsets.only(bottom: 4.0),
                                            child: ClipShadowPath(
                                              shadow: Shadow(
                                                  blurRadius: 1, color: klight),
                                              clipper: TrendingItemsClipper(
                                                  rectWidth, rectHeight),
                                              child: Card(
                                                elevation: 0,
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Card(
                                                            color: Colors.black,
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
                                                            // ignore: unrelated_type_equality_checks
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
                                            child: ClipShadowPath(
                                              shadow: Shadow(
                                                  color: klight, blurRadius: 1),
                                              clipper: CartIconClipper(
                                                  rectWidth, rectHeight),
                                              child: GestureDetector(
                                                onTap: () {
                                                  store.additemtocart(
                                                      products[index],
                                                      context,
                                                      products[index].pID);
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
                                          builder: (context) => ProductPage(
                                            product: products[index],
                                          ),
                                        ),
                                      );
                                    }));
                          },
                        ),
                      )
                      ],);
                    }

                    return Container(
                      child: Text('Nothing yet'),
                    );
                  }),
            ),
          ),





          SizedBox(height: 15,),


        ],
      ),
    );


  }

  Widget SellerProducts(bool yes) {
    {
      double rectWidth = 95;
      double rectHeight = 26;
      double trendCardWidth = 140;
      return
        yes == false?

        Column(
          children: [
            SizedBox(height: 50,),
            Image(image: NetworkImage('https://lynethhealthcare.in/images/no-product.png')),
            SizedBox(height: 50,),
            Text('لا توجد منتجات لهذا البائع بعد'),
          ],



        ) :

        SingleChildScrollView(
          child: Column(
          children: [

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
                              fontSize: 15,
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

           







            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                width: 400,
               height: MediaQuery.of(context).size.height*0.8,

                child: StreamBuilder<QuerySnapshot>(
                    stream: store.loadproductsspecifyu(widget.sellerID),

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
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
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
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: ClipShadowPath(
                                              shadow: Shadow(
                                                  blurRadius: 1, color: klight),
                                              clipper: TrendingItemsClipper(
                                                  rectWidth, rectHeight),
                                              child: Card(
                                                elevation: 0,
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Card(
                                                            color: Colors.black,
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
                                                            // ignore: unrelated_type_equality_checks
                                                            valueChanged:
                                                                (isFavorite) {
                                                              print(
                                                                  'Is Favorite : $isFavorite');
                                                              if (isFavorite ==
                                                                  true) {
                                                                store.additemtoFavourite(
                                                                    products[
                                                                        index],
                                                                    context,
                                                                    products[
                                                                            index]
                                                                        .pID);
                                                              } else if (isFavorite ==
                                                                  false) {
                                                                store.removeitemFromFavourite(
                                                                    products[
                                                                        index],
                                                                    context,
                                                                    products[
                                                                            index]
                                                                        .pID);
                                                              }
                                                              print(
                                                                  products[index]
                                                                      .pID);
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                      _productImage(
                                                          products[index]
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
                                            left: trendCardWidth / 2 -
                                                rectWidth / 2,
                                            child: ClipShadowPath(
                                              shadow: Shadow(
                                                  color: klight, blurRadius: 1),
                                              clipper: CartIconClipper(
                                                  rectWidth, rectHeight),
                                              child: GestureDetector(
                                                onTap: () {
                                                  store.additemtocart(
                                                      products[index],
                                                      context,
                                                      products[index].pID);
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
                                          builder: (context) => ProductPage(
                                            product: products[index],
                                          ),
                                        ),
                                      );
                                    }));
                          },
                        );
                      }

                      return Container(
                        child: Text('Nothing yet'),
                      );
                    }),
              ),
            )



          ],
      ),
        );
    }
  }

  void checkseller() async{
var emptybnner;
emptybnner =  await store.checksellerbanner(widget.sellerID);
    emptybnner != null ? bannerlink = emptybnner : null;











    discountcoupon= await store.checksellercoupones(widget.sellerID);
    if (discountcoupon != 0){

      setState(() {

        visable = true;

      });}
    else {setState(() {
      visable = false;
    });}




  }

  void checkfollowernumber() async{
  followers = await  store.checkstorefollowers(widget.sellerID);

  }


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
  if (productdiscount == '') {
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
  } else if (productdiscount != '') {
    double price = double.parse(productprice);
    double discount = double.parse(productdiscount);

    var PricceAfterDiscount = price - ((price * discount) / 100);
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








}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/services/store.dart';

import '../../constants.dart';

class ManageProducts extends StatefulWidget {
  @override
  _ManageProductsState createState() => _ManageProductsState();
  static String id = "ManageProducts";
}

class _ManageProductsState extends State<ManageProducts> {
  final store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: store.loadproducts(),
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
                    data[kproductImage],null,null,

                    data['Product Discount']

                    ,null,null,
                    sellername: data[ksellername],
                  sellershop: data[kshopname],
                    colors: List.from(data['Colors'])


                  // ignore: missing_return

                    ));
              }

              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.5,
                      crossAxisSpacing: 2,
                      childAspectRatio: 0.8),
                  itemBuilder: ((context, index) => Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: GestureDetector(
                          onTapUp: (details) {
                            double dx =
                                details.globalPosition.dx; // where from left
                            double dy =
                                details.globalPosition.dy; // where from top
                            double dz = MediaQuery.of(context).size.width -
                                dx; // where from right
                            double db = MediaQuery.of(context).size.height -
                                dy; // where from right

                            showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(dx, dy, dz, db),
                                items: [
                                 /*
                                  MyPopUpMenuItem(
                                    child: Text('Edit'),
                                    onClick: () {
                                      Navigator.pushNamed(
                                          context, adjustProducts.id,
                                          arguments: products[index]);

/*
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => adjustProducts() , arguments: products[index]);
      );
  */
/*
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context ) => adjustProducts() ,) , (r) => true  );

*/
                                    },
                                  ),
                                 */
                                  MyPopUpMenuItem(
                                    child: Text('Delete'),
                                    onClick: () {
                                      store.deletproduct(products[index].pID);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  MyPopUpMenuItem(
                                    child: Text('Cancel'),
                                    onClick: () {
                                      Navigator.pop(context);

                                    },
                                  ),
                                  MyPopUpMenuItem(
                                    child: Text('Make Hot'),
                                    onClick: () {
                                      store.editproduct(
                                      {

                                        'state' : 'Hot'

                                      }

                                      , products[index].pID);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  MyPopUpMenuItem(
                                    child: Text('Un-Hot'),
                                    onClick: () {
                                      store.editproduct(
                                          {

                                            'state' : 'No'

                                          }

                                          , products[index].pID);
                                      Navigator.pop(context);
                                    },
                                  ),


                                ]);
                          },
                          child: Card(
                            child: Stack(
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: Container(
                                   padding: EdgeInsets.only(left: 10, top: 5),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white,
                                              Colors.white,
                                            ],
                                            stops: [
                                              0.0,
                                              0.8
                                            ])),
                                    child: Column(
                                      children: <Widget>[
                                        SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Image.network(
                                                products[index].Productimage,
                                               // width: 310,
                                                height: 150,
                                                fit: BoxFit.fill,
                                              ),

                                              Text(
                                                products[index].Productname,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 12),
                                              ),
                                              Text(
                                                  products[index].Productprice,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 10),
                                              ),
                                              Text(
                                             'Discount Value  ' +   products[index].productDiscount + "%",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 10),
                                              ),
                                              Text(
                                           'Seller Name  '  +   products[index].sellername,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 10),
                                              ),
                                              Text(
                                                'ShopName  '  +   products[index].sellershop,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 10),
                                              ),


                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      )),
                  itemCount: products.length);
            } else {
              return Center(child: Text('Loading ...'));
            }
            ;
          }),
    );
  }
}

/////////////////////// To Override and use on click

class MyPopUpMenuItem<T> extends PopupMenuItem<T> {
  final Widget child;
  final Function onClick;
  MyPopUpMenuItem({@required this.child, @required this.onClick})
      : super(child: child);
  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopUpMenuItemState();
  }
}

class MyPopUpMenuItemState<T, PopupMenuItem>
    extends PopupMenuItemState<T, MyPopUpMenuItem<T>> {
  @override
  void handleTap() {
    widget.onClick();
  }
}

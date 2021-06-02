import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Categories.dart';
import 'package:flutter_eapp/screens/Admin/subCategories.dart';
import 'package:flutter_eapp/services/store.dart';


class ManageCategories extends StatefulWidget {
  static String id = "ManageCategories";
  @override
  _ManageCategoriesState createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  final store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(


          stream: store.loadCategories(),

          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CateG> Categories = [];





              for (var doc in snapshot.data.docs) {var data = doc.data(); Categories.add(CateG(
                doc.id,
                data[kCategoryName],
                data[kSubCatName],

                // ignore: missing_return
              ));}
              return ListView.builder(
                  itemCount: Categories.length,
                  itemBuilder: (context, index) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[ GestureDetector(
                          child: Row(

                              children: [Text(
                                '${Categories[index].CategoryName} ',
                                style: TextStyle(fontSize: 20),
                              ),
                              ]
                          )
                          , onTapUp: (details) {
                          double dx = details
                              .globalPosition.dx; // where from left
                          double dy = details
                              .globalPosition.dy; // where from top
                          double dz =
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width -
                                  dx; // where from right
                          double db =
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height -
                                  dy; // where from right

                          showMenu(
                              context: context,
                              position:
                              RelativeRect.fromLTRB(dx, dy, dz, db),
                              items: [
                                /*
                        MyPopUpMenuItem(
                          child: Text('Edit'),
                          onClick: () {},
                        ),
                      */
                                MyPopUpMenuItem(
                                  child: Text('Delete'),
                                  onClick: () {
                                    store.deletCategory(
                                        Categories[index].catID);
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
                                  child: Text('change Photo'),
                                  onClick: () {
                                    Navigator.pop(context);
                                  },


                                ),


                                MyPopUpMenuItem(
                                  child: Text('Show Sub Categories'),
                                  onClick: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SubCategories(categoryName : Categories[index].CategoryName, CategoryID:  Categories[index].catID),),


                                    );

                                  },
                                ),
                              ]);
                        },
                        ),
                          Divider(thickness: 2,)
                        ]);

                  }





              );


            } else {
              return Center(child: Text('Loading ...'));
            }

          }),


    );
  }

















}

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

///////////////////////////////////////////////////




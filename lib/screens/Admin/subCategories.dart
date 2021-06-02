import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/SubCategories.dart';
import 'package:flutter_eapp/services/category.dart';
import 'package:flutter_eapp/services/store.dart';


MaterialColor active = Colors.red;
MaterialColor notActive = Colors.grey;
TextEditingController categoryController = TextEditingController();
GlobalKey<FormState> categoryFormKey = GlobalKey();
CategoryService _categoryService = CategoryService();
GlobalKey<FormState> brandFormKey = GlobalKey();


class SubCategories extends StatefulWidget {
  static String id = "subCategories";

  var categoryName;

  var CategoryID;




  SubCategories(

      // ignore: empty_constructor_bodies
          { this.categoryName, this.CategoryID}
      );





  @override
  SubCategoriesState createState( ) => SubCategoriesState();
}

class SubCategoriesState extends State<SubCategories> {
  final store = Store();

  @override
  // TODO: implement widget
  String get categoryNameW => super.widget.categoryName;
  String get CategoryIDW => super.widget.CategoryID;




  @override
  Widget build(BuildContext context  ) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(


          stream: store.loadSubCat(),

          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SubCateG> subCategories = [];

              for (var doc in snapshot.data.docs) {
                var data = doc.data();
                subCategories.add(SubCateG(
                    doc.id,
                    data[kSubCatName],
                    data[ksubcategory_OriginalCategoryID],
                    data [ksubcategoryCatgoryName]
                  // ignore: missing_return
                ));
              }
              return ListView.builder(
                  itemCount: subCategories.length  ,


                  itemBuilder: (context, index ) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[ GestureDetector(
                          child: Row(

                              children: [

                                if (subCategories[index].categoryname == widget.categoryName)
                                  (Text (subCategories[index].subCategoryName , style: TextStyle(fontSize: 20),))
                                else Text('',  style: TextStyle(fontSize: 0),)]
                          )
                          , onTapUp: (details ) {
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
                                MyPopUpMenuItem(
                                  child: Text('Delete'),
                                  onClick: () {
                                    store.deletsubcategory(subCategories[index].subCatID);
                                    Navigator.pop(context);
                                  },
                                ),
                                MyPopUpMenuItem(
                                  child: Text('Cancel'),
                                  onClick: () {
                                    Navigator.pop(context);
                                  },
                                ),


                              ]);
                        },
                        ),


                          if (subCategories[index].categoryname == widget.categoryName)
                            Divider(thickness: 3 , color: Colors.black,),






                        ] ) ;


                  }





              );


            } else {
              return Center(child: Text('Loading ...'));
            }

          }),
      bottomSheet: FloatingActionButton(
          onPressed: (){
            categoryAlert();
          },
          child: Text('Add'),

          backgroundColor: Colors.green

      ),
    );
  }

  void categoryAlert() {
    var categoryName, CategoryID;
    var alert = new AlertDialog(
      content: Form(
        key: categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Subcategory cannot be empty';
            }
          },
          decoration: InputDecoration(
              hintText: "add Subcategory"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: () {
          if (categoryController.text != null) {
            _categoryService.createsubCat(
                categoryController.text, categoryNameW, CategoryIDW);}
          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }}


class MyPopUpMenuItem<T> extends PopupMenuItem<T> {
  final Widget child;
  final Function onClick;

  var CategoryID;

  var categoryName;
  MyPopUpMenuItem({@required this.child, @required this.onClick ,})
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
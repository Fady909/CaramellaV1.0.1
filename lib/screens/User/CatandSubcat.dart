import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/SubCategories.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:flutter_eapp/widgets/Categoryitems.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'SubCategoryPage.dart';






class CategoriesAndSubCategories extends StatefulWidget {
  static String id = "CategoryiesandSubCategories";
  String CategoryName ;
  CategoriesAndSubCategories({this.CategoryName});
  final store = Store();






  @override
  _CategoriesAndSubCategoriesState createState() => _CategoriesAndSubCategoriesState();
}

class _CategoriesAndSubCategoriesState extends State<CategoriesAndSubCategories> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  var color = Colors.grey.shade600;


  @override
  // TODO: implement widget
  String get categoryNameW => super.widget.CategoryName;

  Store get store => super.widget.store;


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.CategoryName,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.ios_arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              height: 18.0,
              width: 18.0,

            ),
          )],

        backgroundColor: Colors.white,
      ),



      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics (),
        child: Column(children: [

       //   if (widget.CategoryName == 'All') Container(child:  Text ('Check oUR latest Items'))


           if (widget.CategoryName != 'All')Container(
            height: 50,

            child: StreamBuilder<QuerySnapshot>(


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

                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index ) {
                          return Row(

                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[ GestureDetector(
                                  child: Row(

                                      children: [

                                        if (subCategories[index].categoryname == widget.CategoryName)
                                          GestureDetector(
                                            onTap: () {},
                                            child: Card(

                                              shadowColor: kdark,
                                              elevation: 10,
                                              child: Center(
                                                child: (

                                                    FilterChip(
                                                   //   padding: EdgeInsets.all(5.0),
                                                      label: Center(
                                                        child: Text(
                                                          subCategories[index].subCategoryName,
                                                          style: TextStyle(color: Colors.black),
                                                        ),
                                                      ),
                                                      backgroundColor: Colors.transparent,

                                                      onSelected: (bool value) {
                                                        Navigator.of(context).push(

                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                SubCategoryPage(SubCategory :subCategories[index].subCategoryName , Category : subCategories[index].categoryname )


                                                            ,
                                                          ),
                                                        );                                                },
                                                    )),
                                              ),
                                            ),
                                          )


                                        else Text('',  style: TextStyle(fontSize: 0),)








                                      ]
                                  )

                              ),


                                if (subCategories[index].categoryname == widget.CategoryName)
                                  Divider(thickness: 3 , color: Colors.black,),






                              ] ) ;


                        }





                    );


                  } else {
                    return Center(child: Text('Loading ...'));
                  }

                }),



          )



          ,
          CategoryItem(categoryname: widget.CategoryName,) ,




        ]),
      ),



    );
  }}





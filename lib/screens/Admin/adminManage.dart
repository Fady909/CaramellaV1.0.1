

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/screens/Admin/manageCaregories.dart';
import 'package:flutter_eapp/services/category.dart';
import 'package:flutter_eapp/services/store.dart';

import 'manageProducts.dart';

class AdminManage extends StatefulWidget {
  static String id = 'AdminManage';


  final FirebaseFirestore firestore = FirebaseFirestore.instance;




  @override
  _AdminManageState createState() => _AdminManageState();
}
enum Page { dashboard, manage }
class _AdminManageState extends State<AdminManage> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController categoryImage = TextEditingController();

  GlobalKey<FormState> categoryFormKey = GlobalKey();
  CategoryService _categoryService = CategoryService();
  GlobalKey<FormState> brandFormKey = GlobalKey();

  final GlobalKey<FormState> globalKey1 = GlobalKey <FormState> ();

  final store =Store();
  TextEditingController brandController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.change_history),
            title: Text("Manage Products"),
              onTap:() {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return ManageProducts();}));}

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: Text("Add category"),
            onTap: () {
              categoryAlert();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.category),
            title: Text("Manage Categories"),
              onTap:() {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return ManageCategories();}));}
          ),
          Divider(),
        ],
      ),
    );
  }





  void categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: categoryFormKey,
        child:Column(children: [
          TextFormField(

            controller: categoryController,
            validator: (value){
              if(value.isEmpty){
                return 'category cannot be empty';}},
            decoration: InputDecoration(
                hintText: "add category"
            ),
          ),


          TextFormField(

            controller: categoryImage,
            validator: (value){
              if(value.isEmpty){
                return 'image URL cannot be empty';}},
            decoration: InputDecoration(
                hintText: "add Image URL"
            ),
          ),

        ],

        ),

      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(categoryController.text != null){
            _categoryService.createCategory(categoryController.text , categoryImage.text);
          }
          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(onPressed: (){
          categoryImage.clear();
          categoryController.clear();
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);


  }
    
    
    
    
  }

  







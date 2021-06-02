import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

class CategoryService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void createCategory(String name, String imageurl){
  var id = Uuid();
  String categoryId = id.v1();

   _firestore.collection('categories').doc(categoryId).set({
     'category': name,
   'image': imageurl
   });
  }


  void createsubCat (String name , CategoryName , CategoryID){
    _firestore.collection(kpsubCategorycollection).doc().set({'subcategory': name  , 'CategoryName' : CategoryName , 'CategoryID' : CategoryID

    });
  }


}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_eapp/constants.dart';

class subCategoryService{



  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createsubCat (String name , CategoryName , CategoryID){
    _firestore.collection(kpsubCategorycollection).doc().set({'subcategory': name  , 'CategoryName' : CategoryName , 'CategoryID' : CategoryID });
  }




}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Store {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  final FirebaseAuth fireauth = FirebaseAuth.instance;

  User loggeduser;

  final auth = Auth();

  String UN;

  double aftersale;

  var amount;

  var s;

  var points;

  var discount;

  var Storefollowers;

  var banners;

  regSeller(name, email, password, String uid, phone) {
    var ref = firestore.collection(ksellercollection).doc(uid);

    DocumentReference ref2;
    ref2 = firestore.collection('SellerEmails').doc(email);
    ref.set(
        {
          ksellername: name,
          kselleremail: email,
          ksellerpass: password,
          "Phone": phone,
          "Storefollowers": 0,
          ksellerverified: 'No',
          ksellernew: 'yes',}).then((value) =>


        ref2.set(
            {
              ksellername: name,
              kselleremail: email,

            })


    );
  }

  signseller(Email, password, context, RN,  sellercheckedValue) async {


    var email2 = firestore.collection('SellerEmails').doc().collection(
        kselleremail).get();


    var document2 = await firestore.collection('SellerEmails')
        .doc(Email)
        .get()
        .then((value) =>
    value.exists ?

    Navigator.of(context).pushReplacementNamed(RN).then((value) async =>

    sellercheckedValue == true ?
       putsellerinshared(Email,password) : print('notInshared')

    )


        :
    Fluttertoast.showToast(
        msg: "انت لست مسجل لدينا",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20.0)


    );




  }

  addProduct(Product products,) {



    firestore.collection(kproductcollection).add(
        { kProductName: products.Productname,
          kProductPrice: products.Productprice,
          kProductCategory: products.Productcategory,
          kProductDescription: products.Productdescription,
          kproductImage: products.Productimage,
          kProductsubCategory: products.ProductsubCategory,
          kProductdiscount: products.productDiscount,
          ksellername: products.sellername,
          kshopname: products.sellershop,
          kPstate: products.state,
          'sellerID': products.sellerID,
          'product after discount': products.productAfterSale,
          'instock': products.remainingQuantity,
          'TimePosted': products.TimePosted,
          'sellertoken': products.sellerToken,
        //  'colors':  products.colors
        }


    ).then((value) async =>

    await   firestore.collection(kproductcollection).doc(value.id).update({
          'pid': value.id,
          "Colors":FieldValue.arrayUnion(products.colors)
        }).then((value) =>

            FirebaseFirestore.instance
                .collection('SellerReports')
                .doc(fireauth.currentUser.uid).get().then((value) =>
            s = value.get("TotalProducts")
            ).then((value) =>
                FirebaseFirestore.instance
                    .collection('SellerReports')
                    .doc(fireauth.currentUser.uid).update({
                  "TotalProducts": s + 1,

                })


            )


        )


    );













  }

  addcomment(Product products, UserName, Comment, Uid, uphoto) {
    firestore.collection("Products").doc(products.pID)
        .collection('Comments')
        .doc()
        .set(
        {
          'name': UserName,
          "Comment": Comment,
          "Pid": products.pID,
          "Uid": Uid,
          "Uphoto": uphoto,
          "Time": DateTime.now(),


        });
  }


  Stream <QuerySnapshot> loadComments(Product products) {
    return firestore.collection("Products").doc(products.pID).collection(
        "Comments")
        .snapshots();
  }

  Stream <QuerySnapshot> loaduserreportsalltime() {
    return firestore.collection("UserReports")
        .snapshots();
  }


  Stream <QuerySnapshot> loadselelrscashAlltime(sID) {
    return firestore.collection("SellerReports").doc(sID).collection(
        "CashReports").snapshots();
  }


  Stream <QuerySnapshot> loadsellerreportsalltime() {
    return firestore.collection("SellerReports")
        .snapshots();
  }

  Stream <QuerySnapshot> loadusersthismonth() {
    return firestore.collection("UserReports").where("Time",
        isGreaterThan: DateTime.now().subtract(const Duration(days: 30)))
        .snapshots();
  }

  Stream <QuerySnapshot> loadusersthisweek() {
    return firestore.collection("UserReports").where(
        "Time", isGreaterThan: DateTime.now().subtract(const Duration(days: 7)))
        .snapshots();
  }

  Stream <QuerySnapshot> loadsellersthismonth() {
    return firestore.collection("SellerReports").where("DateTime",
        isGreaterThan: DateTime.now().subtract(const Duration(days: 30)))
        .snapshots();
  }

  Stream <QuerySnapshot> loadsellersthisweek() {
    return firestore.collection("SellerReports").where("DateTime",
        isGreaterThan: DateTime.now().subtract(const Duration(days: 7)))
        .snapshots();
  }


  Stream <QuerySnapshot> loadsellerreportsalltimeCashed(sellerID) {
    return firestore.collection("SellerReports").doc(sellerID).collection(
        "CashReports").snapshots();
  }

  Stream <QuerySnapshot> loadsellerthismonthcashed(sellerID) {
    return firestore.collection("SellerReports").doc(sellerID).collection(
        "CashReports")
        .where("TimeOrdered",
        isGreaterThan: DateTime.now().subtract(const Duration(days: 30)))
        .snapshots();
  }

  Stream <QuerySnapshot> loadsellerthisweekcashed(sellerID) {
    return firestore.collection("SellerReports").doc(sellerID).collection(
        "CashReports")
        .where("TimeOrdered",
        isGreaterThan: DateTime.now().subtract(const Duration(days: 7)))
        .snapshots();
  }


  Stream <QuerySnapshot> loadproducts() {
    return firestore.collection(kproductcollection).orderBy(
        'Product Name', descending: true)
        .snapshots();
  }

  Stream <QuerySnapshot> loadHotproducts() {
    return firestore.collection(kproductcollection).where(
        'state', isEqualTo: "Hot")
        .snapshots();
  }


  Stream <QuerySnapshot> loadrecentproducts() {
    return firestore.collection(kproductcollection).orderBy(
        'TimePosted', descending: true)
        .snapshots();
  }


  Stream <QuerySnapshot> LoadSaledproducts() {
    return firestore.collection(kproductcollection).orderBy(
        'Product Discount', descending: true)
        .snapshots();
  }


  Stream <QuerySnapshot> loadproductsspecifyu(sellerID) {
    return firestore.collection(kproductcollection).where(
        'sellerID', isEqualTo: sellerID)
        .snapshots();
  }


  Stream <QuerySnapshot> loadproductsellernewlyarrived(sellerID) {
    return firestore.collection(kproductcollection).where(
        'sellerID', isEqualTo: sellerID).where(
        "TimePosted", isLessThan: DateTime.now())
        .snapshots();
  }

  Stream <QuerySnapshot> loadproductsellerbyHot(sellerID) {
    return firestore.collection(kproductcollection).where(
        'sellerID', isEqualTo: sellerID).where("state", isEqualTo: "Hot")
        .snapshots();
  }

  Stream <QuerySnapshot> loadnewsellers() {
    return firestore.collection(ksellercollection).where(
        'Verified', isEqualTo: 'No').snapshots();
  }

  Stream <QuerySnapshot> loadallsellers() {
    return firestore.collection(ksellercollection).where(
        'Verified', isEqualTo: 'Yes').snapshots();
  }


  Stream <QuerySnapshot> loadFavouriteshops(UID) {
    return firestore.collection('Users').doc(UID)
        .collection("Stores")
        .snapshots();
  }

  Stream <QuerySnapshot> loadAdminStore() {
    return firestore.collection('Admins').snapshots();
  }


  Stream <QuerySnapshot> loadproductsWsearch(productname) {
    return firestore.collection(kproductcollection)
        .where('Product Name', isEqualTo: productname)
        .snapshots();
  }

  Stream <QuerySnapshot> loadproductswithsellerID(productname, sellerID) {
    return firestore.collection(kproductcollection)
        .where('Product Name', isEqualTo: productname).where("sellerID", isEqualTo: sellerID)
        .snapshots();
  }
  
  
  loadproductsaccordingtocategory(categoryname) {
    return firestore.collection(kproductcollection).where(
        'Product Categroy', isEqualTo: categoryname).snapshots();
  }

  loadproductsaccordingtocategoryWsearch(categoryname, productname) {

    /*
    return firestore.collection(kproductcollection).where(
        'Product Categroy'  , isEqualTo: categoryname ).where('Product Name' , isEqualTo: productname.toString().trim()).snapshots();
*/


  }


  Stream <QuerySnapshot> loadOrders(userID) {
    return firestore.collection('Orders')
        .where('UID', isEqualTo: userID)
        .snapshots();
  }





  Stream <QuerySnapshot> loadsellerorders(sellerID) {
    return firestore.collection('Orders')
        .where('sellerID', isEqualTo: sellerID)
        .snapshots();
  }


  loadproductsaccordingtocategoryandsubcategory(categoryname, subcatgoryname) {
    return firestore.collection(kproductcollection).where(
        'Product Categroy', isEqualTo: categoryname).where(
        'Product SubCategory', isEqualTo: subcatgoryname)
        .snapshots();
  }


  deletproduct(documentID) {
    firestore.collection(kproductcollection).doc(documentID).delete();
  }


  editproduct(data, documentID) {
    firestore.collection(kproductcollection).doc(documentID).update(data);
  }

  Stream <QuerySnapshot> loadCategories() {
    return firestore.collection(kpCategorycollection).orderBy(
        'category', descending: false).snapshots();
  }

  deletCategory(documentID) {
    firestore.collection(kpCategorycollection).doc(documentID).delete();
  }


  EditCategory(documentID, data) {
    firestore.collection(kpCategorycollection).doc(documentID).update(data);
  }


  addsubcategory(String name, OcatID, OcatName) {
    var id = Uuid();
    String subcategoryId = id.v1();
    String categoryId = id.v1();
    firestore.collection('subCategory').doc().set({
      'subcategory': name,
      'CategoryName': OcatName,
      'CategoryID ': OcatID,
    });
  }

  deletsubcategory(subcategoryid) {
    firestore.collection(kpsubCategorycollection).doc(subcategoryid).delete();
  }

  Stream <QuerySnapshot> loadSubCat() {
    return firestore.collection('subCategory').snapshots();
  }


  Stream <QuerySnapshot> loadspecialsubcategory(name) {
    return firestore.collection('subCategory').where(
        'CategoryName', isEqualTo: name).snapshots();
  }


  findrithsubs(subID, catID) {
    Query col1 = FirebaseFirestore.instance
        .collection(kpCategorycollection);

    Query col2 = FirebaseFirestore.instance
        .collection(kpsubCategorycollection).where(subID, isEqualTo: catID);
  }


  loadusername() async {
    var userQuery = await firestore.collection('Users').doc(
        fireauth.currentUser.uid)
        .collection('Userdata').doc(fireauth.currentUser.uid)
        .collection('name').get().then((value) => value.docs.toString());


    return userQuery;
  }


  additemtocart(Product products, context, DocumentID, {amount,coorlist}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUID = prefs.getString('UID');


    firestore.collection('Users').doc(userUID).collection('CartItems').doc(
        DocumentID).set(
        { kProductName: products.Productname,
          kProductPrice: products.Productprice,
          kProductCategory: products.Productcategory,
          kProductDescription: products.Productdescription,
          kproductImage: products.Productimage,
          kProductsubCategory: products.ProductsubCategory,
          kProductdiscount: products.productDiscount,
          kproductamountneeded: amount != null ? amount : 1,
          'instock': products.remainingQuantity,
          'product after discount': products.productAfterSale.toString(),
          'sellername': products.sellername,
          'sellershop': products.sellershop,
          'sellerID': products.sellerID,
          'sellertoken': products.sellerToken,
          "colors" : coorlist
        }


    ).catchError(print).whenComplete(() => _alert(context));
  }


  addnumberitem(Product products, context, DocumentID, {amount}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUID = prefs.getString('UID');


    if (products.productDiscount == '' || products.productDiscount == null) {
      aftersale = double.parse(products.Productprice);
    }
    else {
      aftersale = int.parse(products.Productprice) -
          (int.parse(products.Productprice) *
              int.parse(products.productDiscount) / 100);
    }

    firestore.collection('Users').doc(userUID).collection('CartItems').doc(
        DocumentID).set(
        { kProductName: products.Productname,
          kProductPrice: products.Productprice,
          kProductCategory: products.Productcategory,
          kProductDescription: products.Productdescription,
          kproductImage: products.Productimage,
          kProductsubCategory: products.ProductsubCategory,
          kProductdiscount: products.productDiscount,
          kproductamountneeded: amount != null ? amount : 1,
          'instock': products.remainingQuantity,
          'product after discount': aftersale.toString(),
          'sellername': products.sellername,
          'sellershop': products.sellershop,
          'sellerID': products.sellerID
        }


    );
  }


  updateamount(Product products, context, DocumentID, dataupdate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUID = prefs.getString('UID');
    firestore.collection('Users').doc(userUID).collection('CartItems').doc(
        DocumentID).update(

        { kproductamountneeded: dataupdate}

    );
  }


  _alert(BuildContext context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.shrink,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 250),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: "سله التسوق",
      desc: "تمت اضافة المنتج المطلوب لسلة التسوق",
      buttons: [
        DialogButton(
          child: Text(
            "موافق",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),

      ],
    ).show();
  }

  additemtoFavourite(Product products, context, DocumentID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUID = prefs.getString('UID');


    firestore.collection('Users').doc(userUID).collection('LikedItems').doc(
        DocumentID).set(
        { kProductName: products.Productname,
          kProductPrice: products.Productprice,
          kProductCategory: products.Productcategory,
          kProductDescription: products.Productdescription,
          kproductImage: products.Productimage,
          kProductsubCategory: products.ProductsubCategory,
          kProductdiscount: products.productDiscount,
          ksellername: products.sellername,
          kshopname: products.sellershop,
          kPstate: products.state,
          'sellerID': products.sellerID,
          'product after discount': products.productAfterSale,
          'instock': products.remainingQuantity,
          'TimePosted': products.TimePosted,
         'colors': products.colors

        }


    ).catchError(print);
  }

  removeitemFromFavourite(Product products, context, documentID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUID = prefs.getString('UID');
    firestore.collection('Users').doc(userUID).collection('LikedItems').doc(
        documentID).delete();
  }

  removeitemFromCart(Product products, context, documentID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUID = prefs.getString('UID');
    firestore.collection('Users').doc(userUID).collection('CartItems').doc(
        documentID).delete();
  }


  Stream <QuerySnapshot> loadcartitems(UID) {
    return firestore.collection('Users').doc(UID)
        .collection('CartItems')
        .snapshots();
  }

  Stream <QuerySnapshot> LoadFavourieItems(UID) {
    return firestore.collection('Users').doc(UID).collection('LikedItems')
        .snapshots();
  }


  followStore(context, sellername, sellerID, number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUID = prefs.getString('UID');

    firestore.collection('Users').doc(userUID).collection('Stores').doc(
        sellerID).set(
        { ksellername: sellername,
          "SellerID": sellerID
        }


    ).then((value) async =>

    await firestore.collection('Sellers').doc(sellerID).update({
      "Storefollowers": number + 1
    })
        .catchError(print));
  }

  unfollowstore(context, sellername, sellerID, number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUID = prefs.getString('UID');

    firestore.collection('Users').doc(userUID).collection('Stores').doc(
        sellerID).delete()

        .then((value) async =>

    await firestore.collection('Sellers').doc(sellerID).update({
      "Storefollowers": number - 1
    })
        .catchError(print));
  }




   Future<bool> checkfollowstate(context, sellername , sellerID) async {
    bool exists = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String  userUID =  prefs.getString('UID');
    try {
      await firestore.collection('Users').doc( userUID).collection('Stores').doc(sellerID).get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checksellerproductstate(context, sellername , sellerID) async {
    bool exists = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String  userUID =  prefs.getString('UID');
    try {
      await firestore.collection(kproductcollection).where('sellerID', isEqualTo: sellerID).get().then((doc) {

        if (doc.docs.isNotEmpty)
{          exists = true;
print(doc.docs.length);

}
        else
          exists = false;
      });

      return exists;
    } catch (e) {
      return false;
    }
  }



managepoints( userID ,qu )async{

  await firestore.collection('Users').doc(userID).collection('Userdata').doc(userID)
      .get().then((value) =>
  points = value.get("Points")
  ).then((value) =>
      firestore.collection('Users').doc(userID).collection('Userdata').doc(userID).update({
        "Points": points + qu
      }));


}

checkpoints(userID )async{

  String totalpoints;
  await firestore.collection('Users').doc(userID).collection('Userdata').doc(userID)
      .get().then((value) =>
  points = value.get("Points")
  ).then((value) =>
  totalpoints = value.toString()
   );

return totalpoints;
}


  checkstorefollowers(selleridd )async{
    String followers;
    await firestore.collection('Sellers').doc(selleridd)
        .get().then((value) =>
    Storefollowers = value.get("Storefollowers")
    ).then((value) =>
    followers = value.toString()
    );
    return followers;
  }

  incresefollowers (sellerid , number)  async {

    await firestore.collection('Sellers').doc(sellerid).update({
      "Storefollowers" : number+1

    });
  }


  addCoupon (context, couponename , value ,validity, which ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String  userUID =  prefs.getString('UID');

    firestore.collection('Users').doc( userUID).collection('Coupones').doc(which.toString()).set(
        { "Coupon" :  couponename,
          "which" :  which,
          "DiscountValue" : value,
          "ValuedTill" : validity ,
          "taken?" : "No",
          "TimeGiven": DateTime.now()
        }


    ).then((value) => _emptyalert(context, 'مبروك',
        which.toString() +"أنت الآن تتمتع بكوبون خصم الـ "

    )
    ).catchError(print);
  }
  checkcoupon(userID )async{
    var which;


    await firestore.collection('Users').doc(userID).collection('Coupones').get().then(((snapShot) async {
      snapShot.docs.forEach((doc) {
        which = doc.get("which");
      });

    }));
    print(which.toString());
 return which;
  }


  checkwhich (userID, which) async{
    bool istaken;
    await firestore.collection('Users').doc(userID).collection('Coupones').doc(which.toString()).get().then((value) =>
    istaken =  value.exists ?  true :  false
    );

    return istaken;
  }





  _emptyalert(BuildContext context , title, desc) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.shrink,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 250),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: klight
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: title,
      desc:desc,
      buttons: [
        DialogButton(
          child: Text(
            "موافق",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: kdark
        ),

      ],
    ).show();
  }

  Stream <QuerySnapshot> loadCoupones(UID) {

    return firestore.collection('Users').doc(UID).collection('Coupones')
        .snapshots();

  }


  addGeneralCoupon (couponename , value ,validity , couponcomment) async {
    firestore.collection('Coupones').doc("General").set(
        { "Coupon" :  couponename,
          "which" :  "General",
          "DiscountValue" : int.parse(value),
          "ValuedTill" : int.parse(validity) ,
          "TimeGiven": DateTime.now(),
          "Comment": couponcomment
        }



    ).then((value) =>
        Fluttertoast.showToast(
            msg: "تم وضع الكوبون بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0
        )



    ).catchError(print);
  }




  checksellercoupones(sellerID )async{

    var discountvalue;
    await firestore.collection('Coupones').doc(sellerID)
        .get().then((value) =>
    value.exists == true ?  discount = value.data()['DiscountValue'].toString(): discount = 0


    ).then((value) =>
    discountvalue = discount
    );
print(discountvalue.toString());
    return discountvalue;
  }
  checksellerbanner(sellerID )async{

    var banner;
    await firestore.collection('Sellers').doc(sellerID)
        .get().then((value) =>
    value.exists == true ?  banner = value.data()['banner'].toString(): null


    ).then((value) =>
    banners = banner
    );
    return banner;
  }



  Future<bool>  checkphone(phone) async{
 var ava;
 await firestore.collection('Sellers').doc(phone.toString())
     .get().then((value) =>

     value.data()['Phone'] != null ?ava = "ns" : ava = "askd"



 );
 return ava;

  }
  checkgeneralcoupon( )async{

    var comment;
    await firestore.collection('Coupones').doc("General")
        .get().then((value) =>
    value.exists == true ?  comment = value.data()['Comment'].toString()


        : comment = ""


    ).then((value) =>
    comment = comment
    );
    print(comment.toString());
    return comment;
  }






  Future<bool> callOnFcmApiSendPushNotifications(token , body , title) async {




    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "notification": {"body": body , "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
      'key=AAAAeCkTKrg:APA91bEbzyLIyd_sEfTRkrQ7cdduy2a3SwBPsIaCfnHS7aHpAR98MXmZaConlGPyBAWVJbP6KjHkuIdzhh74Bl6BoA-2qkAD6XTsloHqFOdfiJUM3FseL81DzCzLd3kbtXwCTNtspAJU'
    };

    print('show response');

    final response = await Dio()
        .post(postUrl, data: data, options: Options(headers: headers));
    print(response.statusCode);
    if (response.statusCode == 200) {
      // on success do sth
      print('test Done');
      return true;
    } else {
      print(' FCM error');
      // on failure do sth
      return false;
    }
  }

  putsellerinshared(email , password) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selleremail', email);
    await prefs.setString("sellerpassword", password);
    print('SellerInshared');
  }


}
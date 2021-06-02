import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/models/Coupones.dart';
import 'package:flutter_eapp/models/Sellers.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants.dart';


class AdminSellerControl extends StatefulWidget {
  static String id = 'AdminSellerControl';

  @override
  _AdminSellerControlState createState() => _AdminSellerControlState();


}

class _AdminSellerControlState extends State<AdminSellerControl> {

  var store = Store();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var couponname = TextEditingController();
  var couponvalue = TextEditingController();
  var couponvalidity = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: .0,
        title: Text('كل البائعين' , style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          FlatButton(
            child: Text('رجوع'),
            textColor: Colors.black, onPressed: () {  },
            // onPressed: onSave,
          )
        ],
      ),
      body: Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey,
              Colors.blueAccent,
            ],
            begin: Alignment.center,
            end: Alignment.bottomLeft,
          ),
        ),


        child: Showallsellers(),
        /*
        child: ListView.builder(


          addAutomaticKeepAlives: true,
          itemCount: 12,
             itemBuilder: (_, i) =>[],


        ),

        */
      ),

    );









  }

  Widget  Showallsellers() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: store.loadallsellers(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length == 0){

                return Center(
                  child: Text('لا يوجد بائعين'),
                );
              }

              else
                print('has');
              List<Sellers> sellers = [];
              for (var doc in snapshot.data.docs) {var data = doc.data(); sellers.add(Sellers(
                isnew: data['IsNew'],
                sellername: data['Seller Name'],
                seller_email: data['Email'],
                verified: data['Verified'],
                shopname:data['Store Name'],
                starseller: data['StarSellers'],
                storeproducts: data['Store Products'],
                address:  data['Address'] ,
                phone:  data['Phone'],
                //             photo: data['photo'],
                uid: data['uid'],
                adminpercent: data['adminpercent'] != null ? data['adminpercent']: 0.0


                // ignore: missing_return
              ));}

              return    ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: sellers.length,

                itemBuilder: (context, index) {
                  return  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppBar(
                        leading: GestureDetector(
                            onTap: (){

                              firestore.collection(ksellercollection).doc(sellers[index].uid).delete();
                              firestore.collection(kproductcollection).where('Seller Name',isEqualTo: sellers[index].sellername)
                                  .where('Seller shop',isEqualTo: sellers[index].shopname).
                              get().then((snapshot) {
                                for (DocumentSnapshot ds in snapshot.documents){
                                  ds.reference.delete();
                                };
                              });

                            },
                            child: Icon(Icons.auto_delete)),
                        elevation: 0,
                        title: Text('بائع'),
                        backgroundColor: Colors.white24,
                        centerTitle: true,
                        actions: <Widget>[
                          GestureDetector(
                              onTap:(){

                                firestore.collection(ksellercollection).doc(sellers[index].uid).update({
                                  'Verified': 'No'
                                });


                              }


                              ,
                              child: Icon(Icons.remove_circle_outlined , color: Colors.red,)),
                          //   onPressed: verify(sellers[index].seller_email),

                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].phone,
                          decoration: InputDecoration(
                            labelText: 'الاسم بالكامل',
                            hintText: 'Enter your full name',
                            icon: Icon(Icons.person),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].seller_email,
                          decoration: InputDecoration(
                            labelText: 'البريد الالكتروني',
                            hintText: 'Enter your email',
                            icon: Icon(Icons.email),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].address,
                          decoration: InputDecoration(
                            labelText: 'العنوان',
                            // hintText: 'Enter your email',
                            icon: Icon(Icons.email),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].phone,
                          decoration: InputDecoration(
                            labelText: 'رقم التليفون',
                            // hintText: 'Enter your email',
                            icon: Icon(Icons.phone),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].shopname,
                          decoration: InputDecoration(
                            labelText: 'اسم المتجر',
                            // hintText: 'Enter your email',
                            icon: Icon(Icons.shop),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].storeproducts,
                          decoration: InputDecoration(
                            labelText: 'منتجات المتجر',
                            // hintText: 'Enter your email',
                            icon: Icon(Icons.shopping_bag_outlined),
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: sellers[index].starseller,
                          decoration: InputDecoration(
                            labelText: 'بائع متميز',
                            // hintText: 'Enter your email',
                            icon: Icon(Icons.star),
                            isDense: true,
                          ),
                        ),
                      ),
    GestureDetector(
        onTap: (){
          showandaddsellercoupones(context , sellers[index]);

        },
        child: Center(child: Container(height: 40, width: 100,child: Card(elevation: 12 , color:  klight, child: Text('   اضافة كوبون'),)),)),
                      SizedBox(height: 20,),

                    ],
                  );

                },
              );
            } else {
              return Center(child:

              Text('Loading ...'));
            }

          }),
    );




  }

  void showandaddsellercoupones(BuildContext context, Sellers seller) {
    {
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
        title: seller.sellername,
        desc:"اضافة كوبون خصم",
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
        content: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 100,
                child: Theme(
                  data: new ThemeData(
                    primaryColor: klight,
                    primaryColorDark: kdark,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextField(
                                  controller: couponname,

                                  decoration: InputDecoration(

                                    border: OutlineInputBorder(

                                      borderSide: BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color: klight,

                                      ),
                                    ),
                                    labelText: 'اسم الكوبون',
                                    labelStyle: TextStyle(color: Colors.black),
                                    hintStyle: TextStyle(fontSize: 20.0, color: klight),


                                  ))))),
                ),
              ),
              Container(
                height: 100,
                child: Theme(
                  data: new ThemeData(
                    primaryColor: klight,
                    primaryColorDark: kdark,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextField(
                                  controller: couponvalue,

                                  decoration: InputDecoration(

                                    border: OutlineInputBorder(

                                      borderSide: BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color: klight,

                                      ),
                                    ),
                                    labelText: 'قيمة الخصم',
                                    labelStyle: TextStyle(color: Colors.black),
                                    hintStyle: TextStyle(fontSize: 20.0, color: klight),


                                  ))))),
                ),
              ),
              Container(
                height: 100,
                child: Theme(
                  data: new ThemeData(
                    primaryColor: klight,
                    primaryColorDark: kdark,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextField(
                                  controller: couponvalidity,
                                  decoration: InputDecoration(

                                    border: OutlineInputBorder(

                                      borderSide: BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color: klight,

                                      ),
                                    ),
                                    labelText: 'مدة الكوبون',
                                    labelStyle: TextStyle(color: Colors.black),
                                    hintStyle: TextStyle(fontSize: 20.0, color: klight),


                                  ))))),
                ),
              ),

              Center(
                child:   Container(

                  height: 50,

                  width: 150,

                  color: klight,

                  child:   Card(
                      elevation: 10,
                      color: klight,


                      child: Center(child: GestureDetector(
                          onTap: (){

                            addcoupon(couponname,couponvalidity,couponvalue, seller);

                          },
                          child: Text('أضف الكوبون')))),

                ),
              )
              ,
           LoadCoupones(seller),



            ],


          ),



        ],)
      ).show();
    }



  }


  Widget  LoadCoupones(Sellers seller) {
    return Container(
      height: 150,
width: double.maxFinite,
      child: StreamBuilder<QuerySnapshot>(
        stream:firestore.collection('Coupones').where("uid",isEqualTo:  seller.uid)
            .snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            List<Coupones> coupones = [];
            for (var doc in snapshot.data.docs) {var data = doc.data(); coupones.add(Coupones(
              data['Coupon'],
              null,
              null,
              data['TimeGiven'],
              data['DiscountValue'],
              data['ValuedTill'],


              // ignore: missing_return
            ));}

            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context,int index){

                return new  Column(


                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  GestureDetector(
                      onTap: (){

                        firestore.collection('Coupones').doc(seller.uid).delete();

                      },
                      child: Icon(Icons.clear))
                  ,
                    Card(
                        elevation: 10,
                        color: klight,
                        child: Text(coupones[index].Coupon)),
                    SizedBox(height: 10,),

                    Text("  خصم %"+coupones[index].DiscountValue.toString()),
                    SizedBox(width: 50,),
                    Text("  المدة المتاحة  : "+coupones[index].ValuedTill.toString()+ "   يوم  "),

                  ],);

              },
              itemCount: coupones.length,

            );
          } else {
            return Center(child: Text('يتم التحميل'));
          }


        },
      ),
    );


  }






  void addcoupon(TextEditingController couponname, TextEditingController couponvalidity, TextEditingController couponvalue, Sellers seller) {


    if (couponname.text != null && couponname.text.isNotEmpty == true &&couponvalidity.text != null && couponvalidity.text.isNotEmpty == true &&couponvalue.text != null && couponvalue.text.isNotEmpty == true )

    {





      firestore.collection('Coupones').doc(seller.uid).set(
          { "Coupon" :  couponname.text,
            "which" :  "Seller",
            "DiscountValue" : int.parse(couponvalue.text),
            "ValuedTill" : int.parse(couponvalidity.text) ,
            "TimeGiven": DateTime.now(),
            "uid" : seller.uid
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



couponname.clear();
couponvalidity.clear();
couponvalue.clear();




    }

    else


      Fluttertoast.showToast(
          msg: "لا يمكن ترك أيمن الحقول فارغ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0
      );


  }



}

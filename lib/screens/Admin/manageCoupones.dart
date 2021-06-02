import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/Coupones.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:fluttertoast/fluttertoast.dart';

class manageCoupones extends StatelessWidget {
  static String id = 'manageCoupones';
  var couponname = TextEditingController();
  var couponvalue = TextEditingController();
  var couponvalidity = TextEditingController();
  var couponcomment = TextEditingController();

  var store = Store();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {



    return Scaffold  (
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: .0,
        title: Text('كوبونات الخصم' , style: TextStyle(color: Colors.black),),

      ),

      body: manage(),
    );
  }

Widget  manage() {
 return   SingleChildScrollView(
      child: Column(
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

                              controller: couponcomment,
                              decoration: InputDecoration(

                                border: OutlineInputBorder(

                                  borderSide: BorderSide(
                                    width: 2,
                                    style: BorderStyle.solid,
                                    color: klight,

                                  ),
                                ),
                                labelText: "المناسبة",
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

              addcoupon(couponname,couponvalidity,couponvalue, couponcomment);

            },
            child: Text('أضف الكوبون')))),

  ),
)

, Divider(thickness: 2,),
Center(child: Text('بيانات آخر كوبون'),)    ,


          LoadCoupones(),



        ],


      ),


    );



}

  void addcoupon(TextEditingController couponname, TextEditingController couponvalidity, TextEditingController couponvalue, TextEditingController couponcomment) {


    if (couponname.text != null && couponname.text.isNotEmpty == true &&couponvalidity.text != null &&
        couponvalidity.text.isNotEmpty == true && couponvalue.text != null && couponvalue.text.isNotEmpty == true &&
    couponcomment.text != null && couponcomment.text.isNotEmpty == true

    )

    {

store.addGeneralCoupon(couponname.text , couponvalue.text , couponvalidity.text , couponcomment.text);
couponname.clear();
couponvalue.clear();
couponvalidity.clear();
couponcomment.clear();
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

Widget  LoadCoupones() {
    return Container(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
        stream:firestore.collection('Coupones').where("which",isEqualTo:  "General")
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
              Comment: data['Comment']


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

                          firestore.collection('Coupones').doc("General").delete();

                        },
                        child: Icon(Icons.clear)),
                    Card(
                    elevation: 10,
                    color: klight,
                    child: Text(coupones[index].Coupon)),
                    SizedBox(height: 10,),

                    Text("  خصم %"+coupones[index].DiscountValue.toString()),
                    SizedBox(width: 50,),
                    Text("  المدة المتاحة  : "+coupones[index].ValuedTill.toString()+ "   يوم  "),
                    Text("  التعليق عليه  : "+coupones[index].Comment.toString()),
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
}



import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/models/Coupones.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants.dart';
import 'SubCategoryPage.dart';
import 'home.dart';

class PointsPage extends StatefulWidget {
  static String id = 'Points';
  final auth = Auth();
    var loggeduser = fireauth.currentUser;
  final store = Store();
var points="0";
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  @override
  Widget build(BuildContext context) {
    var mywidth = MediaQuery.of(context).size.width;
    var myheight = MediaQuery.of(context).size.height;
    double rectWidth = MediaQuery.of(context).size.width*0.250;
    double rectHeight = MediaQuery.of(context).size.width*.07;
    double trendCardWidth = MediaQuery.of(context).size.width*0.5;

    return  Scaffold(
      appBar: AppBar(

        title: Text(
          "النقاط",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.ios_arrow_back,
              color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacementNamed(Home.id),
        ),
        backgroundColor: kdark,


      ),
      body: showpoints(),
    );



  }

  @override
  void initState() {
    checkpoints();
  }

  Widget showpoints() {
    return SingleChildScrollView(
      child: Column(children: [
        Image(image: NetworkImage('https://www.webwise.ie/wp-content/uploads/2018/11/Prizes-1.png'),),
        SizedBox(height: 70,),
        Center(child: Text('اجمالي النقاط'),),
        SizedBox(height: 20,),




    Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 100,
      width: 200,
      decoration: BoxDecoration(
      border: Border.all(
      color: kdark,
      ),
      borderRadius: BorderRadius.only(topRight: Radius.circular(100), topLeft: Radius.circular(100))
      ),


              child: Center(child: Text(widget.points, style: TextStyle(fontSize: 50),) ,)),
    ),




        SizedBox(height: 20,),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 20,),
            GestureDetector(
                onTap: (){
                  generatecode();

                },
                child: Container(
                  width: 100,
                  child: Card(
                      elevation: 10,
                      child: Center(child: Text("اضغط هنا", style: TextStyle(fontSize: 15 , color: klight) ,))),
                )),
            SizedBox(width: 30,),
            Text('للحصول علي كوبون الخصم'),
            SizedBox(width: 20,),

          ],),
        SizedBox(height: 20,),
        Divider(thickness: 1,),
        SizedBox(height: 20,),
        coupones(),

       // Divider(thickness: 2,),
       //  SizedBox(height: 20,),
       //  Row(
       //    mainAxisAlignment: MainAxisAlignment.end,
       //    children: [
       //
       //    Text(' : لفهم نظام النقاط إقرأ  التالي'),
       //      SizedBox(width: 20,),
       //
       //  ],),
       //  SizedBox(height: 50,),
       //
       //  Center(child: Text('لكل 20 نقطة -> تحصل علي 1% خصم'),),
       //  Center(child: Text('لكل 40 نقطة -> تحصل علي 3% خصم'),),
       //  Center(child: Text('لكل 60 نقطة -> تحصل علي 5% خصم'),),
       //  Center(child: Text('لكل 100 نقطة -> تحصل علي 10% خصم'),),
       //  SizedBox(height: 20,),
       //  SizedBox(height: 20,),
       //




      ],),
    );


 }

  void checkpoints() async {
    widget.points =  await widget.store.checkpoints(widget.loggeduser.uid);
    setState(() {
      print (widget.points);

    });


  }

  Future<void> generatecode() async {

    Random random = new Random();
    int randomNumber = random.nextInt(5000);
    if (int.parse(widget.points) <= 0  ){

      _alert(context, "لا تتواجد نقاط كافية", "قم بتجميع نقاط أكثر لتكسب خصومات أكثر");

    }

    if (int.parse(widget.points) > 0 &&int.parse(widget.points) < 20 ){

      _alert(context, "لا توجد خصومات لهذا العددمن النقاط", "قم  بتجميع أكثرمن 20 نقطه للبدء في كسب النقاط");
    }



if (int.parse(widget.points) > 20 &&int.parse(widget.points) < 40 ){

var add;
add = await widget.store.checkwhich(widget.loggeduser.uid, 20);
if (add == false){  widget.store.addCoupon(context, "minC"+randomNumber.toString() , 1 , 30 , 20);}
else if (add == true) {

  _alert(context, "كوبون مستعمل", "لقد استنفذت هذا الكوبون من قبل");

}

}
if (int.parse(widget.points) > 40 &&int.parse(widget.points) < 60 ){


  var add;
  add = await widget.store.checkwhich(widget.loggeduser.uid, 40);
  if (add == false){    widget.store.addCoupon(context, "MedCa"+randomNumber.toString() , 3 , 30 , 40);}
  else if (add == true) {


    _alert(context, "كوبون مستعمل", "لقد استنفذت هذا الكوبون من قبل");

  }








}
if (int.parse(widget.points) > 60 &&int.parse(widget.points) < 100 ){


  var add;
  add = await widget.store.checkwhich(widget.loggeduser.uid, 60);
  if (add == false){    widget.store.addCoupon(context, "MeXa"+randomNumber.toString() , 5 , 30 , 60);}
  else if (add == true) {


    _alert(context, "كوبون مستعمل", "لقد استنفذت هذا الكوبون من قبل");



  }








}
if (int.parse(widget.points) >= 100 &&int.parse(widget.points) < 200 ){




  var add;
  add = await widget.store.checkwhich(widget.loggeduser.uid, 100);
  if (add == false){    widget.store.addCoupon(context, "MaxxI"+randomNumber.toString() , 10 , 30 , 100);}
  else if (add == true) {

    _alert(context, "كوبون مستعمل", "لقد استنفذت هذا الكوبون من قبل");


  }






}






  }




  _alert(BuildContext context , title, desc) {
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
        color: klight,
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.info,
      title: title,
      desc:desc,
      buttons: [
        DialogButton(
          child: Text(
            "موافق",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: kdark,
        ),

      ],
    ).show();
  }

Widget  coupones() {
    return  Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        height: 100,
        child: StreamBuilder<QuerySnapshot>(
            stream: widget.store.loadCoupones(widget.loggeduser.uid),
  builder: (context, snapshot){
        if (snapshot.hasData) {
          List<Coupones> coupones = [];
          for (var doc in snapshot.data.docs) {var data = doc.data(); coupones.add(Coupones(
            data['Coupon'],
            data['taken?'],
            data['which'],
            data['TimeGiven'],
            data['DiscountValue'],
            data['ValuedTill'],


            // ignore: missing_return
          ));}

          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context,int index){

              return new  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  coupones[index].taken == "No" ? Text("لم يستخدم", style: TextStyle(color: Colors.green),) : Text("تم استخدامه" ,style: TextStyle(color: Colors.red)),
                  SizedBox(width: 50,),

                  Text("  خصم %"+coupones[index].DiscountValue.toString()),
                  SizedBox(width: 50,),
              Card(
                  elevation: 10,
                  color: klight,
                  child: Text(coupones[index].Coupon)),
                ],);

            },
            itemCount: coupones.length,

          );
        } else {
          return Center(child: Text('يتم التحميل'));
        }


  },
        ),
      ),
    );

}


}




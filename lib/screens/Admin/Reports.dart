
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_eapp/constants.dart';
import 'package:flutter_eapp/models/SellerReports.dart';
import 'package:flutter_eapp/models/UsersReports.dart';
import 'package:flutter_eapp/screens/Admin/CashedReports.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reports extends StatefulWidget

{



  static  const id= "Reports";

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var store = Store();

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  final FirebaseAuth fireauth = FirebaseAuth.instance;
  int _value = 1;
  int _value2 = 1;
  int _value3 = 1;

  User loggeduser;
  var sellers = 0;

  final auth = Auth();

  var products = 0;

  var Orders = 0;

  @override
  Widget build(BuildContext context) {
    return
      DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('الإحصائيات'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('في الاسبوع'),),
                Tab(child: Text('في الشهر'),),
                Tab(child: Text('الكل'),),
              ],


            ),

          ),
        body:TabBarView(
          children: [
           Thisweek(),
            ThisMonth(),
             AllTime(),
          ],
        ),
        ),
      );






  }


  @override
  void initState() {
    loadallsellers();
  }

  Future <int> loadallsellers() async {
    var getorders;
    var getseller;
  await  firestore.collection(ksellercollection).get().then((value) =>
    getseller=            value.docs.length);

 var getproducts;
 await firestore.collection("Products").get().then((y) =>
 getproducts=            y.docs.length).then((value) =>

  firestore.collection('Orders').get().then((x) =>
 getorders =  x.docs.length.toInt())

 ).then((value) =>

     setState(() {
       products = getproducts;
       sellers = getseller;
       Orders = getorders;
     })

 );










}

Widget  AllTime() {

return    Column(
      children: [

    Container(
    padding: EdgeInsets.all(20.0),
  child: DropdownButton(
  value: _value,
  items: [
  DropdownMenuItem(
  child: Text("مستخدمين"),
  value: 1,
  ),
  DropdownMenuItem(
  child: Text("بائعين"),
  value: 2,
  ),


  ],
  onChanged: (value) {
  setState(() {
  _value = value;
  });
  }),


    ),
        Container(
          child: _value == 1 ? loadusers() : loadsellers(),

        )


      ],

    );

}

 Widget loadusers() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: store.loaduserreportsalltime(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Text("لا يوجد طلبات بعد"),
                );
              }

              else
                print('has');
              List<UserReports> userrepoets = [];
              for (var doc in snapshot.data.docs) {
                var data = doc.data();
                userrepoets.add(UserReports(
                  data['AskedOrders'],
                  data['CancelledOrders'],
                  data['CompletedOrders'],
                  data['Email'],
                  data['Phone'],
                  data['name'],
                  data['photo'],
                  data['uid'],
                  data['Time'],


                ));
              }



              return Column(
                children: [
                  Center(child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [

      Text(' المنتجات الراجعه'),
      Text('المنتجات المكتمله'),
      Text('اسم المستخدم'),

    ],),),
            ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: userrepoets.length,

            itemBuilder: (context, index) {
            return   Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(userrepoets[index].CancelledOrders.toString()),
                Text(userrepoets[index].CompletedOrders.toString()),
                Text(userrepoets[index].name),

              ],),);

            },
            ),







],              );


            } else {
              return Center(child:

              Text('Loading ...'));
            }
            ;
          }),
    );


 }





  Widget loadsellers() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: store.loadsellerreportsalltime(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text("لا يوجد طلبات بعد"),
                  );
                }

                else
                  print('has');
                List<SellerReports> sellerreports = [];
                for (var doc in snapshot.data.docs) {
                  var data = doc.data();
                  sellerreports.add(SellerReports(
                    data['ProductsSold'],
                    data['TotalProducts'],
                    data['Seller E-mail'],
                    data['Phone'],
                    data['Seller Name'],
                    data['SellerID'],
                   data["DateTime"],


                  ));
                }



                return Column(
                  children: [
                    Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text('المنتجات المباعه'),
                        Text('عدد المنتجات'),
                        Text('اسم البائع'),

                      ],),),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: sellerreports.length,

                      itemBuilder: (context, index) {
                        return   Center(

                       child :   Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [


                                  Text(sellerreports[index].TotalProducts.toString()),
                                  Text(sellerreports[index].ProductsSold.toString()),
                                  GestureDetector(
                                      onTap: (){

                                        Navigator.of(context).push(

                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CashedReports(sellerdata :sellerreports[index].SellerID)


                                            ,
                                          ),


                                        );

                                      },
                                      child: Row(children: [
                                      Text(sellerreports[index].Seller_Name != null ? sellerreports[index].Seller_Name : " " ),
                                      Icon(Icons.edit)

                                      ],),

                                  )],),
                              SizedBox(height: 10),

                            ],

                          ));

                      },
                    ),







                  ],              );


              } else {
                return Center(child:

                Text('Loading ...'));
              }
              ;
            }),
      ),
    );


  }

  ThisMonth() {

    return    Column(
      children: [

        Container(
          padding: EdgeInsets.all(20.0),
          child: DropdownButton(
              value: _value2,
              items: [
                DropdownMenuItem(
                  child: Text("مستخدمين"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("بائعين"),
                  value: 2,
                ),


              ],
              onChanged: (_val2) {
                setState(() {
                  _value2 = _val2;
                });
              }),


        ),
        Container(
          child: _value2 == 1 ? loadusersthismonth() : loadsellersthismonth(),

        )


      ],

    );

  }

  Thisweek() {

    return    Column(
      children: [

        Container(
          padding: EdgeInsets.all(20.0),
          child: DropdownButton(
              value: _value3,
              items: [
                DropdownMenuItem(
                  child: Text("مستخدمين"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("بائعين"),
                  value: 2,
                ),


              ],
              onChanged: (_val3) {
                setState(() {
                  _value3 = _val3;
                });
              }),


        ),
        Container(
          child: _value3 == 1 ? loadusersthisweek() : loadsellersthisweek(),

        )


      ],

    );

  }

  Widget loadusersthismonth() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: store.loadusersthismonth(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text("لا يوجد احد بعد"),
                  );
                }

                else
                  print('has');
                List<UserReports> userrepoets = [];
                for (var doc in snapshot.data.docs) {
                  var data = doc.data();
                  userrepoets.add(UserReports(
                    data['AskedOrders'],
                    data['CancelledOrders'],
                    data['CompletedOrders'],
                    data['Email'],
                    data['Phone'],
                    data['name'],
                    data['photo'],
                    data['uid'],
                    data['Time'],


                  ));
                }



                return Column(
                  children: [
                    Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(' المنتجات الراجعه'),
                        Text('المنتجات المكتمله'),
                        Text('اسم المستخدم'),

                      ],),),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: userrepoets.length,

                      itemBuilder: (context, index) {
                        return   Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(userrepoets[index].CancelledOrders.toString()),
                            Text(userrepoets[index].CompletedOrders.toString()),
                            Text(userrepoets[index].name != null ?userrepoets[index].name : "non" ),

                          ],),);

                      },
                    ),







                  ],              );


              } else {
                return Center(child: Text('Loading ...'));

              }

            }),
      ),
    );


  }





  Widget loadsellersthismonth() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: store.loadsellersthismonth(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text("لا يوجد احد بعد"),
                  );
                }

                else
                  print('has');
                List<SellerReports> sellerreports = [];
                for (var doc in snapshot.data.docs) {
                  var data = doc.data();
                  sellerreports.add(SellerReports(
                    data['ProductsSold'],
                    data['TotalProducts'],
                    data['Seller E-mail'],
                    data['Phone'],
                    data['Seller Name'],
                    data['SellerID'],
                    data["DateTime"]


                  ));
                }



                return Column(
                  children: [
                    Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text('المنتجات المباعه'),
                        Text('عدد المنتجات'),
                        Text('اسم البائع'),

                      ],),),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: sellerreports.length,

                      itemBuilder: (context, index) {
                        return   Center(

                            child :   Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [


                                    Text(sellerreports[index].TotalProducts.toString()),
                                    Text(sellerreports[index].ProductsSold.toString()),
                                    GestureDetector(
                                        onTap: (){



                                        },
                                        child: Text(sellerreports[index].Seller_Name)),

                                  ],),
                                SizedBox(height: 10),

                              ],

                            ));

                      },
                    ),







                  ],              );


              } else {
                return Center(child:

                Text('Loading ...'));
              }
              ;
            }),
      ),
    );


  }

  Widget loadusersthisweek() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: store.loadusersthisweek(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text("لا يوجد احد بعد"),
                  );
                }

                else
                  print('has');
                List<UserReports> userrepoets = [];
                for (var doc in snapshot.data.docs) {
                  var data = doc.data();
                  userrepoets.add(UserReports(
                    data['AskedOrders'],
                    data['CancelledOrders'],
                    data['CompletedOrders'],
                    data['Email'],
                    data['Phone'],
                    data['name'],
                    data['photo'],
                    data['uid'],
                    data['Time'],


                  ));
                }



                return Column(
                  children: [
                    Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(' المنتجات الراجعه'),
                        Text('المنتجات المكتمله'),
                        Text('اسم المستخدم'),

                      ],),),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: userrepoets.length,

                      itemBuilder: (context, index) {
                        return   Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(userrepoets[index].CancelledOrders.toString()),
                            Text(userrepoets[index].CompletedOrders.toString()),
                            Text(userrepoets[index].name != null ?userrepoets[index].name : "non" ),

                          ],),);

                      },
                    ),







                  ],              );


              } else {
                return Center(child: Text('Loading ...'));

              }

            }),
      ),
    );


  }





  Widget loadsellersthisweek() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: store.loadsellersthisweek(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text("لا يوجد احد بعد"),
                  );
                }

                else
                  print('has');
                List<SellerReports> sellerreports = [];
                for (var doc in snapshot.data.docs) {
                  var data = doc.data();
                  sellerreports.add(SellerReports(
                    data['ProductsSold'],
                    data['TotalProducts'],
                    data['Seller E-mail'],
                    data['Phone'],
                    data['Seller Name'],
                    data['SellerID'],
                    data['DateTime'],


                  ));
                }



                return Column(
                  children: [
                    Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text('المنتجات المباعه'),
                        Text('عدد المنتجات'),
                        Text('اسم البائع'),

                      ],),),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: sellerreports.length,

                      itemBuilder: (context, index) {
                        return   Center(

                            child :   Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [


                                    Text(sellerreports[index].TotalProducts.toString()),
                                    Text(sellerreports[index].ProductsSold.toString()),
                                    GestureDetector(
                                        onTap: (){



                                        },
                                        child: Text(sellerreports[index].Seller_Name)),

                                  ],),
                                SizedBox(height: 10),

                              ],

                            ));

                      },
                    ),







                  ],              );


              } else {
                return Center(child:

                Text('Loading ...'));
              }
              ;
            }),
      ),
    );


  }



}

class CircleProgressBar extends StatefulWidget {
  final Color backgroundColor;
  final Color foreColor;
  final int duration;
  final double size;
  final bool textPercent;
  final double strokeWidth;
  final double startNumber;
  final double maxNumber;
  final TextStyle textStyle;

  final text;

  const CircleProgressBar(
      this.text,
      this.size, {
        this.backgroundColor = Colors.grey,
        this.foreColor = Colors.blueAccent,
        this.duration = 3000,
        this.strokeWidth = 10.0,
        this.textStyle,
        this.startNumber = 0.0,
        this.maxNumber = 360,
        this.textPercent = true,
      });

  @override
  State<StatefulWidget> createState() {
    return CircleProgressBarState();
  }
}

class CircleProgressBarState extends State<CircleProgressBar>
    with SingleTickerProviderStateMixin {
  Animation<double> _doubleAnimation;
  AnimationController _animationController;
  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));

    curve = new CurvedAnimation(
        parent: _animationController, curve: Curves.decelerate);
    _doubleAnimation =
        new Tween(begin: widget.startNumber, end: widget.maxNumber)
            .animate(curve);

    _animationController.addListener(() {
      setState(() {});
    });
    onAnimationStart();
  }

  @override
  void reassemble() {
    onAnimationStart();
  }

  onAnimationStart() {
    _animationController.forward(from: widget.startNumber);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var percent = (_doubleAnimation.value / widget.maxNumber * 100).round();
    return Container(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: CircleProgressBarPainter(

              widget.backgroundColor,
              widget.foreColor,
              widget.text,
              widget.startNumber / widget.maxNumber * 360,
              _doubleAnimation.value / widget.maxNumber * 360,
              widget.maxNumber / widget.maxNumber * 360,
              widget.strokeWidth),
          size: Size(widget.size, widget.size),
          child: Center(
            child: Text(
                //"${_doubleAnimation.value.round() == widget.maxNumber ? "000000" : "${widget.textPercent ? "$percent%" : "${_doubleAnimation.value.round()}/${widget.maxNumber.round()}"}"}",
                (widget.text),

                style: widget.textStyle == null
                    ? TextStyle(color: Colors.black, fontSize: 20)
                    : widget.textStyle),
          ),
        ));
  }
}

class CircleProgressBarPainter extends CustomPainter {
  var _paintBckGround;
  var _paintFore;

  final _strokeWidth;
  final _backgroundColor;
  final _foreColor;
  final _startAngle;
  final _sweepAngle;
  final _endAngle;

  var text;

  CircleProgressBarPainter(this._backgroundColor, this._foreColor,this.text,
      this._startAngle, this._sweepAngle, this._endAngle, this._strokeWidth) {
    _paintBckGround = new Paint()
      ..color = _backgroundColor
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    _paintFore = new Paint()
      ..color = _foreColor
      ..isAntiAlias = true
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var radius = size.width > size.height ? size.width / 2 : size.height / 2;
    Rect rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius);

    canvas.drawCircle(Offset(radius, radius), radius, _paintBckGround);
    canvas.drawArc(rect, _startAngle / 180 * 3.14, _sweepAngle / 180 * 3.14,
        false, _paintFore);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return _sweepAngle != _endAngle;
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_eapp/models/Categories.dart';
import 'package:flutter_eapp/models/Product.dart';
import 'package:flutter_eapp/models/Sellers.dart';
import 'package:flutter_eapp/models/SubCategories.dart';
import 'package:flutter_eapp/screens/User/CatandSubcat.dart';
import 'package:flutter_eapp/screens/User/FavouriteStores.dart';
import 'package:flutter_eapp/screens/User/Shops.dart';
import 'package:flutter_eapp/screens/User/UserProfile.dart';
import 'package:flutter_eapp/screens/User/favouriteItems.dart';
import 'package:flutter_eapp/screens/User/loginsccreen.dart';
import 'package:flutter_eapp/screens/User/points.dart';
import 'package:flutter_eapp/screens/User/product.dart';
import 'package:flutter_eapp/screens/User/search.dart';
import 'package:flutter_eapp/screens/User/shoppingcart.dart';
import 'package:flutter_eapp/screens/User/userOrders.dart';
import 'package:flutter_eapp/services/auth.dart';
import 'package:flutter_eapp/services/store.dart';
import 'package:flutter_eapp/widgets/clip_shadow_path.dart';
import 'package:flutter_eapp/widgets/main_image.dart';
import 'package:flutter_eapp/widgets/trending_item.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import 'SubCategoryPage.dart';


class Home extends StatefulWidget {
  static String id = "HomeScreen";
  final FirebaseMessaging  firebaseMessaging = FirebaseMessaging();

  String   uname ;

  String uphoto;

  @override
  _HomeState createState() => _HomeState();}
class _HomeState extends State<Home> {


  final auth = Auth();
  User loggeduser ;
  final store = Store();
  final store1 = Store();
  int currentIndex = 0;
  PageController pageController;
  final FirebaseAuth fireauth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging  firebaseMessaging = FirebaseMessaging();

  String username = 'User Name';


  String photo = "https://www.attendit.net/images/easyblog_shared/July_2018/7-4-18/b2ap3_large_totw_network_profile_400.jpg";

  var CouponComment;
  bool visable = false;

  String token;

  String UID;
  @override
  Widget build(BuildContext context) {
    var mywidth = MediaQuery.of(context).size.width;
    var myheight = MediaQuery.of(context).size.height;

   // getData();



    return  Scaffold(key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: UID != null? buildAppBar(context) : buildanybar(context) ,
        drawer: UID != null? Drawer(child: leftDrawerMenu()) : null,
        body: Test(myheight, mywidth));}

  @override
  void initState() {



    requestper();
    checkgeneralcoupon();
    getData();
super.initState();
    final fcm = FirebaseMessaging();
    fcm.requestNotificationPermissions();
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        showDialog(
          context: context,
          builder: (context) =>


              AlertDialog(
            content: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 3.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
              ),
              height: 120,
              child: Column(
                children: [
                  Icon(Icons.notification_important,size: 50, color: klight,),

                  Text(message['notification']['title']),

                  Text(message['notification']['body']),

                ],

              ),
            ),

          ),
        );








          },
      onLaunch: (Map<String, dynamic> message) async {
        AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 3.0
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //                 <--- border radius here
              ),
            ),
            height: 120,
            child: Column(
              children: [
                Icon(Icons.notification_important,size: 50, color: klight,),

                Text(message['notification']['title']),

                Text(message['notification']['body']),

              ],

            ),
          ),

        );
      },
      onResume: (Map<String, dynamic> message) async {
        AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 3.0
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //                 <--- border radius here
              ),
            ),
            height: 120,
            child: Column(
              children: [
                Icon(Icons.notification_important,size: 50, color: klight,),

                Text(message['notification']['title']),

                Text(message['notification']['body']),

              ],

            ),
          ),

        );
      },
    );



  }

  @override
  void dispose() {
  //  pageController.dispose();
    super.dispose();
  }

  Future<dynamic> getData() async {
    loggeduser = fireauth.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseMessaging  firebaseMessaging = FirebaseMessaging();


    firebaseMessaging.getToken().then((token1) {
      print(token1);
      token =  token1;

      // Print the Token in Console
    });





     UID = loggeduser.uid;
    await prefs.setString('UID', UID);

    final DocumentReference document = Firestore.instance.collection('Users')
        .doc(UID).collection('Userdata')
        .doc(UID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {

        widget.uname = snapshot.get('name').toString();

if (
snapshot.get('photo').toString() == null || snapshot.get('photo').toString()=="" ){  widget.uphoto = photo ;          }
    else    widget.uphoto = snapshot.get('photo').toString();
      });
    }). then((value) =>

    photo = widget.uphoto
    ).then((value) =>
    username = widget.uname


    ).then((value) =>

    document.update({
      'token' : token

    })

    );





  }



  AppBar buildAppBar(BuildContext context) {

    return AppBar(
      backgroundColor: kdark,
      title:RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Ca',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: 'ram',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              TextSpan(
                text: 'ella',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ]),
      ),
      leading: new IconButton(
          icon: new Icon(FlutterIcons.account_settings_mco,
              color: Colors.white),
          onPressed: () =>    _scaffoldKey.currentState.openDrawer()),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: Search(),
              ),
            );
          },
          child: Icon(
            MaterialCommunityIcons.magnify,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: Icon(
            MaterialCommunityIcons.cart_outline,
          ),
          color: Colors.white,
          onPressed: () {


            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: ShoppingCart(true),
              ),
            );



          },
        ),



      ],



    );
  }
  AppBar buildanybar(BuildContext context) {

    return AppBar(
      backgroundColor: kdark,
      title:RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Ca',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: 'ram',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              TextSpan(
                text: 'ella',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ]),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: LoginScreen(),
              ),
            );
          },
          child: Center(child: Text('تسجيل الدخول؟'))
        ),




      ],



    );
  }



  leftDrawerMenu() {

    Color blackColor = Colors.white.withOpacity(1.0);
    return Container(
      decoration:BoxDecoration(
        gradient: LinearGradient(
            colors: [kdark, kdark],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
        ),



      ),
      child: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 5),
          children: <Widget>[
            Center(
              child: Container(


                padding: EdgeInsets.symmetric(vertical: 16.0),
                height: 175,
                child: DrawerHeader(

                  child: ListTile(
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 30,
                    ),
                    subtitle: GestureDetector(

                      child: GestureDetector(
                        child: Text(
                          "الصفحه الشخصيه",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: blackColor),
                        )    ,

                        onTap: ()  {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: UserInfo1(),
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      username,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: blackColor),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: photo == 'Notset' || photo == null || photo.isEmpty ?


                      NetworkImage(
                          "https://miro.medium.com/fit/c/256/256/1*mZ3xXbns5BiBFxrdEwloKg.jpeg") : NetworkImage(photo),
                    ),
                  ),
                  decoration:BoxDecoration(
                    gradient: LinearGradient(
                        colors: [kdark, kdark],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.5, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp
                    ),



                  ),
                ),
              ),
            ),

            ListTile(
              leading: Icon(
                Feather.home,
                color: blackColor,
              ),
              title: GestureDetector(

                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: Home(),
                    ),
                  );
                },
                child: Text(
                  'الرئيسيه',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, color: blackColor),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: Home(),
                  ),
                );
              },
            ),

            ListTile(
              leading:
              Icon(Icons.favorite, color: blackColor),
              title: Text('المنتجات المفضله',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: blackColor)),
              onTap: () {

                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: FavouriteItems(),
                  ),
                );
              },
            ),

            ListTile(
              leading:
              Icon(Icons.store, color: blackColor),
              title: Text('المتاجر',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: blackColor)),
              onTap: () {

                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: FollowedStores(),
                  ),
                );
              },
            ),

            ListTile(
              leading:
              Icon(Feather.shopping_cart, color: blackColor),
              title: Text('سله التسوق',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: blackColor)),
              onTap: () {

                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: ShoppingCart(true),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(Feather.list, color: blackColor),
              title: Text('طلباتي',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: blackColor)),
              onTap: () {
Navigator.of(context).pushNamed(UserOrders.id);
              },
            ),

            ListTile(
              leading: Icon(Feather.settings, color: blackColor),
              title: Text('الاعدادات',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: blackColor)),
              onTap: () {
                Navigator.pushNamed(context, UserInfo1.id);
              },
            ),

            ListTile(
              leading: Icon(Feather.pocket, color: Colors.white),
              title: Text('نظام النقاط',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              onTap: () {

                {
                  Navigator.pushNamed(context, PointsPage.id);                }

              },
            ),

            ListTile(
              leading: Icon(Feather.x_circle, color: blackColor),
              title: Text('خروج',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: blackColor)),
              onTap: () {

           signout()   ;

              },
            ),
            SizedBox(height: 110,),
             Divider(thickness: 1,height: 1,),
             Padding(
               padding: const EdgeInsets.all(50.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [

                   GestureDetector(
                     onTap: (){
                       _launchURL("https://www.facebook.com/Caramella-كراميلا-102665568622964/");
                     }
                     ,child: Container(
                     height: 50, width: 40,
                     child: Image(image: AssetImage("assets/facebook.png"),)),
                   ),
                   GestureDetector(
                     onTap: (){
                       _launchURL("https://instagram.com/caramella_app?igshid=1pvdqwp67pssa");
                       
                     },
                     child: Container(
    height: 50, width: 40,
    child: Image(image: AssetImage("assets/instagram.png"),)),
                   ),

                   GestureDetector(
                     onTap: (){

                       _launchURL("https://www.snapchat.com/add/caramellaapp");

                     },
                     child: Container(
                       height: 50, width: 40,
                       child: Image(image: AssetImage("assets/snapchat.png"),)),
                   ),


                   GestureDetector(
                     onTap: (){

                   _launchURL("https://vm.tiktok.com/ZSJkQw6MA/");
                     },
                     child: Container(
                       height: 40, width: 30,
                       child: Image(image: AssetImage("assets/tiktok.png"),)),)


               ],),
             )

          ],
        ),
      ),
    );
  }

  Widget Test(myheight , mywidth) {
    final auth = Auth();
    User loggeduser ;
    double rectWidth = MediaQuery.of(context).size.width*0.250;
    double rectHeight = MediaQuery.of(context).size.width*.07;
    double trendCardWidth = MediaQuery.of(context).size.width*0.5;


    return Container(
        height: MediaQuery.of(context).size.height,
      child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
                expandedHeight: 500,
                flexibleSpace: FlexibleSpaceBar(
                  background: MainImage(),
                )),
            SliverList(
              delegate: SliverChildListDelegate([

                Visibility(
                  visible: visable
                  ,



                  child: Stack(
                    children: [

                      Container(
                        height: 110,

                        child: ClipPath(
                          clipper: DiagonalPathClipperOne(),
                          child: Container(
                            height: 100,
                            color: Colors.yellow,
                            child: Center(child:Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: [0.4, 0.5],
                                    colors: [
                                      Colors.yellow,
                                      Colors.yellowAccent,
                                    ],
                                  )),
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: visable
                                    ,child: Text(
                                    CouponComment.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      // fontFamily: 'Pacifico'
                                    ),
                                  ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                        ),
                      ),



                    ],
                  ),







                ),

                SizedBox(height: 20),




//stores

                Visibility(
                  visible :   UID != null ?  true : false,

                  child: GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: FollowedStores(),
                        ),
                      );
                    },
                    child: Row(

                      mainAxisAlignment:MainAxisAlignment.end ,
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text("المتاجر      ",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontFamily: 'Tajawal',

                                fontWeight: FontWeight.bold)),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  height: 100,
                  width: mywidth*1.0,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: store.loadallsellers(),
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Sellers> sellers = [];
                          for (var doc in snapshot.data.docs) {var data = doc.data(); sellers.add(Sellers(
                            // isnew: data['IsNew'],
                            sellername: data['Seller Name'],
                            //  seller_email: data['Email'],
                            verified: data['Verified'],
                            shopname:data['Store Name'],
                            //  starseller: data['StarSellers'],
                            storeproducts: data['Store Products'],
                            //  address:  data['Address'] ,
                            // phone:  data['Phone'],
                            //             photo: data['photo'],
                            uid: data['uid'],


                            // ignore: missing_return
                          ));}

                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context,int index){

                              return GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Shops(sellerShop :sellers[index].shopname, sellerID : sellers[index].uid),),);




                                },


                                child: new  Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                        ,
                                        child: Container(

                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(color: klight , width: 7),
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                            ,
                                            image: DecorationImage(

                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                "https://images.unsplash.com/photo-1415025148099-17fe74102b28?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=840&q=80"

                                                ,

                                              ),
                                            ),
                                          ),
                                          width: mywidth*0.3,

                                          height: 150.0,
                                        ),
                                      ),

                                      Container(

                                        width: mywidth*0.3,

                                        height: 150.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                            ,
                                            color: Colors.white,
                                            gradient: LinearGradient(
                                                begin: FractionalOffset.topCenter,
                                                end: FractionalOffset.bottomCenter,
                                                colors: [
                                                  Colors.black26,
                                                  Colors.black26,
                                                ],
                                                stops: [
                                                  0.0,
                                                  1.0
                                                ])),
                                      ),

                                      Center(

                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 18),
                                          child: Text(
                                            sellers[index].shopname,
                                            style: TextStyle(
                                                fontSize: 17,

                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),


                                    ]),
                              );

                            },
                            itemCount: sellers.length,

                          );
                        } else {
                          return Center(child: Text('يتم التحميل'));
                        }
                        ;
                      }),
                ),
                /////











//Main aksam
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 20,),
                      Text("  الاقسام الرئيسيه  ",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Tajawal',

                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                      Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width* 2.0,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: store.loadCategories(),
                            // ignore: missing_return
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<CateG> Categories = [];
                                for (var doc in snapshot.data.docs) {var data = doc.data(); Categories.add(CateG(
                                  doc.id,
                                  data[kCategoryName],
                                  data[kSubCatName],
                                  catImage: data['image'],

                                  // ignore: missing_return
                                ));}

                                return    GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 0.5,
                                      crossAxisSpacing: 5,
                                      childAspectRatio: 1.0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: Categories.length,

                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: (){



                                        Navigator.of(context).push(

                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CategoriesAndSubCategories(CategoryName :Categories[index].CategoryName)


                                            ,
                                          ),


                                        );









                                      },
                                      child: Card(
                                        elevation: 20,
                                        color: klight,
                                        child: Column(

                                          children: <Widget>[
                                            Expanded(
                                              child: Stack(children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        Categories[index].catImage
                                                        ,
                                                      ),
                                                    ),
                                                  ),
                                                  height: 90,
                                                  width: mywidth*1.8,
                                                ),
                                                Container(
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      gradient: LinearGradient(
                                                          begin: FractionalOffset.topCenter,
                                                          end: FractionalOffset.bottomCenter,
                                                          colors: [
                                                            Colors.black87,
                                                            Colors.black26,
                                                          ],
                                                          stops: [
                                                            0.0,
                                                            1.0
                                                          ])),
                                                ),

                                              ],),
                                            ),



                                            Container(
                                              height:30
                                              ,child: Card(

                                              color: kdark,
                                              child: Center(
                                                child: Text(
                                                  Categories[index].CategoryName,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            ),


                                          ],

                                        ),

                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(child: Text('يتم التحميل'));
                              }
                              ;
                            }),
                      ),
                      SizedBox(height: 20,),

                    ],
                  ),
                ),
//////



// aksam fr3ya
                SizedBox(height: 20),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 20,),
                      Text("   الاقسام الفرعيه  ",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Tajawal',

                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),

                      Container(
                        color:Colors.white,
                        height: MediaQuery.of(context).size.height*0.2,
                        width: MediaQuery.of(context).size.width* 1.1,
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


                                  itemBuilder: (BuildContext context,int index){
                                    return

                                      new Card(
                                          color: kdark,
                                          elevation: 10,

                                          child: Center(child:

                                          GestureDetector(
                                            onTap:(){


                                              Navigator.of(context).push(

                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubCategoryPage(SubCategory :subCategories[index].subCategoryName , Category : subCategories[index].categoryname )


                                                  ,
                                                ),
                                              );


                                            },
                                            child: Text(subCategories[index].subCategoryName,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontFamily: 'Tajawal',

                                                    fontWeight: FontWeight.bold)),
                                          ),
                                          ));


                                  },
                                  itemCount: subCategories.length,

                                );
                              } else {
                                return Center(child: Text('يتم التحميل'));
                              }
                              ;
                            }),
                      ),
                      SizedBox(height: 20,),

                    ],
                  ),
                ),
                //    Divider(thickness: 3,color: Colors.black87,),
//////




                Text("   العروض المميزه   ",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Tajawal',

                        fontWeight: FontWeight.bold)),
                SizedBox(height: 30),


                TrendingItem(),

                SizedBox(height: 20),

                SizedBox(height: 30),


//kol elmontgat elle lsa wasla

                SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("   وصل حديثاً  ",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Tajawal',

                                fontWeight: FontWeight.bold)),

                        Container(
                            height: MediaQuery.of(context).size.height*0.3,
                            width: MediaQuery.of(context).size.width,
                            child:SingleChildScrollView(
                              child: Container(
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: store.loadrecentproducts(),
                                      // ignore: missing_return
                                      builder: (context, snapshot) {

                                        if (snapshot.hasData)
                                        {
                                          List<Product> products = [];

                                          for (var doc in snapshot.data.docs) {
                                            var data = doc.data();
                                            products.add(Product(
                                                doc.id,
                                                data[kProductName],
                                                data[kProductPrice],
                                                data[kProductDescription],
                                                data[kProductCategory],
                                                data[kproductImage],
                                                data['Product SubCategory'],
                                                data ['product after discount'],

                                                data[kProductdiscount],null,data['instock'],
                                                sellername: data['Seller Name'],
                                                sellershop: data['Seller shop'],
                                                sellerID: data['sellerID'],
                                                sellerToken: data['sellertoken'],
                                                colors: List.from(data['Colors'])
                                              //colors: json.decode(data['colors'])
                                            ));


                                          }



                                          return ListView.builder(

                                            scrollDirection: Axis.horizontal,
                                            itemCount: products.length,
                                            itemBuilder: (context, index) {


                                              return GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) => ProductPage(
                                                          product: products[index],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: GestureDetector(
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            width: trendCardWidth,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 1.0),
                                                              child: ClipShadowPath(
                                                                shadow: Shadow(blurRadius: 1, color: klight),
                                                                clipper: TrendingItemsClipper(rectWidth, rectHeight),
                                                                child: Card(
                                                                  elevation: 0,
                                                                  color: Colors.white,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(4.0),
                                                                    child: SingleChildScrollView(
                                                                      child: Column(
                                                                        children: <Widget>[
                                                                          Row(
                                                                            children: <Widget>[
                                                                              Card(
                                                                                color: Colors.black,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(1.0),

                                                                                ),
                                                                              ),
                                                                              Spacer(),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(bottom: 5),
                                                                                child: Container(
                                                                                  width: 50,
                                                                                  height: 30,
                                                                                  child: Card(
                                                                                    elevation: 6,
                                                                                    color: klight,
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        "وصل حديثا" ,
                                                                                        style: TextStyle(
                                                                                            fontSize: 10,
                                                                                            color: Colors.black,
                                                                                            fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          _productImage(products[index].Productimage),
                                                                          _productDetails(products[index].Productname,products[index].Productprice , products[index].productDiscount),

                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                              bottom: 0,
                                                              left: trendCardWidth / 2 - rectWidth / 2,
                                                              child: ClipShadowPath(
                                                                shadow: Shadow(color: klight, blurRadius: 1),
                                                                clipper: CartIconClipper(rectWidth, rectHeight),
                                                                child: GestureDetector(
                                                                  onTap: (){
                          UID != null?
                                                                    store.additemtocart(products[index] , context, products[index].pID):
                          stopcart(context, "","من فضلك قم بتسجيل الدخول أولاً");


                                                                  },
                                                                  child: Container(

                                                                    width: rectWidth,
                                                                    height: rectHeight,
                                                                    color: kdark,
                                                                    child: Center(
                                                                      child: Icon(
                                                                        Icons.shopping_cart,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ))
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductPage(
                                                                  product: products[index],
                                                                ),
                                                          ),
                                                        );
                                                      }         ));
                                            },
                                          );





                                        }



                                        return Container(child: Text('Nothing yet'),);



                                      }
                                  ),
                                ),
                              ),
                            )

                        ),

                      ],)
                ),
                SizedBox(height : 5),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("       خصومات     ",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Tajawal',

                            fontWeight: FontWeight.bold)),

                    Container(
                      color: Colors.white12,
                      height: myheight,

                      child: StreamBuilder<QuerySnapshot>(
                          stream:
                          store.LoadSaledproducts(),


                          // ignore: missing_return
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.size != 0) {
                                List<Product> products = [];

                                for (var doc in snapshot.data.docs) {
                                  var data = doc.data();
                                  products.add(Product(
                                      doc.id,
                                      data[kProductName],
                                      data[kProductPrice],
                                      data[kProductDescription],
                                      data[kProductCategory],
                                      data[kproductImage],
                                      data['Product SubCategory'],
                                      data ['product after discount'],

                                      data[kProductdiscount],null,data['instock'],
                                      sellername: data['Seller Name'],
                                      sellershop: data['Seller shop'],
                                      sellerID: data['sellerID'],
                                      sellerToken: data['sellertoken']
                                      ,colors: List.from(data['Colors'])

                                    // ignore: missing_return

                                  ));


                                }



                                return GridView.builder(
                                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 1,
                                    crossAxisSpacing:1,
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: products.length,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) =>
                                  GestureDetector(
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 5.0),
                                            child: ClipShadowPath(
                                              shadow: Shadow(blurRadius: 1, color: klight),
                                              clipper: TrendingItemsClipper(rectWidth, rectHeight),
                                              child: Container(
                                                color: Colors.white,
                                                height: 700,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom:12.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Row(
                                                          children: <Widget>[

                                                            Padding(
                                                              padding: const EdgeInsets.only(bottom: 0.0),
                                                              child: Container(
                                                                width: 75,
                                                                height: 20,
                                                                child: Card(
                                                                  elevation: 6,
                                                                  color: klight,
                                                                  child: Center(
                                                                    child: Text(
                                                                      products[index].productDiscount!= "" ? "- ${products[index].productDiscount} %"
                                                                          : "Onsale",
                                                                      style: TextStyle(
                                                                          fontSize: 10,
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      _productImage(products[index].Productimage),
                                                      _productDetails(products[index].Productname,products[index].Productprice , products[index].productDiscount),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 2,
                                              left: trendCardWidth / 2 - rectWidth / 2,
                                              child: ClipShadowPath(
                                                shadow: Shadow(color: klight, blurRadius: 1),
                                                clipper: CartIconClipper(rectWidth, rectHeight),
                                                child: GestureDetector(
                                                  onTap: (){
UID != null?
                                                    store.additemtocart(products[index] , context, products[index].pID)
:                          stopcart(context, "","من فضلك قم بتسجيل الدخول أولاً");

                                                  },
                                                  child: Container(

                                                    width: rectWidth,
                                                    height: rectHeight,
                                                    color: kdark,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.shopping_cart,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductPage(
                                                  product: products[index],
                                                ),
                                          ),
                                        );
                                      }         ),






                                );


                              }
                              if (snapshot.data.size == 0) {
                                return Container(
                                  child: Center(child: Text('لا يوجد منتجات بعد ')),
                                );
                              }
                            } else if (!snapshot.hasData) {
                              return Container(
                                child: Center(child: Text('لا يوجد منتجات بعد ')),
                              );
                            }
                          }),

                    ),

                  ],)





              ]),



            )]),
    );





//       Container(
//       child: CustomScrollView(
//           physics: ScrollPhysics(),
//           slivers: <Widget>[
//             SliverAppBar(
//                 backgroundColor: Colors.transparent,
//                 iconTheme: IconThemeData(color: Colors.white),
//                 expandedHeight: 500,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: MainImage(),
//                 )),
//             SliverList(
//               delegate: SliverChildListDelegate([
//
//                 Visibility(
//                   visible: visable
//                   ,
//
//
//
//                   child: Stack(
//                     children: [
//
//                       Container(
//                         height: 110,
//
//                         child: ClipPath(
//                           clipper: DiagonalPathClipperOne(),
//                           child: Container(
//                             height: 100,
//                             color: Colors.yellow,
//                             child: Center(child:Container(
//                               decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topRight,
//                                     end: Alignment.bottomLeft,
//                                     stops: [0.4, 0.5],
//                                     colors: [
//                                       Colors.yellow,
//                                       Colors.yellowAccent,
//                                     ],
//                                   )),
//                               height: 60,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Visibility(
//                                     visible: visable
//                                     ,child: Text(
//                                     CouponComment.toString(),
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold
//                                       // fontFamily: 'Pacifico'
//                                     ),
//                                   ),
//                                   ),
//                                 ],
//                               ),
//                             )),
//                           ),
//                         ),
//                       ),
//
//
//
//                     ],
//                   ),
//
//
//
//
//
//
//
//                 ),
//
//                 SizedBox(height: 20),
//
//
//
//
// //stores
//
//                 GestureDetector(
//                   onTap: () {
//
//                     Navigator.push(
//                       context,
//                       PageTransition(
//                         type: PageTransitionType.fade,
//                         child: FollowedStores(),
//                       ),
//                     );
//                   },
//                   child: Row(
//
//          mainAxisAlignment:MainAxisAlignment.end ,
//                     children: [
//                       Icon(Icons.arrow_back_ios),
//                       Text("المتاجر -     ",
//                           textAlign: TextAlign.right,
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 25,
//                               fontFamily: 'Tajawal',
//
//                               fontWeight: FontWeight.bold)),
//
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//
//                 Container(
//                   height: 100,
//                   width: mywidth*1.0,
//                   child: StreamBuilder<QuerySnapshot>(
//                       stream: store.loadallsellers(),
//                       // ignore: missing_return
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           List<Sellers> sellers = [];
//                           for (var doc in snapshot.data.docs) {var data = doc.data(); sellers.add(Sellers(
//                             // isnew: data['IsNew'],
//                             sellername: data['Seller Name'],
//                             //  seller_email: data['Email'],
//                             verified: data['Verified'],
//                             shopname:data['Store Name'],
//                             //  starseller: data['StarSellers'],
//                             storeproducts: data['Store Products'],
//                             //  address:  data['Address'] ,
//                             // phone:  data['Phone'],
//                             //             photo: data['photo'],
//                             uid: data['uid'],
//
//
//                             // ignore: missing_return
//                           ));}
//
//                           return ListView.builder(
//                             shrinkWrap: true,
//                             scrollDirection: Axis.horizontal,
//                             itemBuilder: (BuildContext context,int index){
//
//                               return GestureDetector(
//                                 onTap: (){
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           Shops(sellerShop :sellers[index].shopname, sellerID : sellers[index].uid),),);
//
//
//
//
//                                 },
//
//
//                                 child: new  Stack(
//                                     children: <Widget>[
//                                       ClipRRect(
//                                 borderRadius: BorderRadius.all(Radius.circular(20))
// ,
//                               child: Container(
//
//                                           decoration: BoxDecoration(
//                                             color: Colors.transparent,
//                                   border: Border.all(color: klight , width: 7),
//                                   borderRadius: BorderRadius.all(Radius.circular(20))
// ,
//                                   image: DecorationImage(
//
//                                               fit: BoxFit.cover,
//                                               image: NetworkImage(
//                                                 "https://images.unsplash.com/photo-1415025148099-17fe74102b28?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=840&q=80"
//
//                                                 ,
//
//                                               ),
//                                             ),
//                                           ),
//                                           width: mywidth*0.3,
//
//                                           height: 150.0,
//                                         ),
//                                       ),
//
//                                       Container(
//
//                                         width: mywidth*0.3,
//
//                                         height: 150.0,
//                                         decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.all(Radius.circular(20))
// ,
//                                             color: Colors.white,
//                                             gradient: LinearGradient(
//                                                 begin: FractionalOffset.topCenter,
//                                                 end: FractionalOffset.bottomCenter,
//                                                 colors: [
//                                                   Colors.black26,
//                                                   Colors.black26,
//                                                 ],
//                                                 stops: [
//                                                   0.0,
//                                                   1.0
//                                                 ])),
//                                       ),
//
//                                       Center(
//
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(left: 18),
//                                           child: Text(
//                                             sellers[index].shopname,
//                                             style: TextStyle(
//                                                 fontSize: 17,
//
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//
//
//                                     ]),
//                               );
//
//                             },
//                             itemCount: sellers.length,
//
//                           );
//                         } else {
//                           return Center(child: Text('يتم التحميل'));
//                         }
//                         ;
//                       }),
//                 ),
//                 /////
//
//
//
//
//
//
//
//
//
//
//
// //Main aksam
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 color: Colors.white,
//                 elevation: 30,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     SizedBox(height: 20,),
//                     Text("  الاقسام الرئيسيه  ",
//                         textAlign: TextAlign.right,
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 20,
//                             fontFamily: 'Tajawal',
//
//                             fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10,),
//                     Container(
//                       height: MediaQuery.of(context).size.height*0.3,
//                       width: MediaQuery.of(context).size.width* 2.0,
//                         child: StreamBuilder<QuerySnapshot>(
//                           stream: store.loadCategories(),
//                           // ignore: missing_return
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               List<CateG> Categories = [];
//                               for (var doc in snapshot.data.docs) {var data = doc.data(); Categories.add(CateG(
//                                 doc.id,
//                                 data[kCategoryName],
//                                 data[kSubCatName],
//                                 catImage: data['image'],
//
//                                 // ignore: missing_return
//                               ));}
//
//                               return    GridView.builder(
//                                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 2,
//                                   mainAxisSpacing: 0.5,
//                                   crossAxisSpacing: 5,
//                                   childAspectRatio: 1.0),
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: Categories.length,
//
//                                 itemBuilder: (context, index) {
//                                   return GestureDetector(
//                                     onTap: (){
//
//
//
//                                       Navigator.of(context).push(
//
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               CategoriesAndSubCategories(CategoryName :Categories[index].CategoryName)
//
//
//                                           ,
//                                         ),
//
//
//                            );
//
//
//
//
//
//
//
//
//
//                                     },
//                                     child: Card(
//                                         elevation: 20,
//                                         color: klight,
//                                         child: Column(
//
//                                           children: <Widget>[
//                                            Expanded(
//                                              child: Stack(children: [
//                                                Container(
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.transparent,
//                                                    image: DecorationImage(
//                                                      fit: BoxFit.cover,
//                                                      image: NetworkImage(
//                                                        Categories[index].catImage
//                                                        ,
//                                                      ),
//                                                    ),
//                                                  ),
//                                                  height: 90,
//                                                  width: mywidth*1.8,
//                                                ),
//                                                Container(
//                                                  height: 90,
//                                                  decoration: BoxDecoration(
//                                                      color: Colors.white,
//                                                      gradient: LinearGradient(
//                                                          begin: FractionalOffset.topCenter,
//                                                          end: FractionalOffset.bottomCenter,
//                                                          colors: [
//                                                            Colors.black87,
//                                                            Colors.black26,
//                                                          ],
//                                                          stops: [
//                                                            0.0,
//                                                            1.0
//                                                          ])),
//                                                ),
//
//                                              ],),
//                                            ),
//
//
//
//                                              Container(
//                                                height:30
//                                                ,child: Card(
//
//                                                   color: kdark,
//                                                   child: Center(
//                                                     child: Text(
//                                                       Categories[index].CategoryName,
//                                                       style: TextStyle(
//                                                           fontSize: 10,
//                                                           color: Colors.white,
//                                                           fontWeight: FontWeight.bold),
//                                                     ),
//                                                   ),
//                                                 ),
//                                              ),
//
//
//                                           ],
//
//                                         ),
//
//                                     ),
//                                   );
//                                 },
//                               );
//                             } else {
//                               return Center(child: Text('يتم التحميل'));
//                             }
//                             ;
//                           }),
//                     ),
//                     SizedBox(height: 20,),
//
//                   ],
//                 ),
//               ),
// //////
//
//
//
// // aksam fr3ya
//                 SizedBox(height: 20),
//
//                 Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   color: Colors.white,
//                   elevation: 30,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       SizedBox(height: 20,),
//                       Text("   الاقسام الفرعيه  ",
//                           textAlign: TextAlign.right,
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 20,
//                               fontFamily: 'Tajawal',
//
//                               fontWeight: FontWeight.bold)),
//                       SizedBox(height: 10,),
//
//                       Container(
//                         color:Colors.white,
//                         height: MediaQuery.of(context).size.height*0.2,
//                         width: MediaQuery.of(context).size.width* 1.1,
//                         child: StreamBuilder<QuerySnapshot>(
//                             stream: store.loadSubCat(),
//                             // ignore: missing_return
//                             builder: (context, snapshot) {
//                               if (snapshot.hasData) {
//                                 List<SubCateG> subCategories = [];
//
//                                 for (var doc in snapshot.data.docs) {
//                                   var data = doc.data();
//                                   subCategories.add(SubCateG(
//                                       doc.id,
//                                       data[kSubCatName],
//                                       data[ksubcategory_OriginalCategoryID],
//                                       data [ksubcategoryCatgoryName]
//                                     // ignore: missing_return
//                                   ));
//                                 }
//
//                                 return ListView.builder(
//
//
//                                   itemBuilder: (BuildContext context,int index){
//                                     return
//
//                                       new Card(
//                                           color: kdark,
//                                           elevation: 10,
//
//                                           child: Center(child:
//
//                                           GestureDetector(
//                                             onTap:(){
//
//
//                                               Navigator.of(context).push(
//
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       SubCategoryPage(SubCategory :subCategories[index].subCategoryName , Category : subCategories[index].categoryname )
//
//
//                                                   ,
//                                                 ),
//                                               );
//
//
//                                             },
//                                             child: Text(subCategories[index].subCategoryName,
//                                                 textAlign: TextAlign.right,
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 20,
//                                                     fontFamily: 'Tajawal',
//
//                                                     fontWeight: FontWeight.bold)),
//                                           ),
//                                           ));
//
//
//                                   },
//                                   itemCount: subCategories.length,
//
//                                 );
//                               } else {
//                                 return Center(child: Text('يتم التحميل'));
//                               }
//                               ;
//                             }),
//                       ),
//                       SizedBox(height: 20,),
//
//                     ],
//                   ),
//                 ),
//             //    Divider(thickness: 3,color: Colors.black87,),
// //////
//
//
//
//                 SizedBox(height: 30),
//
//
//
//
//
//
//
//                 SizedBox(height: 30),
//                 Text("   العروض المميزه   ",
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 25,
//                         fontFamily: 'Tajawal',
//
//                         fontWeight: FontWeight.bold)),
//                 SizedBox(height: 30),
//
//
//                 TrendingItem( ),
//
//                 SizedBox(height: 20),
//
//                 SizedBox(height: 30),
//
//
// //kol elmontgat elle lsa wasla
//
//                SingleChildScrollView(
//  child: Column(
//    mainAxisAlignment: MainAxisAlignment.end,
//    crossAxisAlignment: CrossAxisAlignment.end,
//      children: [
//      Text("   وصل حديثاً  ",
//      textAlign: TextAlign.right,
//      style: TextStyle(
//          color: Colors.black,
//          fontSize: 20,
//          fontFamily: 'Tajawal',
//
//          fontWeight: FontWeight.bold)),
//
//     Container(
//       height: MediaQuery.of(context).size.height*0.3,
//       width: MediaQuery.of(context).size.width,
//       child:SingleChildScrollView(
//         child: Container(
//           child: SizedBox(
//             width: 200,
//             height: 200,
//             child: StreamBuilder<QuerySnapshot>(
//                 stream: store.loadrecentproducts(),
//                 // ignore: missing_return
//                 builder: (context, snapshot) {
//
//                   if (snapshot.hasData)
//                   {
//                     List<Product> products = [];
//
//                     for (var doc in snapshot.data.docs) {
//                       var data = doc.data();
//                       products.add(Product(
//                         doc.id,
//                         data[kProductName],
//                         data[kProductPrice],
//                         data[kProductDescription],
//                         data[kProductCategory],
//                         data[kproductImage],
//                         data['Product SubCategory'],
//                         data ['product after discount'],
//
//                         data[kProductdiscount],null,data['instock'],
//                         sellername: data['Seller Name'],
//                         sellershop: data['Seller shop'],
//                         sellerID: data['sellerID'],
//                        sellerToken: data['sellertoken'],
//                        colors: List.from(data['Colors'])
//                        //colors: json.decode(data['colors'])
//                       ));
//
//
//                     }
//
//
//
//                     return ListView.builder(
//
//                       scrollDirection: Axis.horizontal,
//                       itemCount: products.length,
//                       itemBuilder: (context, index) {
//
//
//                         return GestureDetector(
//                             onTap: (){
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => ProductPage(
//                                     product: products[index],
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: GestureDetector(
//                                 child: Stack(
//                                   children: <Widget>[
//                                     Container(
//                                       width: trendCardWidth,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(bottom: 4.0),
//                                         child: ClipShadowPath(
//                                           shadow: Shadow(blurRadius: 1, color: klight),
//                                           clipper: TrendingItemsClipper(rectWidth, rectHeight),
//                                           child: Card(
//                                             elevation: 0,
//                                             color: Colors.white,
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(5.0),
//                                               child: Column(
//                                                 children: <Widget>[
//                                                   Row(
//                                                     children: <Widget>[
//                                                       Card(
//                                                         color: Colors.black,
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.all(2.0),
//                                                           /*
//                                                         child: Text(
//                                                           '${product.remainingQuantity} left',
//                                                           style: TextStyle(
//                                                               color: Colors.white, fontSize: 12.0),
//                                                         ),
//                                                       */
//
//                                                         ),
//                                                       ),
//                                                       Spacer(),
//                                                       Padding(
//                                                         padding: const EdgeInsets.only(bottom: 5),
//                                                         child: Container(
//                                                           width: 50,
//                                                           height: 30,
//                                                           child: Card(
//                                                             elevation: 6,
//                                                             color: klight,
//                                                             child: Center(
//                                                               child: Text(
//                                                                 "وصل حديثا" ,
//                                                                 style: TextStyle(
//                                                                     fontSize: 10,
//                                                                     color: Colors.black,
//                                                                     fontWeight: FontWeight.bold),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   _productImage(products[index].Productimage),
//                                                   _productDetails(products[index].Productname,products[index].Productprice , products[index].productDiscount),
//
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                         bottom: 0,
//                                         left: trendCardWidth / 2 - rectWidth / 2,
//                                         child: ClipShadowPath(
//                                           shadow: Shadow(color: klight, blurRadius: 1),
//                                           clipper: CartIconClipper(rectWidth, rectHeight),
//                                           child: GestureDetector(
//                                             onTap: (){
//
//                                               store.additemtocart(products[index] , context, products[index].pID);
//
//                                             },
//                                             child: Container(
//
//                                               width: rectWidth,
//                                               height: rectHeight,
//                                               color: kdark,
//                                               child: Center(
//                                                 child: Icon(
//                                                   Icons.shopping_cart,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ))
//                                   ],
//                                 ),
//                                 onTap: () {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           ProductPage(
//                                             product: products[index],
//                                           ),
//                                     ),
//                                   );
//                                 }         ));
//                       },
//                     );
//
//
//
//
//
//                   }
//
//
//
//                   return Container(child: Text('Nothing yet'),);
//
//
//
//                 }
//             ),
//           ),
//         ),
//       )
//
//     ),
//
//   ],)
// ),
//                 SizedBox(height : 5),
//
//                 SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text("       خصومات     ",
//                             textAlign: TextAlign.right,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                                 fontFamily: 'Tajawal',
//
//                                 fontWeight: FontWeight.bold)),
//
//                         Card(
//                           elevation: 400,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(50.0),
//                 ),
//
//                           child: Container(
//                             color: Colors.white12,
//                             height: myheight,
//
//                             child: StreamBuilder<QuerySnapshot>(
//                                 stream:
//                                 store.LoadSaledproducts(),
//
//
//                                 // ignore: missing_return
//                                 builder: (context, snapshot) {
//                                   if (snapshot.hasData) {
//                                     if (snapshot.data.size != 0) {
//                                       List<Product> products = [];
//
//                                       for (var doc in snapshot.data.docs) {
//                                         var data = doc.data();
//                                         products.add(Product(
//                                           doc.id,
//                                           data[kProductName],
//                                           data[kProductPrice],
//                                           data[kProductDescription],
//                                           data[kProductCategory],
//                                           data[kproductImage],
//                                           data['Product SubCategory'],
//                                           data ['product after discount'],
//
//                                           data[kProductdiscount],null,data['instock'],
//                                           sellername: data['Seller Name'],
//                                           sellershop: data['Seller shop'],
//                                           sellerID: data['sellerID'],
//                                             sellerToken: data['sellertoken']
//                                             ,colors: List.from(data['Colors'])
//
//                                           // ignore: missing_return
//
//                                         ));
//
//
//                                       }
//
//
//
//                                       return GridView.builder(
//                                         gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                                           mainAxisSpacing: 1,
//                                           crossAxisSpacing:1,
//                                           crossAxisCount: 2,
//                                           childAspectRatio: 1,
//                                         ),
//                                         itemCount: products.length,
//                                         physics: ScrollPhysics(),
//                                         shrinkWrap: true,
//                                         itemBuilder: (BuildContext context, int index) => new Container(
//
//
//                                             child: GestureDetector(
//                                                 child: Stack(
//                                                   children: <Widget>[
//                                                     Container(
//                                                       width: trendCardWidth,
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(bottom: 2.0),
//                                                         child: ClipShadowPath(
//                                                           shadow: Shadow(blurRadius: 1, color: klight),
//                                                           clipper: TrendingItemsClipper(rectWidth, rectHeight),
//                                                           child: Container(
//                                                             color: Colors.white,
//                                                             height: 700,
//                                                             child: Padding(
//                                                               padding: const EdgeInsets.all(2.0),
//                                                               child: Column(
//                                                                 children: <Widget>[
//                                                                   Row(
//                                                                     children: <Widget>[
//                                                                       Card(
//                                                                         color: Colors.black,
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.all(2.0),
//
//
//                                                                         ),
//                                                                       ),
//                                                                       Padding(
//                                                                         padding: const EdgeInsets.only(bottom: 5),
//                                                                         child: Container(
//                                                                           width: 75,
//                                                                           height: 30,
//                                                                           child: Card(
//                                                                             elevation: 6,
//                                                                             color: klight,
//                                                                             child: Center(
//                                                                               child: Text(
//                                                                                 products[index].productDiscount!= "" ? "- ${products[index].productDiscount} %"
//                                                                                     : "Onsale",
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 10,
//                                                                                     color: Colors.black,
//                                                                                     fontWeight: FontWeight.bold),
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   _productImage(products[index].Productimage),
//                                                                   _productDetails(products[index].Productname,products[index].Productprice , products[index].productDiscount),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Positioned(
//                                                         bottom: 0,
//                                                         left: trendCardWidth / 2 - rectWidth / 2,
//                                                         child: ClipShadowPath(
//                                                           shadow: Shadow(color: klight, blurRadius: 1),
//                                                           clipper: CartIconClipper(rectWidth, rectHeight),
//                                                           child: GestureDetector(
//                                                             onTap: (){
//
//                                                               store.additemtocart(products[index] , context, products[index].pID);
//
//                                                             },
//                                                             child: Container(
//
//                                                               width: rectWidth,
//                                                               height: rectHeight,
//                                                               color: kdark,
//                                                               child: Center(
//                                                                 child: Icon(
//                                                                   Icons.shopping_cart,
//                                                                   color: Colors.white,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ))
//                                                   ],
//                                                 ),
//                                                 onTap: () {
//                                                   Navigator.of(context).push(
//                                                     MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           ProductPage(
//                                                             product: products[index],
//                                                           ),
//                                                     ),
//                                                   );
//                                                 }         )
//                                         ),
//
//
//
//
//
//
//                                       );
//
//
//                                     }
//                                     if (snapshot.data.size == 0) {
//                                       return Container(
//                                         child: Center(child: Text('لا يوجد منتجات بعد ')),
//                                       );
//                                     }
//                                   } else if (!snapshot.hasData) {
//                                     return Container(
//                                       child: Center(child: Text('لا يوجد منتجات بعد ')),
//                                     );
//                                   }
//                                 }),
//
//                           ),
//                         ),
//
//                       ],)
//                 )
//
//
//
//
//
//               ]),
//
//
//
//             )]),
//     );









  }

  showcategories() {
    return  Container(
      height: 100,
      width : 50,

      child: StreamBuilder<QuerySnapshot>(


          stream: store.loadCategories(),

          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CateG> Categories = [];
              for (var doc in snapshot.data.docs) {var data = doc.data(); Categories.add(CateG(
                doc.id,
                data[kCategoryName],
                data[kSubCatName],

                // ignore: missing_return
              ));}
              return ListView.builder(
                  itemCount: Categories.length  ,

                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index ) {
                    return Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[ GestureDetector(
                            child: Row(

                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: (

                                        FilterChip(
                                          padding: EdgeInsets.all(20.0),
                                          label: Text(
                                            Categories[index].CategoryName,
                                            style: TextStyle(color: kdark),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          shape: StadiumBorder(

                                            side: BorderSide(color: Colors.grey.shade600) ,
                                          ),
                                          onSelected: (bool value) {

                                            Navigator.of(context).pushReplacement(

                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoriesAndSubCategories(CategoryName :Categories[index].CategoryName)


                                                ,
                                              ),


                                            );                                              },
                                        )),
                                  )










                                ]
                            )

                        ),









                        ] ) ;


                  }





              );


            }
            return Center(child: Text('Loading ...'));
          }

      ),



    );




  }

  void signout() async {

    FirebaseAuth.instance.signOut();
    User user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('passord');
Navigator.of(context).pushReplacementNamed(LoginScreen.id);

    //print('$user');


  }

  void checkgeneralcoupon() async{
    CouponComment= await store.checkgeneralcoupon();
    if (CouponComment != ""){


      setState(() {

        visable = true;

      });}
    else {setState(() {
      visable = false;
    });}









  }




  _launchURL(urlpage) async {
     var  url = urlpage;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> requestper() async {
    var status = await Permission.notification.status;


// You can can also directly ask the permission about its status.
    if (status.isGranted) {


      final fcm = FirebaseMessaging();
      fcm.requestNotificationPermissions();
      fcm.configure(
        onMessage: (Map<String, dynamic> message) async {








        },
        onLaunch: (Map<String, dynamic> message) async {
          AlertDialog(
            content: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 3.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
              ),
              height: 120,
              child: Column(
                children: [
                  Icon(Icons.notification_important,size: 50, color: klight,),

                  Text(message['notification']['title']),

                  Text(message['notification']['body']),

                ],

              ),
            ),

          );
        },
        onResume: (Map<String, dynamic> message) async {
          AlertDialog(
            content: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 3.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
              ),
              height: 120,
              child: Column(
                children: [
                  Icon(Icons.notification_important,size: 50, color: klight,),

                  Text(message['notification']['title']),

                  Text(message['notification']['body']),

                ],

              ),
            ),

          );
        },
      );











    }
    if (status.isDenied){
      Permission.notification.request();

    }



  }

  stopcart(BuildContext context , title, desc) {
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













}









_productImage(String productimage) {
  return Padding(
    padding: const EdgeInsets.only(bottom : 10.0),
    child: Stack(
      children: <Widget>[
        ClipPath(
          clipper: ProductImageContainerClipper(),
          child: Container(
            width: 100,
            height: 60,

          ),
        ),
        Center(
          child: Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(productimage), fit: BoxFit.contain)),
          ),
        )
      ],
    ),
  );
}

_productDetails(String productname, String productprice , String productdiscount) {
  if (productdiscount == '' ){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          productname,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),

        SizedBox(height:5),
        //StarRating(rating: product.rating, size: 10),
        Row(
          children: <Widget>[
            Text(productprice,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF85c2ff))),

          ],
        )
      ],
  ),
    );}
  else  if(productdiscount != ''){

    double price = double.parse(productprice);
    double discount = double.parse(productdiscount);


    var PricceAfterDiscount =price- ((price*discount)/100);
    var productbefordiscount =  price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Text(
          productname,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
        //StarRating(rating: product.rating, size: 10),





        Row(
          children: <Widget>[
            Text(PricceAfterDiscount.toString(),
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF85c2ff))),

            Text(
              productbefordiscount.toString(),
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  decoration: TextDecoration.lineThrough),
            )
            ,

          ],
        )
        ,
        Text(
          'Discount '+  productdiscount + '%',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.red),
        ),
        SizedBox(height: 10,)

      ],
    );}
  else {return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[

      Text(
        productname,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      ),
      //StarRating(rating: product.rating, size: 10),
      Row(
        children: <Widget>[
          Text(productprice,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF85c2ff))),

        ],
      )
    ],
  );}





}

cartIcon(double rectWidth, double rectHeight, BuildContext context, Product product) {
  return ClipShadowPath(
    shadow: Shadow(color: klight, blurRadius: 1),
    clipper: CartIconClipper(rectWidth, rectHeight),
    child: GestureDetector(
      onTap: (){





        print ('pressed');









      },
      child: Container(
        width: rectWidth,
        height: rectHeight,
        color: Color(0XFF3399ff),
        child: Center(
          child: Icon    (
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
class TrendingItemsClipper extends CustomClipper<Path> {
  double rectWidth;
  double rectHeight;
  TrendingItemsClipper(this.rectWidth, this.rectHeight);

  double radius = 35;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(radius, 0);
    path.quadraticBezierTo(0, 0, 0, radius);
    path.lineTo(0, size.height - radius);
    path.quadraticBezierTo(0, size.height, radius, size.height);
    path.lineTo(size.width / 2 - rectWidth / 2 - 4, size.height);
    path.lineTo(
        (size.width / 2 - rectWidth / 2) + 14 - 4, size.height - rectHeight);
    path.lineTo(
        (size.width / 2 + rectWidth / 2) - 14 + 4, size.height - rectHeight);
    path.lineTo(size.width / 2 + rectWidth / 2 + 4, size.height);
    path.lineTo(size.width - radius, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - radius);
    path.lineTo(size.width, radius);
    path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
    path.close();

    return path;
    // Path path = Path();
    // path.lineTo(0, 0);
    // path.lineTo(0, size.height);
    // path.lineTo(size.width/2 - rectWidth/2 - 4, size.height);
    // path.lineTo((size.width/2 - rectWidth/2) + 14 -4, size.height - rectHeight);
    // path.lineTo((size.width/2 + rectWidth/2) - 14 + 4, size.height - rectHeight);
    // path.lineTo(size.width/2 + rectWidth/2 + 4 , size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width, 0);
    // path.close();
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CartIconClipper extends CustomClipper<Path> {
  double rectWidth;
  double rectHeight;

  CartIconClipper(this.rectWidth, this.rectHeight);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(14, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 14, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ProductImageContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.cubicTo(
        0, size.height - 20, 0, size.height, size.width - 20, size.height - 6);
    //path.cubicTo(size.width, size.height, size.width, size.width - 10, size.width, 10);
    // path.lineTo(size.width/2, 0);
    path.quadraticBezierTo(size.width, size.height, size.width - 4, 15);
    // path.quadraticBezierTo(0, 60, 40, size.height);
    // path.quadraticBezierTo(0, 60, 40, size.height);
    //path.lineTo(0, size.height);
    //path.lineTo(size.width, size.height);
    path.lineTo(size.width - 10, 10);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }









  }
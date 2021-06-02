
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_eapp/Provider/Adminmode.dart';
import 'package:flutter_eapp/Provider/modelhut.dart';
import 'package:flutter_eapp/screens/Admin/Adminmain.dart';
import 'package:flutter_eapp/screens/Admin/CashedReports.dart';
import 'package:flutter_eapp/screens/Admin/Reports.dart';
import 'package:flutter_eapp/screens/Admin/adjustProducts.dart';
import 'package:flutter_eapp/screens/Admin/adminLogin.dart';
import 'package:flutter_eapp/screens/Admin/adminManage.dart';
import 'package:flutter_eapp/screens/Admin/adminSellerApprove.dart';
import 'package:flutter_eapp/screens/Admin/adminSellerControl.dart';
import 'package:flutter_eapp/screens/Admin/manageCaregories.dart';
import 'package:flutter_eapp/screens/Admin/manageCoupones.dart';
import 'package:flutter_eapp/screens/Admin/manageProducts.dart';
import 'package:flutter_eapp/screens/Admin/subCategories.dart';
import 'package:flutter_eapp/screens/Seller/SellerReports.dart';
import 'package:flutter_eapp/screens/Seller/sellerHome.dart';
import 'package:flutter_eapp/screens/Seller/sellerInsertProducts.dart';
import 'package:flutter_eapp/screens/Seller/sellerOrders.dart';
import 'package:flutter_eapp/screens/Seller/sellerVerifyedHome.dart';
import 'package:flutter_eapp/screens/Seller/selleraccess.dart';
import 'package:flutter_eapp/screens/Seller/sellerprofile.dart';
import 'package:flutter_eapp/screens/Seller/sellrNew.dart';
import 'package:flutter_eapp/screens/User/CatandSubcat.dart';
import 'package:flutter_eapp/screens/User/FavouriteStores.dart';
import 'package:flutter_eapp/screens/User/Shops.dart';
import 'package:flutter_eapp/screens/User/UserProfile.dart';
import 'package:flutter_eapp/screens/User/checkout.dart';
import 'package:flutter_eapp/screens/User/favouriteItems.dart';
import 'package:flutter_eapp/screens/User/home.dart';
import 'package:flutter_eapp/screens/User/loginsccreen.dart';
import 'package:flutter_eapp/screens/User/points.dart';
import 'package:flutter_eapp/screens/User/product.dart';
import 'package:flutter_eapp/screens/User/search.dart';
import 'package:flutter_eapp/screens/User/shoppingcart.dart';
import 'package:flutter_eapp/screens/User/signupscreen.dart';
import 'package:flutter_eapp/screens/User/userOrders.dart';
import 'package:flutter_eapp/screens/splashscreen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());



}

class MyApp extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    future:  Firebase.initializeApp();


    return  MultiProvider(

      providers: [
        ChangeNotifierProvider <Modelhut> (
            create: (context)=> Modelhut())
        ,

        ChangeNotifierProvider <AdminMode> (
            create: (context)=> AdminMode())

      ],
      child: GetMaterialApp(



          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,

          initialRoute: SplashScreenPage.id,

          routes : <String, WidgetBuilder>{
            LoginScreen.id:(BuildContext context) => LoginScreen(),
            Signupscreen.id:(BuildContext context) => Signupscreen(),
            Home.id:(BuildContext context)=> Home(),
            AdminMain.id:(BuildContext context)=> AdminMain(),
            adjustProducts.id:(BuildContext context)=> adjustProducts(),

            ManageProducts.id:(BuildContext context)=> ManageProducts(),
            AdminManage.id:(BuildContext context)=> AdminManage(),
            ManageCategories.id:(BuildContext context)=> ManageCategories(),
            SubCategories.id:(BuildContext context)=> SubCategories(),
            Search.id:(BuildContext context)=> Search(),
            CategoriesAndSubCategories.id:(BuildContext context)=> CategoriesAndSubCategories(),
            Checkout.id :(BuildContext context)=> Checkout(),
            Selleraccess.id :(BuildContext context)=> Selleraccess(),
            SellerNew.id :(BuildContext context)=> SellerNew(),
            SellerHome.id :(BuildContext context)=> SellerHome(),
            SellerInsert.id  :(BuildContext context)=> SellerInsert(),
            AdminLogin.id:(BuildContext context)=> AdminLogin(),
            AdminSellerAprove.id:(BuildContext context)=> AdminSellerAprove(),
            AdminSellerControl.id:(BuildContext context)=> AdminSellerControl(),

            ProductPage.id :(BuildContext context)=> ProductPage(),
            UserOrders.id :(BuildContext context)=> UserOrders(),
            SellerOrders.id :(BuildContext context)=> SellerOrders(),
            SplashScreenPage.id :(BuildContext context)=> SplashScreenPage(),
            UserInfo1.id :(BuildContext context)=> UserInfo1(),
            Shops.id :(BuildContext context)=> Shops(),
            Reports.id :(BuildContext context)=> Reports(),
            ShoppingCart.id: (BuildContext context)=> ShoppingCart(true),
            FavouriteItems.id: (BuildContext context)=> FavouriteItems(),
            FollowedStores.id: (BuildContext context)=> FollowedStores(),
            CashedReports.id :(BuildContext context)=> CashedReports(),
            PointsPage.id :(BuildContext context)=> PointsPage(),
            manageCoupones.id :(BuildContext context)=> manageCoupones(),
            SellerReportsforseller.id:(BuildContext context)=> SellerReportsforseller(),
            SellerProfile.id:(BuildContext context)=> SellerProfile(),
            ShowHome.id :(BuildContext context)=> ShowHome(),
          }



      ),
    );








  }


}



class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }

  @override
  void initState() {

    // ...

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message['notification']['body']);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['body']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

}


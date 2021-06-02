import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eapp/screens/Admin/adminLogin.dart';
import 'package:flutter_eapp/screens/Seller/selleraccess.dart';

class AdminMode extends ChangeNotifier {
  int admintaps =0;
  bool isAdmin =false;
int taps = 0;

enterseller (ctx)
{

   taps++;
  if (taps == 5 ){
    isAdmin = true;
    taps = 0 ;
    //print ('AdminIS here');
    Navigator.of(ctx).pushNamed(Selleraccess.id);

  }
  notifyListeners();


}


  enteradmin (ctx)
  {

    admintaps++;
    if (admintaps == 10 ){
      isAdmin = true;
      admintaps = 0 ;
      Navigator.of(ctx).pushNamed(AdminLogin.id);

    }
    notifyListeners();


  }









  changeisAdmin(ctx )
  {
    taps++;
    if (taps == 10 ){
      isAdmin = true;
      taps = 0 ;
      Navigator.of(ctx).pushNamed(Selleraccess.id);

    }
    notifyListeners();

  }





  }



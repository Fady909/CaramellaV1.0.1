import 'package:flutter/cupertino.dart';

class Modelhut extends ChangeNotifier
{
  bool isLoading =false;
bool currantaddress= false;



  changeisLoading(bool value)
  {
    isLoading=value;
    notifyListeners();
  }



  
  
  

}
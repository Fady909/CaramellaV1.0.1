

import 'package:cloud_firestore/cloud_firestore.dart';

class UserReports{
  int AskedOrders , CancelledOrders,CompletedOrders;
  String Email , Phone ,name , photo , uid ;
  Timestamp Time;

  UserReports(this.AskedOrders, this.CancelledOrders, this.CompletedOrders,
      this.Email, this.Phone, this.name, this.photo, this.uid, this.Time);
}
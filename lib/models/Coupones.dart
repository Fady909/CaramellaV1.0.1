import 'package:cloud_firestore/cloud_firestore.dart';

class Coupones{
  String Coupon , taken , Comment;
  Timestamp TimeGiven;
  int DiscountValue , ValuedTill , which;

  Coupones(this.Coupon, this.taken, this.which, this.TimeGiven,
      this.DiscountValue, this.ValuedTill , {this.Comment});


}
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerReports{
  int ProductsSold , TotalProducts ;
  String Seller_Email , Phone ,Seller_Name , Cash , sID ,pID , SellerID ;
Timestamp TimeOrdered , DateTime;
double adminpercent;

  SellerReports(this.ProductsSold, this.TotalProducts, this.Seller_Email,
      this.Phone, this.Seller_Name , this.SellerID, this.DateTime,{this.adminpercent});

  SellerReports.name(this.Cash, this.sID, this.pID, this.TimeOrdered);
}
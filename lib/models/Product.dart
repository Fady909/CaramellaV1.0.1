

class Product {
  DateTime TimePosted;
  String Productname;
  String Productprice;
  String productDiscount;
  String productAfterSale;
  String Productdescription;
  String Productcategory;
  String Productimage;
  String ProductsubCategory;
  String company;
  List<dynamic>  colors;
  double rating;
  int remainingQuantity;
  String pID;
  int amount;
  String state;
  String sellername;
  String sellershop;
String sellerID ;
String sellerToken;
  Product(
    this.pID,
    this.Productname,
    this.Productprice,
    this.Productdescription,
    this.Productcategory,
    this.Productimage,
    this.ProductsubCategory,
    this.productAfterSale,
    this.productDiscount,
    this.rating,
    this.remainingQuantity,
      {
    this.amount,
    this.sellername,
    this.sellershop,
    this.state,
        this.sellerID,
        this.TimePosted,
        this.sellerToken,
      this.colors
      });
}

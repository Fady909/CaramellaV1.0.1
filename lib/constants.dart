import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color kdark = Color(0xffd64dcf);
Color klight = Color(0xffffaef3);


Color kAppPrimaryColor = Colors.grey.shade200;
Color kWhite = Colors.white;
Color kLightBlack = Colors.black.withOpacity(0.075);
Color mCC = Colors.green.withOpacity(0.65);
Color fCL = Colors.grey.shade600;
const ksellercollection = 'Sellers';
const kselleremail = 'Seller E-mail';
const ksellerpass = 'Seller Password';
const ksellerverified = 'Verified';
const ksellernew = 'IsNew';
const ksellername = 'Seller Name';
const kshopname = 'Seller shop';
const kPstate = 'state';


const kproductcollection = 'Products';
const kproductamountneeded = 'amount';
const kProductdiscount = 'Product Discount';
const kProductsubCategory = 'Product SubCategory';
const kProductName = 'Product Name';
const kProductPrice = 'Product Price';
const kProductDescription = 'Product Description';
const kpCategorycollection = 'categories';
const kProductCategory = 'Product Categroy';
const kproductImage = 'Product Image';
const kCategoryName = 'category';
const kSubCatName = 'subcategory';
const kpsubCategorycollection = 'subCategory';
const ksubcategory_OriginalCategoryID = 'subcat_CatID';
const ksubcategoryCatgoryName = 'CategoryName';
const kDefaultPaddin = 20.0;
const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);

IconData twitter = IconData(0xe900, fontFamily: "CustomIcons");
IconData facebook = IconData(0xe901, fontFamily: "CustomIcons");
IconData googlePlus =
IconData(0xe902, fontFamily: "CustomIcons");
IconData linkedin = IconData(0xe903, fontFamily: "CustomIcons");

const kSpacingUnit = 10;

final kTitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

BoxDecoration avatarDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: kAppPrimaryColor,
    boxShadow: [
      BoxShadow(
        color: kWhite,
        offset: Offset(10, 10),
        blurRadius: 10,
      ),
      BoxShadow(
        color: kWhite,
        offset: Offset(-10, -10),
        blurRadius: 10,
      ),
    ]
);
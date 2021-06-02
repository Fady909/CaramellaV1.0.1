import 'package:flutter/material.dart';
import 'package:flutter_eapp/screens/User/CatandSubcat.dart';
import 'package:flutter_eapp/utils/FadeAnimation.dart';


class MainImage extends StatefulWidget {
  @override
  _MainImageState createState() => _MainImageState();
}

class _MainImageState extends State<MainImage> {
  @override
  Widget build(BuildContext context) {
    return Container (
        height: 300,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(    'https://images.unsplash.com/photo-1526178613552-2b45c6c302f0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',

                ),
                fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
            Colors.black.withOpacity(.8),
            Colors.black.withOpacity(.2),
          ])),
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      FadeAnimation(
                          1.5,
                          Text(
                            "تفقد اخر منتجاتنا",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      FadeAnimation(
                          1.7,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: <Widget>[
                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),

                              GestureDetector(
                                onTap: (){

                                  Navigator.of(context).push(

                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoriesAndSubCategories(CategoryName : "All")


                                      ,
                                    ),


                                  );
                                },
                                child: Text(
                                  "المزيد؟",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),


                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

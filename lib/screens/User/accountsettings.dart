import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_eapp/screens/User/UserProfile.dart';
import 'package:flutter_icons/flutter_icons.dart';


class AccountSettings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final StyleClass settingsItemIconStyle = StyleClass()
    ..padding(all: 8)
    ..borderRadius(all: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account Settings",
          style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 18),
        ),
        leading: IconButton(
          icon:
              Icon(Ionicons.ios_arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "My Brands",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.7), fontSize: 18),
                      ),
                      leading: Division(
                        style: StyleClass()
                          ..backgroundColor("#9F6083")
                          ..add(settingsItemIconStyle),
                        child: Icon(
                          Feather.package,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    elevation: 1,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {

                  Navigator.pushNamed(context, UserInfo1.id);



                },
                child: Container(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "My Information",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.7), fontSize: 18),
                      ),
                      leading: Division(
                        style: StyleClass()
                          ..backgroundColor("#FDB78B")
                          ..add(settingsItemIconStyle),
                        child: Icon(
                          Feather.user,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    elevation: 1,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Address",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.7), fontSize: 18),
                      ),
                      leading: Division(
                        style: StyleClass()
                          ..backgroundColor("#57CFE2")
                          ..add(settingsItemIconStyle),
                        child: Icon(
                          Feather.map_pin,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    elevation: 1,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Credit Cards",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.7), fontSize: 18),
                      ),
                      leading: Division(
                        style: StyleClass()
                          ..backgroundColor("#606B7E")
                          ..add(settingsItemIconStyle),
                        child: Icon(
                          Feather.credit_card,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    elevation: 1,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Change Password",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.7), fontSize: 18),
                      ),
                      leading: Division(
                        style: StyleClass()
                          ..backgroundColor("#24ACE9")
                          ..add(settingsItemIconStyle),
                        child: Icon(
                          Feather.lock,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    elevation: 1,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Container(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Exit",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.7), fontSize: 18),
                      ),
                      leading: Division(
                        style: StyleClass()
                          ..backgroundColor("#FB7C7A")
                          ..add(settingsItemIconStyle),
                        child: Icon(
                          Feather.log_out,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    elevation: 1,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

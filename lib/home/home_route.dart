import 'package:fitpass_app/constants/constants.dart';
import 'package:fitpass_app/home/home_model_data.dart';
import 'package:fitpass_app/login/login_route.dart';
import 'package:fitpass_app/login/user_model.dart';
import 'package:fitpass_app/network/api_request.dart';
import 'package:fitpass_app/sharedprefrance/sharedprefrance.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeRoute> {
  List<HomeModelData> listitem = new List<HomeModelData>();

  String location = 'Loading...';
//  UserModel model;

  Future<String> getCurrentLocation() async {
    Api api = new Api();
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    // permission granted
    print(geolocationStatus.value);
      Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      Position position = await geolocator
          .getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
              locationPermissionLevel: GeolocationPermission.locationWhenInUse)
          .catchError((e) {
        print(e);
        location = e.toString();
        return e.toString();
      });

      if (position != null) {
        String appKey = await Sharedprefrance.getString(Appconstants.APP_KEY);
        int userId = await Sharedprefrance.getInt(Appconstants.USER_ID);

        location = '${position.latitude},${position.longitude}';

        var response = await api.getStudiosList(userId, appKey, position.latitude, position.longitude);

        if (response['code'] == 200) {
          var jsonData = response['data'] as List;
          List<HomeModelData> list =
              jsonData.map((value) => HomeModelData.fromJson(value)).toList();
          listitem.addAll(list);
        } else {
          setState(() {
            location = response['message'];
          });
        }


      return location;
    } else {
      location = 'Location permission not granted.';
      return location;
    }
  }

  @override
  Widget build(BuildContext context) {
//    model = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              useLogout();
            },
          )
        ],
      ),
      body: getChild(),
    );
  }

  Widget getChild() {
    return FutureBuilder(
      future: getCurrentLocation(),
      builder: (context, snapshot) {
        if (listitem.isEmpty) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(location, style: TextStyle(fontSize: 20)),
          ));
        } else if (listitem.isNotEmpty) {
          return createList();
        }
        return createList();
      },
    );
  }

  Widget createList() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(location, style: TextStyle(fontSize: 20)),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, pos) {
              return Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, bottom: 10, left: 10, right: 10),
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 10, left: 10, right: 10),
                        child: Text(listitem[pos].studio_name,
                            style:
                                TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 5, left: 10, right: 10),
                        child: Text(listitem[pos].address_line1,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 10, left: 10, right: 10),
                        child: Text(listitem[pos].about_studio,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: listitem.length,
          ),
        ),
      ],
    );
  }

  void useLogout() async {
    Sharedprefrance.putBoolean(Appconstants.IS_LOGGED_IN, false);
    Navigator.pop(context);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => LoginRoute(),
            settings: RouteSettings(name: "Login Route")),
            (Route<dynamic> route) => false);
  }
}

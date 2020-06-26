import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/firebase_model.dart';
import 'package:flutter_firebase/screens/home.dart';
import 'package:flutter_firebase/widgets/custom_dialog.dart';
import 'package:package_info/package_info.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version;
  String url;
  final fbdb = FirebaseDatabase.instance;
  final fbs = Firestore.instance;
  var ref;
  FirebaseModel firebaseModel;
  PackageInfo packageInfo;
  String appVersion;

  @override
  initState() {
    super.initState();
  }

  updateCheck(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
      // String appName = packageInfo.appName;
      // String packageName = packageInfo.packageName;
      // String version = packageInfo.version;
      // String buildNumber = packageInfo.buildNumber;
    });

    ref = fbdb.reference();
    ref.child("updates").once().then((DataSnapshot data) {
      Map<String, dynamic> mapRes = json.decode(json.encode(data.value));
      print(mapRes);
      firebaseModel =
          FirebaseModel.fromJson(json.decode(json.encode(data.value)));

      version = firebaseModel.version;
      url = firebaseModel.url;
    });

    Timer(Duration(seconds: 2), () {
      if (version == appVersion) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(
                      appVersion: appVersion,
                    )),
            (Route<dynamic> route) => false);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return UpdateCheckDialog(
                updateUrl: url,
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    updateCheck(context);
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
              height: 45,
              width: 45,
              child: Theme(
                data: ThemeData(accentColor: Colors.white),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                ),
              )),
        ],
      ),
    );
  }
}

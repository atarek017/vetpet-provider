import 'package:flutter/material.dart';
import 'package:vetwork_partner/pages/screens/VpConfirm.dart';
import 'package:vetwork_partner/pages/screens/VpHome.dart';
import 'package:vetwork_partner/pages/screens/VpMapView.dart';
import 'package:vetwork_partner/pages/widgets/BillDetalis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/network/NetworkConstants.dart';
import 'pages/screens/login.dart';
import 'dart:async';

void main() async {
  String providerId = await getProviderId();
  print("________________________________________________________");
  await NetworkConstants.getBaseIP();
  print("BASE ADD " + NetworkConstants.baseAddress);

  return runApp(AppHome(providerId.toString()));
}

class AppHome extends StatelessWidget {
  String providerId;

  AppHome(this.providerId);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          providerId == '' ? Login() : HomePage(),
    );
  }
}

Future<String> getProviderId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String authToken = (prefs.getString('providerId')).toString();
  if (authToken.toString() == 'null' ||
      authToken.toString() == null ||
      authToken.toString().isEmpty) {
    authToken = '';
  }

  return authToken;
}

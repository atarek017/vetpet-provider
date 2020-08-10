import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_partner/model/active_requests/active_request_model.dart';

enum ActiveRequestsState {
  activeList,
  requestDetails,
  finalBill,
}

class StaticRoutData {
  static ActiveRequest activeRequest;
  static List<int> signUpUserServices = [];
  static GlobalKey<ScaffoldState> scaffoldkey ;

}

snackMsg(String code, GlobalKey<ScaffoldState> _scaffoldkey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String message = prefs.getString(code);

  if (message != null || message != '')
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(message)));
  else
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(code)));
}

Future<String> getMsg(String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String message = prefs.getString(code);

  if (message != null || message != '')
    return message;
  else
    return code;
}

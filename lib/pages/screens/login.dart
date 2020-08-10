import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_partner/data/network/NetworkConstants.dart';
import 'package:vetwork_partner/data/network/VpNetworkUserRepo.dart';
import 'package:vetwork_partner/data/repo/VpUserRepo.dart';
import 'package:vetwork_partner/model/login_provider/UserLoginModel.dart';
import 'package:vetwork_partner/model/login_provider/UserLoginRespondModel.dart';
import 'package:vetwork_partner/model/lookups/lookupsMsg.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';
import 'package:vetwork_partner/pages/screens/VpVerifyView.dart';
import '../widgets/blueCircle.dart';
import '../widgets/background_container.dart';
import '../util/style.dart';
import 'SignUp.dart';
import 'VpHome.dart';
import 'VpSettings.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  VpUserRepo userRepo = VpNetworkUserRepo();

  bool isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  init() async {
    bool lookup = await getLookups();
    if (lookup == null || lookup == false) {
      List<LookupsMsg> lookupsMsg = [];
      lookupsMsg = await userRepo.lookupsMsg();

      savelookupsMsg(lookupsMsg);
      setLookups(true);
    }

    print("________________________________________________________");
    await NetworkConstants.getBaseIP();
    print("BASE ADD " + NetworkConstants.baseAddress);
  }

  @override
  void initState() {
    init();
    super.initState();
    //firebaseCloudMessaging_Listeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: Stack(
          children: <Widget>[
            BackgroundContainer(),
            Positioned(
              bottom: -120,
              right: -70,
              child: BlueCircle(),
            ),
            isLoading
                ? Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 30,
                                ),
                                Container(
                                  height: 100,
                                  child: Image.asset(
                                    'assets/pics/group.png',
                                    width: 215,
                                    height: 70,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.settings,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Settings()));
                                  },
                                ),
                              ],
                            ),
                            // Welcome on top of screen
                            Container(
                              margin: EdgeInsets.all(24.0),
                              child: Text(
                                "Welcome, Provider - Register an account, for a call from our admin to verify you",
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                            // Information paragraph about app
                            Container(
                              margin: EdgeInsets.all(24.0),
                              child: Text(
                                appInfo,
                                // you can find text in app_text -> login_text.dart
                                style: Theme.of(context).textTheme.caption,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // E-mail Text field
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'EMAIL',
                                  labelStyle: textFieldLabelStyle,
                                  errorText: validateEmail(emailController.text)
                                      ? "please enter valid E-mail"
                                      : null,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                              ),
                            ),
                            // Password Text field
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: passwordFiled(),
                            ),
                            // Error message if account no exist or not verify yet
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 48.0, right: 16.0, left: 16.0),
                              child: Text(
                                accountErrorMessage,
                                // you can find text in app_text -> login_text.dart
                                style: errorMessageStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Sign in button
                            Container(
                              margin: EdgeInsets.only(
                                  top: 48.0, right: 16.0, left: 16.0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[900],
                                      Colors.blue[700],
                                      Colors.blue,
                                    ],
                                  )),
                              child: MaterialButton(
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Sign in",
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () {
                                  if (emailController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    apiLoginCall();
                                  } else {
                                    displaySnackBar('please fill empty fields');
                                  }
                                },
                                color: Colors.transparent,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            // Register Button
                            Container(
                              child: InkWell(
                                child: Text(
                                  "registe an account",
                                  style: registerButtonStyle,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ProviderInfoSignUp()));
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ],
        ));
  }

  Widget passwordFiled() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'PASSWORD',
        labelStyle: textFieldLabelStyle,
        suffixIcon: IconButton(
            // Switch between two icons when make password visibility or not
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            }),
      ),
      obscureText: _obscureText,
      controller: passwordController,
    );
  }

  bool validateEmail(String value) {
    if (value.isEmpty) return false;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }

  apiLoginCall() async {
    setState(() {
      isLoading = true;
    });

    UserLoginRespond userLoginRespond = new UserLoginRespond();

    userLoginRespond = await userRepo
        .signInUser(
      UserLoginModel(emailController.text,
          'KFB9368N-1XE5-4Z4E-R62A-9W4E26927J9G', passwordController.text),
    )
        .catchError((error) {
      print("Eroore : " + error.toString());
    });

    setState(() {
      isLoading = false;
    });
    if (userLoginRespond.success == false) {
      snackMsg(userLoginRespond.code.toString(), _scaffoldkey);
    } else if (userLoginRespond.provId != null) {
      setAuthToken(userLoginRespond.authToken.toString());
      setUserProvider(userLoginRespond.provId);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      setAuthToken(userLoginRespond.authToken.toString());
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              VerifyView(emailController.text, passwordController.text)));
    }
  }

  displaySnackBar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  setAuthToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('authToken : ' + value);
    prefs.setString('authToken', value);
  }

  setPushToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('authToken : ' + value);
    prefs.setString('pushToken', value);
  }

  setUserProvider(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('providerId : ' + value);
    prefs.setString('providerId', value);
  }

  setLookups(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('lookups', value);
  }

  Future<bool> getLookups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('lookups');
  }

  savelookupsMsg(List<LookupsMsg> lookupsMsg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < lookupsMsg.length; i++) {
      await prefs.setString(lookupsMsg[i].code.toString(), lookupsMsg[i].msg);
    }
  }

//For push
// void firebaseCloudMessaging_Listeners() {
//   if (Platform.isIOS) iOS_Permission();
//   _firebaseMessaging.configure();
//   _firebaseMessaging.getToken().then((token){
//     print("VetPet provider : Token $token");
//     if(token!=null)
//       setPushToken(token);
//       //userRepo.updatePushToken(token);
//   });

//   _firebaseMessaging.configure(
//     onMessage: (Map<String, dynamic> message) async {
//       print('on message $message');
//     },
//     onResume: (Map<String, dynamic> message) async {
//       print('on resume $message');
//     },
//     onLaunch: (Map<String, dynamic> message) async {
//       print('on launch $message');
//     },
//   );
// }
// void iOS_Permission() {
//   _firebaseMessaging.requestNotificationPermissions(
//       IosNotificationSettings(sound: true, badge: true, alert: true)
//   );
//   _firebaseMessaging.onIosSettingsRegistered
//       .listen((IosNotificationSettings settings)
//   {
//     print("Settings registered: $settings");
//   });
// }

}

String appInfo =
    "Vetwork providers is the gateway for providers to register their services and approve requests from cleits";
String accountErrorMessage =
    "your account is still pending confirmation, please wait for a call form our admin to verify yor account";

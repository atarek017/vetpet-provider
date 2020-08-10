import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vetwork_partner/model/confirm_provider/ConfirmModel.dart';
import 'package:vetwork_partner/model/confirm_provider/ConfirmRespond.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';
import '../widgets/blueCircle.dart';
import '../widgets/background_container.dart';
import '../util/style.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_partner/data/repo/VpUserRepo.dart';
import 'package:vetwork_partner/data/network/VpNetworkUserRepo.dart';

import 'VpHome.dart';
import 'login.dart';

class ConfirmView extends StatefulWidget {
  String email;

  String appid = 'KFB9368N-1XE5-4Z4E-R62A-9W4E26927J9G';
  String password;
  String countrycode = '+20';
  String phoneNumber;

  ConfirmView(this.email, this.password, this.phoneNumber);

  @override
  _ConfirmViewState createState() => _ConfirmViewState();
}

class _ConfirmViewState extends State<ConfirmView> {
  double _screenWidth;
  double _screenHeight;
  bool isLoading = false;

  VpUserRepo userRepo = VpNetworkUserRepo();
  TextEditingController tokenController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    return Scaffold(
        key: _scaffoldkey,
        body: Container(
          width: _screenWidth,
          height: _screenHeight,
          child: Stack(
            children: <Widget>[
              BackgroundContainer(),
              Positioned(
                bottom: -120,
                right: -70,
                child: BlueCircle(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: buildListView(),
              ),
            ],
          ),
        ));
  }

  Widget buildListView() {
    return ListView(
      children: <Widget>[
        SizedBox(height: 100),
        TextField(
          decoration: InputDecoration(
            labelText: 'Token',
            labelStyle: textFieldLabelStyle,
          ),
          keyboardType: TextInputType.number,
          controller: tokenController,
        ),
        SizedBox(
          height: 100,
        ),
        isLoading
            ? Container(
          width: 50,
          height: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: _screenWidth * 0.1),
                height: 50,
                child: MaterialButton(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .7,
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.blue[600],
                            Colors.blue[900],
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      child: Text(
                        'Enter Confirmation Code',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    ConfirmRespond response =
                        await userRepo.confirmToken(ConfirmModel(
                      widget.email,
                      widget.appid,
                      widget.password,
                      widget.countrycode,
                      widget.phoneNumber,
                      tokenController.text,
                    ));
                    setState(() {
                      isLoading = false;
                    });

                    if (response != null && response.success == true) {
                      setProviderId(response.providerId);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else if (response != null && response.code != null) {
                      snackMsg(response.code.toString(), _scaffoldkey);
                    } else if (response == null || response.code == null) {
                      displaySnackBar('false');
                    }
                  },
                ),
              )
      ],
    );
  }

  setProviderId(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('providerId', value);
  }

  displaySnackBar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}

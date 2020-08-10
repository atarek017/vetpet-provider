import 'package:flutter/material.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';
import '../widgets/blueCircle.dart';
import '../widgets/background_container.dart';
import '../util/style.dart';
import 'package:vetwork_partner/data/repo/VpUserRepo.dart';
import 'package:vetwork_partner/data/network/VpNetworkUserRepo.dart';
import 'package:vetwork_partner/model/verify_provider/UserRequestModel.dart';
import 'package:vetwork_partner/model/verify_provider/VerifyResponseModel.dart';
import 'VpConfirm.dart';

class VerifyView extends StatefulWidget {
  String email;
  String pass;

  VerifyView(this.email, this.pass);

  @override
  _VerifyViewState createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> {
  double _screenWidth;
  double _screenHeight;
  bool isLoading = false;
  VpUserRepo userRepo = VpNetworkUserRepo();
  TextEditingController phoneController = TextEditingController();
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
            labelText: 'Enter your mobile number',
            hintText: '01001661399',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            prefixText: '+20 ',
            prefixStyle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
            labelStyle: textFieldLabelStyle,
          ),
          keyboardType: TextInputType.phone,
          controller: phoneController,
        ),
        SizedBox(height: 50),
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
                        'Verify',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    VerifyResponseModel response = await userRepo.verifyUser(
                        UserRequestModel(widget.email, widget.pass, null, null,
                            phoneController.text));
                    setState(() {
                      isLoading = false;
                    });
                    print('request success : ${response.success}');
                    if (response != null && response.success == true) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ConfirmView(widget.email,
                              widget.pass, phoneController.text)));
                    } else if (response != null) {
                      snackMsg(response.code.toString(), _scaffoldkey);
                    }
                  },
                ),
              )
      ],
    );
  }

  displaySnackBar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}

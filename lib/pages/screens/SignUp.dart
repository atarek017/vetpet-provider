import 'package:flutter/material.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';
import 'package:vetwork_partner/pages/util/style.dart';
import 'package:vetwork_partner/pages/widgets/background_home.dart';
import 'package:vetwork_partner/pages/widgets/custom_service_chip.dart';

import 'package:vetwork_partner/data/repo/VpUserRepo.dart';
import 'package:vetwork_partner/data/network/VpNetworkUserRepo.dart';
import 'package:vetwork_partner/data/network/NetworkConstants.dart';
import 'package:vetwork_partner/model/UserModel.dart';
import 'package:vetwork_partner/model/RequestModel.dart';
import 'package:vetwork_partner/model/ParseError.dart';

import 'login.dart';

class ProviderInfoSignUp extends StatefulWidget {
  createState() {
    return ProviderInfoSignUpState();
  }
}

class ProviderInfoSignUpState extends State<ProviderInfoSignUp> {
  bool formFilled = false;
  bool _obscureText = true;
  List<String> servicesLabels = [
    'HealthCare',
    'Grooming',
  ];
  List<CustomChip> servicesChips = [];
  List<bool> checked = [false, false, false, false, false, false];
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  VpUserRepo userRepo = VpNetworkUserRepo();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            width: screenWidth,
            height: screenHeight,
          ),
          Background(),
          _buildAppBar(),
          isLoading
              ? Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                    top: 100.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: _buildBodyColumn(screenWidth),
                )
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 25,
      left: 0.0,
      right: 0.0,
      child: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: Row(
          children: <Widget>[
            SizedBox(
              width: 15.0,
            ),
            InkWell(
              child: Icon(Icons.close, color: Colors.black, size: 40.0),
              onTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        title: Row(
          children: <Widget>[
            // Image.asset('assets/pics/logo.png'),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Vetwork',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyColumn(double screenWidth) {
    return ListView(
      children: <Widget>[
        _buildForm(screenWidth),
        SizedBox(
          height: 30.0,
        ),
        _buildSignUpButton(screenWidth),
        SizedBox(
          height: 30.0,
        ),
      ],
    );
  }

  Widget _buildForm(screenWidth) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Provider\'s Information',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          'Add your information to register a provider account',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        nameTextField(),
//        SizedBox(
//          height: 10.0,
//        ),
//        phoneTextField(),
        SizedBox(
          height: 10.0,
        ),
        emailField(),
        SizedBox(
          height: 10.0,
        ),
        passwordFiled(),
        SizedBox(
          height: 25.0,
        ),
//        Align(
//          alignment: Alignment.centerLeft,
//          child: Text(
//            'ADDRESS',
//            style: TextStyle(
//              fontSize: 18.0,
//              color: Colors.blue[900],
//            ),
//          ),
//        ),
//        SizedBox(
//          height: 15.0,
//        ),
//        _buildAreaOfServicesButton(screenWidth),
        SizedBox(
          height: 30.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Choose your available services',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          formFilled
              ? ''
              : 'You must at least pick 1 of the services that you provide.',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red[600],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        _buildServicesGridView(),
      ],
    );
  }

  Widget _buildServicesGridView() {
    return Wrap(
      spacing: 10.0,
      children: true
          ? servicesChips = servicesLabels.map(
              (
                label,
              ) {
                return CustomChip(
                  index: servicesLabels.indexOf(label) + 1,
                  label: label,
                  clicked: false,
                  error: !formFilled,
                );
              },
            ).toList()
          : Container(),
    );
  }

  Widget nameTextField() {
    return TextField(
      controller: nameController,
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: 'NAME',
        labelStyle: TextStyle(
          fontSize: 18.0,
          color: Colors.blue[900],
        ),
        hintText: 'Provider\'s Name',
      ),
    );
  }

//  Widget phoneTextField() {
//    return TextField(
//      controller: phoneController,
//      style: TextStyle(
//        fontSize: 20.0,
//        color: Colors.black,
//      ),
//      decoration: InputDecoration(
//          labelText: 'PHONE',
//          labelStyle: TextStyle(
//            fontSize: 18.0,
//            color: Colors.blue[900],
//          ),
//          hintText: 'xxxxxxxxxxx',
//          hintStyle: TextStyle(
//            color: Colors.grey,
//          ),
//          prefixText: '+20 ',
//          prefixStyle: TextStyle(
//            color: Colors.black,
//            fontSize: 20.0,
//          ),
//          suffixIcon: Container(
//            margin: EdgeInsets.only(top: 15.0),
//            child: IconButton(
//              icon: Icon(
//                Icons.check_circle,
//                color: Colors.white,
//                size: 30.0,
//              ),
//              onPressed: () {},
//            ),
//          ),
//          suffix: Text(
//            'Verify',
//            style: TextStyle(
//              fontSize: 18.0,
//              color: Colors.grey[800],
//            ),
//          )),
//    );
//  }

  Widget emailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'EMAIL',
        labelStyle: textFieldLabelStyle,
        errorText: validateEmail(emailController.text)
            ? "please enter valid E-mail"
            : null,
      ),
    );
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

//  Widget _buildAreaOfServicesButton(screenWidth) {
//    return MaterialButton(
//      padding: EdgeInsets.all(0.0),
//      onPressed: () {},
//      child: Container(
//        padding: EdgeInsets.only(left: 15.0, right: 15.0),
//        width: screenWidth * 0.9,
//        height: 50.0,
//        decoration: BoxDecoration(
//          border: Border.all(
//            width: 1.0,
//            color: Colors.grey[300],
//          ),
//          borderRadius: BorderRadius.circular(8.0),
//          color: Colors.white,
//        ),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Text(
//              'Areas of Services',
//              style: TextStyle(fontSize: 18.0),
//            ),
//            Icon(
//              Icons.add,
//            )
//          ],
//        ),
//      ),
//    );
//  }

  Widget _buildSignUpButton(double screenWidth) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.blue[600],
              Colors.blue[900],
            ],
          ),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0)),
      height: 60.0,
      child: MaterialButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          List<String> name = [];
          bool haveSpace = nameController.text.contains(' ');

          String fName = " ";
          String lName = " ";

          if (haveSpace) {
            name = nameController.text.split(' ');
            fName = name[0];
            lName = name[1];
          } else {
            fName = nameController.text.toString();
            lName = ' .';
          }
          var response = await userRepo
              .registerUser(UserModel(
                  fname: fName,
                  lname: lName,
                  email: emailController.text,
                  password: passwordController.text,
                  appid: NetworkConstants.appid,
                  services: StaticRoutData.signUpUserServices,
                  address: Address(
                      line1: 'line1',
                      line2: 'line2',
                      state: 'state',
                      postalcode: 'code',
                      location: '22.5888,-22.688',
                      countryiso: 'EG',
                      city: 'city')))
              .catchError((onError) {
            print(onError.toString());
          });

          setState(() {
            isLoading = false;
          });

          if (response is RequestModel) {
            if (response.success) {
              displaySnackBar('you registe Successfully, you can login now');
              await Future.delayed(const Duration(seconds: 2));
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Login()));
            } else {
              snackMsg(response.code.toString(), scaffoldKey);
            }
          } else {
            displaySnackBar(
                'Error message ${(response as ParseError).message}');
          }


        },
        child: Center(
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  displaySnackBar(message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
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
}

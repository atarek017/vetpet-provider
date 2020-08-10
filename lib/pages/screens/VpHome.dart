import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_partner/data/network/VpNetworkRquestRepo.dart';
import 'package:vetwork_partner/data/network/VpNetworkUserRepo.dart';
import 'package:vetwork_partner/data/repo/VpRequestRepo.dart';
import 'package:vetwork_partner/data/repo/VpUserRepo.dart';
import 'package:vetwork_partner/model/PedningRequest.dart';
import 'package:vetwork_partner/pages/widgets/navigation_text.dart';
import 'package:vetwork_partner/pages/widgets/vavigation_icon.dart';
import 'VpCompletedRequests.dart';
import 'VpHomeView.dart';
import 'VpMapView.dart';
import 'login.dart';
import 'package:vetwork_partner/data/network/NetworkConstants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navigationIndex = 0;
  VpUserRepo userRepo = VpNetworkUserRepo();


  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    VpRequestRepo requestRepo = VpNetworkRequestRepo();

    String providerId = await getProviderId();
    await requestRepo
        .getPendingRequests(
            PendingRequest(providerId, "31.328333392739296,30.059618200", "EG"))
        .then((response) {
      if (NetworkConstants.statusCode == 401) {
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Login()));
      }
    }).catchError((onError) {
      print('error ' + onError.toString());
      print('code status :' + NetworkConstants.statusCode.toString());
      if (NetworkConstants.statusCode == 401) {
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Login()));
      }
    }).whenComplete(() {
      userRepo.updatePushToken().then((value) {
        print('token sent correctly');
      }).catchError((error) {
        print('token not correctly');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectPage(_navigationIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: NavigationIcon(Icons.home), title: NavigationText('Home')),
          BottomNavigationBarItem(
              icon: NavigationIcon(Icons.map), title: NavigationText('Map')),
          BottomNavigationBarItem(
            icon: NavigationIcon(Icons.line_weight),
            title: NavigationText('Requests'),
          ),
        ],
        currentIndex: _navigationIndex,
        onTap: (value) {
          setState(() {
            _navigationIndex = value;
          });
        },
      ),
    );
  }

  Widget _selectPage(int index) {
    Widget content = HomeView();
    switch (index) {
      case 1:
        content = MapPage();
        break;
      case 2:
        content = VpCompletedRequests();
        break;
    }
    return content;
  }

  Future<String> getProviderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String providerId = (prefs.getString('providerId'));
    return providerId;
  }
}

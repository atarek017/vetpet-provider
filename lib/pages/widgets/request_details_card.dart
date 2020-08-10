import 'package:flutter/material.dart';
import 'package:vetwork_partner/data/network/VpNetworkRquestRepo.dart';
import 'package:vetwork_partner/data/repo/VpRequestRepo.dart';
import 'package:vetwork_partner/model/active_requests/active_request_model.dart';
import 'package:vetwork_partner/model/cancel_request/cancelReqestModel.dart';
import 'package:vetwork_partner/model/change_request_status/ChangeRequestStatusRespond.dart';
import 'package:vetwork_partner/model/change_request_status/changeRequestStatusModel.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';
import 'package:vetwork_partner/pages/screens/VpMapDirections.dart';
import 'package:vetwork_partner/pages/widgets/BillDetalis.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CompleatBilldetails.dart';

class RequestDetailsCard extends StatelessWidget {
  String dogImage = 'https://www.what-dog.net/Images/faces2/scroll0015.jpg';
  VpRequestRepo vpRequestRepo = VpNetworkRequestRepo();

  ActiveRequest _activeRequest;
  final Function selectView;

  RequestDetailsCard(this._activeRequest, this.selectView);

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: _scaffoldkey,
      padding: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: ListView(
          children: <Widget>[
            Text(
              _activeRequest.userInfo.username.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(color: Colors.blue[900], fontSize: 18),
            ),
            SizedBox(
              height: 10.0,
            ),
            buildPetImageStack(),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Pet Name',
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.subtitle.copyWith(fontSize: 16),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              _activeRequest.visitTime.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(
              height: 5.0,
            ),
            Card(
              child: DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Column(
                  children: <Widget>[
                    TabBar(
                      indicatorColor: Colors.blue,
                      tabs: <Widget>[
                        Tab(
                          child: buildAction(Icons.dialer_sip, 'Contact'),
                        ),
                        Tab(
                          child: buildAction(Icons.directions, 'Directions'),
                        ),
                        Tab(
                          child: buildAction(Icons.view_list, 'Bill'),
                        )
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .70,
                      child: TabBarView(
                        // widgets
                        children: <Widget>[
                          buildContactDetails(context),
                          buildDirectionsDetails(context),
                        _activeRequest.statusId == null ||
                            _activeRequest.statusId < 5?BillDetails(_activeRequest, selectView):CompleatBilldetails(_activeRequest),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPetImageStack() {
    return Center(
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            width: 100.0,
            height: 100.0,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.grey[200],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45.0),
                image: DecorationImage(
                  image: NetworkImage(
                    dogImage,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -15.0,
            top: 30.0,
            child: Container(
              width: 35.0,
              height: 35.0,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1.0,
                    color: Colors.grey,
                  ),
                ],
              ),
              child: Image.asset('assets/images/checklist_30.png'),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAction(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 15.0,
            color: Colors.grey[400],
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 10.0, color: Colors.grey[900]),
          ),
        ],
      ),
    );
  }

  Widget buildContactDetails(context) {
    List<String> serviceNames = [];
    for (int i = 0; i < _activeRequest.invoiceServices.length; i++) {
      serviceNames.add(_activeRequest.invoiceServices[i].name.toString());
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            color: Colors.grey[400],
            height: 2,
          ),
          SizedBox(
            height: 15.0,
          ),
          InkWell(
            child: Text(
              "(+" +
                  _activeRequest.userInfo.countrycode.toString() +
                  ") " +
                  _activeRequest.userInfo.phone.toString(),
              style: TextStyle(color: Colors.grey[800]),
              textAlign: TextAlign.start,
            ),
            onTap: () {
              launch("tel://${_activeRequest.userInfo.phone}");
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          Text("Request details:",
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 18)),
          SizedBox(
            height: 15.0,
          ),
          buildServiceTab(context,
              _activeRequest.services[0].svcTypName.toString(), serviceNames),
          SizedBox(
            height: 50,
          ),

          Align(
            alignment: Alignment.center,
            child: _activeRequest.statusId == null ||
                    _activeRequest.statusId < 4
                ? InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .7,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue[500],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () async {
                      VpRequestRepo vpRequestRepo = VpNetworkRequestRepo();
                      await vpRequestRepo
                          .cancelRequest(new CancelRequestStatusModel(
                              " ", _activeRequest.reqId.toString(), "sds"))
                          .then((onValue) {
                        if (onValue.success == false) {
                          snackMsg(onValue.code, StaticRoutData.scaffoldkey);
                        } else if (onValue.success == true) {
                          snackMsg("111", StaticRoutData.scaffoldkey);
                        }
                      }).catchError((onError) {
                        print("erorr" + onError.toString());
                      });
                    },
                  )
                : Container(),
          ),
//        buildServiceTab(
//            context, 'Health Care', ['Anal Sac Evacuation', 'X-Ray']),
//        SizedBox(
//          height: 5.0,
//        ),
//        buildServiceTab(context, 'Other', ['Description Goes Here'],
//            imagesUrl: [dogImage, dogImage, dogImage]),
        ],
      ),
    );
  }

  Widget buildDirectionsDetails(context) {
    List<String> serviceNames = [];
    for (int i = 0; i < _activeRequest.invoiceServices.length; i++) {
      serviceNames.add(_activeRequest.invoiceServices[i].name.toString());
    }

    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            color: Colors.grey[400],
            height: 2,
          ),
          SizedBox(
            height: 15.0,
          ),
          InkWell(
            onTap: () async {

              choseMapRun(context);
            },
            child:
                _activeRequest.statusId == null || _activeRequest.statusId < 5
                    ? Container(
                        margin: EdgeInsets.only(left: width * .15),
                        width: width * .6,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(colors: [
                              Colors.blue[900],
                              Colors.blue[700],
                              Colors.blue,
                            ])),
                        child: Center(
                            child: Text(
                          'View on map',
                          style: TextStyle(color: Colors.white),
                        )),
                      )
                    : Container(),
          ),
          SizedBox(
            height: 30.0,
          ),
          buildServiceTab(context,
              _activeRequest.services[0].svcTypName.toString(), serviceNames),
//          SizedBox(
//            height: 15.0,
//          ),
//          buildServiceTab(context, 'Grooming (petSize)', []),
//          SizedBox(
//            height: 5.0,
//          ),
//          buildServiceTab(
//              context, 'Health Care', ['Anal Sac Evacuation', 'X-Ray']),
//          SizedBox(
//            height: 5.0,
//          ),
//          buildServiceTab(context, 'Other', ['Description Goes Here'],
//              imagesUrl: [dogImage, dogImage, dogImage]),
        ],
      ),
    );
  }

  Widget buildServiceTab(context, String title, List<String> services,
      {List<String> imagesUrl}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey[300]),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Row(
          children: <Widget>[
            Icon(
              Icons.add,
              color: Colors.black,
              size: 18.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              '$title',
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(color: Colors.blue[900], fontSize: 13),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 0.00001,
        ),
        children: <Widget>[
          Padding(
            padding: services.length != 0
                ? EdgeInsets.only(bottom: 20.0)
                : EdgeInsets.only(bottom: 0.0),
            child: imagesUrl == null
                ? Column(
                    children:
                        services.map((service) => buildText(service)).toList(),
                  )
                : Column(
                    children: <Widget>[
                      buildText(services.first),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 35.0,
                        ),
                        child: Row(
                          children:
                              imagesUrl.map((url) => buildImage(url)).toList(),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildText(String serviceLabel) {
    return Padding(
      padding: EdgeInsets.only(
        left: 35.0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$serviceLabel',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget buildImage(String url) {
    return Container(
      width: 30.0,
      margin: EdgeInsets.only(right: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          width: 1.0,
          color: Colors.grey[400],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 35.0,
        ),
        child: Image.network(
          url,
          width: 30.0,
          height: 30.0,
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Cancel Visit"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  displaySnackBar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  _openMap(String location) async {
    // Android
    String url = 'https://www.google.com/maps/search/?api=1&query=$location';
//    final url ='maps.google.com/maps?q=loc:$location';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      final url = 'http://maps.apple.com/?ll=$location';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }


  choseMapRun(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("View map on  "),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Container(child: new Text("Google map")),
              onPressed: () async {
                await changVisitStat();
                List<String> loc=_activeRequest.location.split(',');
                String location = loc[1]+","+loc[0];

                print("location" + location);
                _openMap(location);
              },
            ),

            new FlatButton(
              child: new Text("App map"),
              onPressed: () async {
                await changVisitStat();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MapDirections(_activeRequest)));
              },
            ),
          ],
        );
      },
    );
  }

  changVisitStat() async {
    ChangeRequestStatusRespond changStateRespond = await vpRequestRepo
        .changeRequestStatus(new ChangeRequestStatusModel(
            " ", _activeRequest.reqId.toString(), "3", " "))
        .catchError((onError) {
      print("erorr" + onError.toString());
    });
  }
}

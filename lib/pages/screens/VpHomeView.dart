import 'package:flutter/material.dart';
import 'package:vetwork_partner/model/active_requests/active_request_model.dart';
import 'package:vetwork_partner/model/active_requests/root_response_model.dart';
import 'package:vetwork_partner/data/network/VpNetworkRquestRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';
import 'package:vetwork_partner/pages/widgets/active_request_tile.dart';
import 'package:vetwork_partner/pages/widgets/finall_bill.dart';
import 'package:vetwork_partner/pages/widgets/request_details_card.dart';
import '../../model/active_requests/root_response_model.dart';
import 'dart:async';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  ActiveRequestsState _activeRequestsState;
  ActiveRequest _activeRequest;
  Future<List<ActiveRequest>> requestsFuture;
  List<ActiveRequest> requests = [];
  String date;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    StaticRoutData.scaffoldkey=_scaffoldkey;
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key:_scaffoldkey ,
      body: Stack(
        children: <Widget>[
          Container(
            width: screenWidth,
            height: screenHeight,
          ),
          _buildBackgroundCircile(),
          _buildAppBar(),
          getCurrentState(),
          _activeRequestsState != ActiveRequestsState.activeList
              ? Positioned(
                  right: 10,
                  top: 20,
                  child: backButton(),
                )
              : Container()
        ],
      ),
    );
  }

  Widget backButton() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
        size: 40,
      ),
      onPressed: selectScreen,
    );
  }

  selectScreen() {
    if (_activeRequestsState == ActiveRequestsState.requestDetails) {
      setState(() {
        _activeRequestsState = ActiveRequestsState.activeList;
      });
    }

    if (_activeRequestsState == ActiveRequestsState.finalBill) {
      setState(() {
        _activeRequestsState = ActiveRequestsState.requestDetails;
      });
    }
  }

  Widget getCurrentState() {
    switch (_activeRequestsState) {
      case ActiveRequestsState.activeList:
        return activeRequestsList();
      case ActiveRequestsState.requestDetails:
        return RequestDetailsCard(_activeRequest, selectFinalBill);
      case ActiveRequestsState.finalBill:
        return FinalBill(homActiveRequest);
    }
    return Container();
  }

  void selectFinalBill() {
    setState(() {
      _activeRequestsState = ActiveRequestsState.finalBill;
    });
  }
  void homActiveRequest(){
    setState(() {
      _activeRequestsState = ActiveRequestsState.activeList;
      init();
    });
  }

  Widget activeRequestsList() {
    return FutureBuilder(
      future: requestsFuture,
      builder: (context, AsyncSnapshot<List<ActiveRequest>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            break;
          default:
            {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('There is no active requests right now.'),
                );
                print('\n\nNo Data\n\n');
              } else {
                date = '';
                requests.clear();
                requests.addAll(snapshot.data);
                List<Widget> children = [
                  _buildText('Scheduled Visits'),
                ];

                _buildListOfRequests(children);
                print(children);
                return Container(
                  margin: EdgeInsets.only(
                    top: 80.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    children: children,
                  ),
                );
              }
            }
        }
      },
    );
  }

  void _buildListOfRequests(List<Widget> children) {
    children.addAll(requests.map((requestData) {
      if (date == requestData.visitTime.substring(0,10)) {
        return RequestTile(
          request: requestData,
        );
      } else {
        date = requestData.visitTime.substring(0,10);
        return Container(
          margin: EdgeInsets.only(
            top: 20.0,
          ),
          child: Column(
            children: <Widget>[
              _buildDateTextWidget(date),
              SizedBox(
                height: 10.0,
              ),
              RequestTile(
                request: requestData,
                onTap: () {
                  setState(() {
                    _activeRequestsState = ActiveRequestsState.requestDetails;
                    _activeRequest = requestData;
                  });
                },
              )
            ],
          ),
        );
      }
    }).toList());

    print(children);
  }

  Widget _buildAppBar() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      height: 80.0,
      child: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: Row(
          children: <Widget>[
            SizedBox(
              width: 15.0,
            ),
          ],
        ),
        title: Image.asset(
          'assets/pics/group.png',
          width: 100,
          height: 40,
        ),
      ),
    );
  }

  Widget _buildDateTextWidget(String date) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        date,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBackgroundCircile() {
    return Positioned(
      top: -60,
      left: -50,
      right: -20,
      child: ClipRRect(
        child: Container(
          width: MediaQuery.of(context).size.width + 100,
          height: MediaQuery.of(context).size.width + 100,
          color: Colors.grey.shade300,
        ),
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width + 100),
      ),
    );
  }

  init() async {
    VpNetworkRequestRepo requestRepo = VpNetworkRequestRepo();
    String providerId = await getProviderId();
    requestsFuture =
        requestRepo.getActiveRequests(ActiveRequestBody(provid: providerId));
    _activeRequestsState = ActiveRequestsState.activeList;

    setState(() {});
  }

  Future<String> getProviderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String providerId = (prefs.getString('providerId'));
    return providerId;
  }

  displaySnackBar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}

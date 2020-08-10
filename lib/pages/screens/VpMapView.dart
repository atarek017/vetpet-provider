import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vetwork_partner/data/network/VpNetworkRquestRepo.dart';
import 'package:vetwork_partner/data/network/VpNetworkUserRepo.dart';
import 'package:vetwork_partner/data/repo/VpRequestRepo.dart';
import 'package:vetwork_partner/data/repo/VpUserRepo.dart';
import 'package:vetwork_partner/model/PedningRequest.dart';
import 'package:vetwork_partner/model/RequestModel.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';
import 'package:vetwork_partner/pages/widgets/finall_bill.dart';
import 'package:vetwork_partner/pages/widgets/request_details_card.dart';
import 'package:vetwork_partner/pages/widgets/requests_number.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vetwork_partner/pages/widgets/request_cards.dart';
import '../../enums/main_state.dart';
import '../../main.dart';
import 'package:flutter/services.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPPageState createState() => _MapPPageState();
}

class _MapPPageState extends State<MapPage> {
  MainState _mainState;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  GoogleMapController mapController;
  final Set<Marker> _markers = {};
  static LatLng _initialPosition = LatLng(31.4545, 30.343);
  static RequestModel requestModel;
  static bool providerStatus;
  List<Requests> allRequests = [];
  Timer timer;

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    await Future.delayed(const Duration(seconds: 1));
    await _getUserLocation();
    apiPendingCall();
    Timer.periodic(Duration(minutes: 1), (timer) {
      print("timer");
      apiPendingCall();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
        key: _scaffoldkey,
        body: Stack(
          children: <Widget>[
            Container(
              width: _width,
              height: _height,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 13,
                ),
                onMapCreated: onCreated,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
//            markers: _markers,
              ),
            ),
            Positioned(
                top: 50,
                left: 20,
                child: providerStatus != null ? userState() : Container()),
            _mainState == MainState.details
                ? Positioned(top: 50, right: 20, child: backButton())
                : Container(),
            getMapContent(),
          ],
        ));
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _getUserLocation() async {
    Position position;

    try {
      //final Geolocator geolocator = Geolocator()..  forceAndroidLocationManager = true;
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } on PlatformException {
      position = null;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      try {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _initialPosition, zoom: 10.0),
          ),
        );
      } catch (error) {
        print("eror" + error.toString());
      }
    });
  }

  apiPendingCall() async {
    VpRequestRepo requestRepo = VpNetworkRequestRepo();
    String providerId = await getProviderId();
    print('providerId : ' + providerId);
    requestModel = await requestRepo
        .getPendingRequests(PendingRequest(
            providerId,
            _initialPosition.longitude.toString() +
                ',' +
                _initialPosition.latitude.toString(),
            "EG"))
        .catchError((onError) {
      print('eror');
    });
    if (requestModel.code != null && requestModel.code == '401') {
      setState(() {
        providerStatus = false;
      });
    } else if (requestModel.code != null && requestModel.code == '403') {
      displaySnackBar(getMsg(requestModel.code));
    } else if (requestModel.success == true) {
      setState(() {
        providerStatus = true;
        if (requestModel.paras != null) {
          allRequests = requestModel.paras.requests;
          if (allRequests.length > 0) {
            selectTotalView();
          }
        }
        if (allRequests.length == 0) {
          selectEmptyPending();
        }
      });
    } else {
      snackMsg(requestModel.code.toString(), _scaffoldkey);
    }
  }

  Widget getMapContent() {
    if (providerStatus == true)
      switch (_mainState) {
        case MainState.total:
          return Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: InkWell(
                child: RequestNumber(
                    allRequests.length.toString() + " open requests"),
                onTap: () {
                  setState(() {
                    _mainState = MainState.requests;
                  });
                },
              ),
            ),
          );
        case MainState.requests:
          return RequestCards(selectDetailsView, allRequests);
        case MainState.details:
          return RequestDetailsCard(
              StaticRoutData.activeRequest, selectDirectionsView);
        case MainState.finalBill:
          return FinalBill(homActiveRequest);
        case MainState.directions:
          return Container();
        case MainState.emptyPending:
          print('NO Pending Request');
          return Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: RequestNumber(
                "No Pending Requests ",
              ),
            ),
          );
      }
    return Container();
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

  Widget userState() {
    VpUserRepo vpUserRepo = VpNetworkUserRepo();
    onSwitchValueChange(bool newVal) async {
      setState(() {
        providerStatus = newVal;
      });

      if (providerStatus == true) {
        print('status provider :' + providerStatus.toString());
        await vpUserRepo.onlineProviderStatus();
        apiPendingCall();
      } else if (providerStatus == false) {
        print('status provide :' + providerStatus.toString());
        await vpUserRepo.offlineProviderStatus();
      }
    }

    return Container(
      width: 130,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Switch(
              value: providerStatus,
              activeTrackColor: Colors.green[600],
              activeColor: Colors.green[800],
              onChanged: (newVal) {
                onSwitchValueChange(newVal);
              }),
          Text(
            '  Active',
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  selectScreen() {
    if (_mainState == MainState.details) {
      setState(() {
        _mainState = MainState.requests;
      });
    }
  }

  void selectEmptyPending() {
    setState(() {
      _mainState = MainState.emptyPending;
    });
  }

  void selectTotalView() {
    setState(() {
      _mainState = MainState.total;
    });
  }

  void selectRequestsView() {
    setState(() {
      _mainState = MainState.requests;
    });
  }

  void selectDetailsView() {
    setState(() {
      _mainState = MainState.details;
    });
  }

  void selectDirectionsView() {
    setState(() {
      _mainState = MainState.directions;
    });
  }

  displaySnackBar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void homActiveRequest() {
    setState(() {
      _mainState = MainState.total;
      init();
    });
  }
}

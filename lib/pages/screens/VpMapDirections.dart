import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vetwork_partner/data/network/VpMapDirections.dart';
import 'package:vetwork_partner/data/network/VpNetworkRquestRepo.dart';
import 'package:vetwork_partner/data/repo/VpRequestRepo.dart';
import 'package:vetwork_partner/model/active_requests/active_request_model.dart';
import 'package:vetwork_partner/model/change_request_status/ChangeRequestStatusRespond.dart';
import 'package:vetwork_partner/model/change_request_status/changeRequestStatusModel.dart';
import 'package:flutter/services.dart';

class MapDirections extends StatefulWidget {
  ActiveRequest activeRequest;

  MapDirections(this.activeRequest);

  @override
  State<StatefulWidget> createState() {
    return _MapDirectionsState();
  }
}

class _MapDirectionsState extends State<MapDirections> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  VpRequestRepo vpRequestRepo = VpNetworkRequestRepo();

  GoogleMapController mapController;
  static LatLng _initialPosition;

  LatLng _lastPosition = _initialPosition;
  LatLng destination;

  final Set<Polyline> _polyLines = {};
  final Set<Marker> _markers = {};
  GoogleMapsServices googleMapsServices = new GoogleMapsServices();


  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 1));
    await _getUserLocation();
    getDestination();
    print("init : " + _initialPosition.toString());
    print("dest : " + destination.toString());

    sendRequest();
  }

  void getDestination() {
    String location = widget.activeRequest.userInfo.addresses.location;
    List<String> locations = location.split(",");
    double lat = double.parse(locations[1]);
    double long = double.parse(locations[0]);
    destination = LatLng(long, lat);

    print("dest " + destination.toString());
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: new LatLng(25, 25),
                zoom: 25,
              ),
              onMapCreated: onCreated,
              myLocationEnabled: true,
              mapType: MapType.normal,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              polylines: _polyLines,
              markers: _markers,
              zoomGesturesEnabled: true,
              onCameraMove: _onCameraMove,

            ),
            bottomBar(context),
            Positioned(top: 30, right: 15, child: backButton())
          ],
        ));
  }

  Widget backButton() {
    return IconButton(

      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
        size: 40,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget bottomBar(context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 70,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue[900],
              Colors.blue[700],
              Colors.blue,
            ])),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.directions,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "You are on your way",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 2,
                ),
                Text("Time", style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: statusButom(),
            )
          ],
        ),
      ),
    );
  }

  Widget statusButom() {
    return InkWell(
      child: Container(
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.green[500],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "In Site",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onTap: () async {
        ChangeRequestStatusRespond changStateRespond = await vpRequestRepo
            .changeRequestStatus(new ChangeRequestStatusModel(
            " ", widget.activeRequest.reqId.toString(), "4", " "))
            .catchError((onError) {
          print("erorr" + onError.toString());
        });

        if (changStateRespond.success == true) {
          displaySnackBar("change status to on site successfully");
        }
      },
    );
  }

  displaySnackBar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  Future<void> _getUserLocation() async {
    Position position;

    try {
      //final Geolocator geolocator = Geolocator()..  forceAndroidLocationManager = true;
      position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
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
             CameraPosition(
                 target:_initialPosition, zoom: 16.0),
           ),
         );

      } catch (error) {
        print("eror"+error.toString());
      }
    });
  }

  /*
* [12.12, 312.2, 321.3, 231.4, 234.5, 2342.6, 2341.7, 1321.4]
* (0-------1-------2------3------4------5-------6-------7)
* */

//  this method will convert list of doubles into latlng
  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++)
      lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  void createRoute(String encondedPoly) {
    setState(() {

      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(widget.activeRequest.reqId.toString()),
        //_lastMapPosition is any coordinate which should be your default
        //position when map opens up
        position: _initialPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,

      ));

      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(widget.activeRequest.userInfo.phone.toString()),
        //_lastMapPosition is any coordinate which should be your default
        //position when map opens up
        position: destination,
        infoWindow: InfoWindow(
          title: 'adasdasd',
          snippet: 'adasdsadsadasdadsa',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(8),

      ));

      _polyLines.add(Polyline(
          polylineId: PolylineId(_lastPosition.toString()),
          width: 10,
          points: convertToLatLng(decodePoly(encondedPoly)),
          color: Colors.red));
    });
  }

  void sendRequest() async {
    String route = await googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
  }
}

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "AIzaSyAkayg9l03axkszIoI7x6hFZ70wZGENBv8";

class GoogleMapsServices {
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    http.Response response = await http.get(url).catchError((oneRor) {
      print('eror : ' + oneRor.toString());
    });

    print('status cod ' + response.statusCode.toString());
    print('body : ' + response.body);

    Map values = jsonDecode(response.body);

    print("valuse ::: "+values["routes"][0]["overview_polyline"]["points"].toString());
    if (values["routes"].toString() == '[]') return null;
    return values["routes"][0]["overview_polyline"]["points"];
  }


  Future<String> getDistance(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    http.Response response = await http.get(url).catchError((oneRor) {
      print('eror : ' + oneRor.toString());
    });

    print('status cod ' + response.statusCode.toString());
    print('body : ' + response.body);

    Map values = jsonDecode(response.body);

    print("valuse ::: "+values["routes"][0]["overview_polyline"]["points"].toString());
    if (values["routes"].toString() == '[]') return null;
    return values["routes"][0]["overview_polyline"]["points"];
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vetwork_partner/model/ParseError.dart';

import 'NetworkConstants.dart';

class VpNetworkManager {
  static final BASE_URL = NetworkConstants.baseAddress;

//  static Map<String, String> userHeader = {"Content-type": "application/json"};

  static VpNetworkManager _instance = new VpNetworkManager.internal();

  VpNetworkManager.internal();

  factory VpNetworkManager() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url, {Map<String, String> headers, encoding}) {
    return http
        .get(
      url,
      headers: headers,
    )
        .then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        ParseError error = ParseError(statusCode, 0, "error");
        return error;
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url,
      {Map<String, String> headers, body, encoding}) {
    // TODO: use ${userHeader} variable and no use headers variable when we work on design

    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      NetworkConstants.statusCode = statusCode;
      print("API Response: " + res);
      print("statusCode: " + statusCode.toString());
      print(" NetworkConstants statusCode : " + NetworkConstants.statusCode.toString());

      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new ParseError(statusCode, 0, "error");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> put(String url,
      {Map<String, String> headers, body, encoding}) {
    return http
        .put(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print("API Response: " + res);
      print("statusCode: " + statusCode.toString());

      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new ParseError(statusCode, 0, "error");
      }
      return _decoder.convert(res);
    });
  }
}

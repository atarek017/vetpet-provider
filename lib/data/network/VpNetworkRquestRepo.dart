import 'dart:convert';

import 'package:vetwork_partner/data/repo/VpRequestRepo.dart';
import 'package:vetwork_partner/model/ParseError.dart';
import 'package:vetwork_partner/model/PedningRequest.dart';
import 'package:vetwork_partner/model/RequestModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_partner/model/accept_request/accept_error.dart';
import 'package:vetwork_partner/model/accept_request/accept_model.dart';
import 'package:vetwork_partner/model/accept_request/accept_success.dart';
import 'package:vetwork_partner/model/active_requests/active_request_model.dart';
import 'package:vetwork_partner/model/active_requests/root_response_model.dart';
import 'package:vetwork_partner/model/cancel_request/cancelReqestModel.dart';
import 'package:vetwork_partner/model/change_request_status/ChangeRequestStatusRespond.dart';
import 'package:vetwork_partner/model/change_request_status/changeRequestStatusModel.dart';
import 'VpNetworkManager.dart';
import 'NetworkConstants.dart';

class VpNetworkRequestRepo extends VpRequestRepo {
  VpNetworkManager networkManager = VpNetworkManager();

  @override
  Future<List<ActiveRequest>> getActiveRequests(
      ActiveRequestBody requestBody) async {
    RootResponseModel responseModel;
    ParseError parseError;
    String body = json.encode(requestBody);
    String authToken = await getAuthToken();

    print('authToken : ' + authToken);
    print('body :- $body');

    //Api Call.
    await networkManager
        .post(NetworkConstants.activeRequests,
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer ' + authToken
            },
            body: body,
            encoding: null)
        .then((response) {
      print("response : ${response.toString()}");

      responseModel = RootResponseModel.fromJson(response);
      return responseModel.paras.requests;
    }).catchError((error) {
      parseError = error as ParseError;
      return parseError;
    });

    return responseModel.paras.requests;
  }

  @override
  Future<dynamic> getPendingRequests(PendingRequest pendingRequest) async {
    //Variables Declaration,
    RequestModel requestModel;
    ParseError parseError;
    String body = json.encode(pendingRequest);
    String authToken = await getAuthToken();

    print('authToken : ' + authToken);
    print('body :- $body');

    //Api Call.
    await networkManager
        .post(NetworkConstants.pendingRequests,
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer ' + authToken
            },
            body: body,
            encoding: null)
        .then((response) {
      print("response : ${response.toString()}");

      requestModel = RequestModel.fromJson(response);
      print('request here request model ${requestModel.toString()}');
      return requestModel;
    }).catchError((error) {
      parseError = error as ParseError;
      return parseError;
    });

    return requestModel;
  }

  @override
  Future<dynamic> acceptRequest(AcceptModel acceptModel) async {
    String authToken = await getAuthToken();
    String providerId = await getProviderId();

    AcceptSuccess acceptSuccess;
    ParseError parseError;

    Map<String, String> body = {
      "provid": providerId,
      "requestid": acceptModel.requestid.toString()
    };

    await networkManager
        .put(NetworkConstants.acceptRequest,
            body: jsonEncode(body),
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer ' + authToken
            },
            encoding: null)
        .then((response) {
      print('accept response   ${response.toString()}');

      if (response['success'] == false) {
        return AcceptError.fromJson(response);
      }
      acceptSuccess = AcceptSuccess.fromJson(response['paras']);

      return acceptSuccess;
    }).catchError((error) {
      print('accept error ${error.toString()}');
      parseError = error as ParseError;
      return parseError;
    });
    return acceptSuccess;
  }

  @override
  Future<RequestModel> connect() {
    // TODO: implement connect
    return null;
  }

  @override
  Future<RequestModel> getPrices() {
    // TODO: implement getPrices
    return null;
  }

  @override
  Future<RequestModel> getServices() {
    // TODO: implement getServices
    return null;
  }


  @override
  Future<dynamic> changeRequestStatus(ChangeRequestStatusModel changeRequestStatusModel) async{

    ChangeRequestStatusRespond changeRespond;
    ParseError parseError;

    changeRequestStatusModel.provid = await getProviderId();
    String authToken = await getAuthToken();

    await networkManager
        .put(
      NetworkConstants.changeStatus,
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer ' + authToken
      },
      body:  json.encode(changeRequestStatusModel),
      encoding: null,
    )
        .then((response) {
      print('accept response   ${response.toString()}');

      changeRespond = ChangeRequestStatusRespond.fromJson(response);
      return changeRespond;
    }).catchError((error) {
      print('accept error ${error.toString()}');
      parseError = error as ParseError;
      return parseError;
    });

    return changeRespond;

  }


  @override
  Future<dynamic> cancelRequest(CancelRequestStatusModel cancelRequestStatusModel)async {

    ChangeRequestStatusRespond changeRespond;
    ParseError parseError;

    cancelRequestStatusModel.provid = await getProviderId();
    String authToken = await getAuthToken();

    await networkManager
        .put(
      NetworkConstants.cancelRequest,
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer ' + authToken
      },
      body:  json.encode(cancelRequestStatusModel),
      encoding: null,
    )
        .then((response) {
      print('accept response   ${response.toString()}');

      changeRespond = ChangeRequestStatusRespond.fromJson(response);
      return changeRespond;
    }).catchError((error) {
      print('accept error ${error.toString()}');
      parseError = error as ParseError;
      return parseError;
    });

    return changeRespond;
  }

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = (prefs.getString('authToken'));
    return authToken;
  }

  Future<String> getProviderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String providerId = (prefs.getString('providerId'));
    return providerId;
  }


  @override
  Future<List<ActiveRequest>> getCompletedRequests(
      ActiveRequestBody requestBody) async {
    RootResponseModel responseModel;
    ParseError parseError;
    String body = json.encode(requestBody);
    String authToken = await getAuthToken();

    print('authToken : ' + authToken);
    print('body :- $body');

    //Api Call.
    await networkManager
        .post(NetworkConstants.inActiveRequests,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ' + authToken
        },
        body: body,
        encoding: null)
        .then((response) {
      print("response : ${response.toString()}");

      responseModel = RootResponseModel.fromJsonComPleat(response);
      return responseModel.paras.requests;
    }).catchError((error) {
      parseError = error as ParseError;
      return parseError;
    });

    return responseModel.paras.requests;
  }


}

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:vetwork_partner/data/repo/VpUserRepo.dart';
import 'package:vetwork_partner/model/ActiveProvideStatusRespond.dart';
import 'package:vetwork_partner/model/confirm_provider/ConfirmModel.dart';
import 'package:vetwork_partner/model/RequestModel.dart';
import 'package:vetwork_partner/model/ParseError.dart';
import 'package:vetwork_partner/model/login_provider/UserLoginModel.dart';
import 'package:vetwork_partner/model/login_provider/UserLoginRespondModel.dart';
import 'package:vetwork_partner/model/UserModel.dart';
import 'package:vetwork_partner/model/confirm_provider/ConfirmRespond.dart';
import 'package:vetwork_partner/model/lookups/lookupsMsg.dart';
import 'package:vetwork_partner/model/verify_provider/UserRequestModel.dart';
import 'package:vetwork_partner/model/verify_provider/VerifyResponseModel.dart';
import 'package:vetwork_partner/model/verify_provider/UserRequestModel.dart';
import 'package:vetwork_partner/model/verify_provider/VerifyResponseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'VpNetworkManager.dart';
import 'NetworkConstants.dart';

class VpNetworkUserRepo extends VpUserRepo {
  VpNetworkManager networkManager = VpNetworkManager();

  @override
  Future<dynamic> confirmToken(ConfirmModel confirmModel) async {
    ConfirmRespond userConfirmRespond;
    ParseError parseError;
    confirmModel.deviceid = await getDeviceDetails();

    String confirm = json.encode(confirmModel);
    String authToken = await getAuthToken();

    await networkManager
        .post(NetworkConstants.confirmToken,
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer ' + authToken
            },
            body: confirm,
            encoding: null)
        .then(
      (response) {
        print('response type : ${response.toString()}');
        userConfirmRespond = ConfirmRespond.fromJson(response);
        print('userConfirmRespond :' + userConfirmRespond.success.toString());
        return userConfirmRespond;
      },
    ).catchError(
      (error) {
        print('error type ${error.toString()}');
        parseError = error as ParseError;
        return parseError;
      },
    );
    return userConfirmRespond;
  }

  @override
  Future<UserModel> requestToken() {
    // TODO: implement requestToken
    return null;
  }

  @override
  Future<dynamic> registerUser(UserModel userModel) async {
    RequestModel requestModel;
    ParseError parseError;
    String user = json.encode(userModel);

    print("USER : " + user.toString());
    await networkManager
        .post(NetworkConstants.REGISTERUSER,
            headers: {
              "Content-Type": "application/json",
            },
            body: user,
            encoding: null)
        .then((response) {
      print('response type : ${response.toString()}');
      requestModel = RequestModel.fromJson(response);
      return requestModel;
    }).catchError((error) {
      print('error type ${error.toString()}');
      parseError = error as ParseError;
      return parseError;
    });
    return requestModel;
  }

  @override
  Future<dynamic> signInUser(UserLoginModel userLoginModel) async {
    UserLoginRespond userLoginRespond;
    ParseError parseError;
    String user = json.encode(userLoginModel);

    print('user : $user');
    await networkManager
        .post(NetworkConstants.LOGIN,
            headers: {"Content-type": "application/json"},
            body: user,
            encoding: null)
        .then(
      (response) {
        print('response type : ${response.toString()}');
        userLoginRespond = UserLoginRespond.fromJson(response);

        return userLoginRespond;
      },
    ).catchError(
      (error) {
        print('error type ${error.toString()}');
        parseError = error as ParseError;
        return parseError;
      },
    );
    return userLoginRespond;
  }

  @override
  Future<VerifyResponseModel> verifyUser(
      UserRequestModel userRequestModel) async {
    VerifyResponseModel verifyResponseModel;
    userRequestModel.deviceid = await getDeviceDetails();
    userRequestModel.countrycode = '+20';
    String authToken = await getAuthToken();

    String body = json.encode(userRequestModel);

    print('body: ' + body);

    await networkManager
        .post(NetworkConstants.requestToken,
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer ' + authToken
            },
            body: body,
            encoding: null)
        .then(
      (response) {
        print('response type : ${response.toString()}');

        verifyResponseModel = VerifyResponseModel.fromJson(response);
        print('verifyResponseModel ' + verifyResponseModel.success.toString());
        return verifyResponseModel;
      },
    ).catchError(
      (error) {
        print('error type ${error.toString()}');
        VerifyResponseModel parseError = VerifyResponseModel.fromJson(error);
        return parseError;
      },
    );
    return verifyResponseModel;
  }

  @override
  Future<ActiveProvideStatusRespond> onlineProviderStatus() async {
    ActiveProvideStatusRespond activeProvideStatusRespond;
    String authToken = await getAuthToken();
    String providerId = await getProviderId();
    ParseError parseError;
    Map<String, String> body = {
      'provId': providerId,
    };

    await networkManager
        .put(NetworkConstants.online,
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer ' + authToken
            },
            body: jsonEncode(body),
            encoding: null)
        .then((response) {
      print('response type : ${response.toString()}');
      activeProvideStatusRespond =
          ActiveProvideStatusRespond.fromJson(response);
      return activeProvideStatusRespond;
    }).catchError(
      (error) {
        print('error type ${error.toString()}');
        parseError = error as ParseError;
        return parseError;
      },
    );

    return activeProvideStatusRespond;
  }

  @override
  Future<ActiveProvideStatusRespond> offlineProviderStatus() async {
    ActiveProvideStatusRespond activeProvideStatusRespond;
    String authToken = await getAuthToken();
    ParseError parseError;
    String providerId = await getProviderId();
    Map<String, String> body = {
      'provId': providerId,
    };
    await networkManager
        .put(NetworkConstants.offline,
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer ' + authToken
            },
            body: jsonEncode(body),
            encoding: null)
        .then((response) {
      print('response type : ${response.toString()}');
      activeProvideStatusRespond =
          ActiveProvideStatusRespond.fromJson(response);
      return activeProvideStatusRespond;
    }).catchError(
      (error) {
        print('error type ${error.toString()}');
        parseError = error as ParseError;
        return parseError;
      },
    );

    return activeProvideStatusRespond;
  }

  @override
  Future lookupsMsg() async {
    List<LookupsMsg> lookupsMsg=[];
    await networkManager
        .get(NetworkConstants.Lookups, headers: null, encoding: null)
        .then((response) {
       response['paras']['msgs'].forEach((v) {
        lookupsMsg.add(new LookupsMsg.fromJson(v));
      });

      return lookupsMsg;
    }).catchError((parseError) {
      return parseError;
    });

    return lookupsMsg;
  }

  static Future<String> getDeviceDetails() async {
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        //deviceName = build.model;
        identifier = build.androidId.toString();
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        //deviceName = data.name;
        //deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } catch (e) {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return identifier;
  }

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = (prefs.getString('authToken'));
    return authToken;
  }

  Future<String> getPushToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = (prefs.getString('pushToken'));
    return authToken;
  }

  Future<String> getProviderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String providerId = (prefs.getString('providerId'));
    return providerId;
  }

  @override
  Future<bool> updatePushToken()async {
    String providerId = await getProviderId();
    String authToken = await getAuthToken();
    String pushToken = await getPushToken();
    var jsonBody = {"provid":providerId,"token":pushToken};
    await networkManager
        .post(NetworkConstants.update_token,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ' + authToken
        },
        body: jsonBody,
        encoding: null)
        .then(
          (response) {
        print('response type : ${response.toString()}');
        if(response["success"] == true)
          return true;
        else
          return false;
      },
    ).catchError(
          (error) {
        print('error type ${error.toString()}');
        return false;
      },
    );

    return false;
  }
}

import 'package:vetwork_partner/model/active_requests/user_info_model.dart';
import 'package:vetwork_partner/model/services/Service.dart';

class AcceptSuccess {
  int _requestid;
  UserInf _userInfo;

  AcceptSuccess(this._requestid, this._userInfo);

  AcceptSuccess.fromJson(Map<String, dynamic> json) {
    this._requestid = json['requestid'];
    this._userInfo=UserInf.fromJson(json['userinfo']);

  }

  int get requestid => _requestid;

  set requestid(int value) {
    _requestid = value;
  }

  UserInf get userInfo => _userInfo;

  set userInfo(UserInf value) {
    _userInfo = value;
  }
}

class UserInf {
  UserAddress _address;
  String _name;
  String _phone;
  String _countrycode;
  List<Services> _services;

  List<Services> invoiceServices;
  double visiteFees;
  double extraFees;

  UserInf(this._name, this._countrycode, this._phone, this._services);


  UserInf.fromJson(Map<String, dynamic> json) {
    this._name = json['name'];
    this._countrycode = json['countrycode'];
    this._phone = json['phone'];
    this._address = UserAddress.fromJson(json['addresses']);
    List<dynamic> tempList = json['services'];
    _services =
        tempList.map((serviceJson) => Services.fromJsonAcceptRequest(serviceJson)).toList();

    List<dynamic> tempList2 = json['invoices'][0]['services'];
    invoiceServices = tempList2
        .map((serviceJson) => Services.fromInvoicesServices(serviceJson))
        .toList();

    if (json['invoices'][0]['visitFees'].length != 0) {
      visiteFees = json['invoices'][0]['visitFees'][0]['totalPrice'];
    }

    if (json['invoices'][0]['extraFees'].length != 0) {
      extraFees = json['invoices'][0]['extraFees'][0]['totalPrice'];
    }

  }


  UserAddress get address => _address;

  set address(UserAddress value) {
    _address = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get countrycode => _countrycode;

  set countrycode(String value) {
    _countrycode = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  List<Services> get services => _services;
  set services(List<Services> value) {
    _services = value;
  }
}

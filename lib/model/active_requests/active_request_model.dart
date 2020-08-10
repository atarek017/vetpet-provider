import 'package:vetwork_partner/model/services/Service.dart';
import 'user_info_model.dart';

class ActiveRequest {
  int reqId;
  String location;
  String visitTime;
  String creationTime;
  int statusId;
  bool byadmin;
  UserInfo userInfo;
  List<Services> services;
  List<Services> invoiceServices;
  double visiteFees;
  double extraFees;
  double paid;
  double totalCost;

  ActiveRequest(
      {this.reqId,
      this.location,
      this.visitTime,
      this.creationTime,
      this.statusId,
      this.byadmin,
      this.userInfo,
      this.services,
      this.invoiceServices,
      this.visiteFees,
      this.extraFees});

  ActiveRequest.fromJson(Map<String, dynamic> parsedJson) {
    reqId = parsedJson['reqId'];
    location = parsedJson['location'];
    visitTime = parsedJson['visitTime'];
    creationTime = parsedJson['creationTime'];
    statusId = parsedJson['statusId'];
    byadmin = parsedJson['byadmin'];
    userInfo = UserInfo.fromJson(parsedJson['userInfo']);

    List<dynamic> tempList = parsedJson['services'];

    services =
        tempList.map((serviceJson) => Services.fromJson(serviceJson)).toList();

    List<dynamic> tempList2 = parsedJson['invoices'][0]['services'];

    invoiceServices = tempList2
        .map((serviceJson) => Services.fromInvoicesServices(serviceJson))
        .toList();

    if (parsedJson['invoices'][0]['visitFees'].length != 0) {
      if (parsedJson['invoices'][0]['visitFees'].length > 1) {
        visiteFees = parsedJson['invoices'][0]['visitFees'][0]['totalPrice'] +
            parsedJson['invoices'][0]['visitFees'][1]['totalPrice'];
      } else {
        visiteFees = parsedJson['invoices'][0]['visitFees'][0]['totalPrice'];
      }
    }

    if (parsedJson['invoices'][0]['extraFees'].length != 0) {
      extraFees = parsedJson['invoices'][0]['extraFees'][0]['totalPrice'];
    }
  }

  ActiveRequest.fromJsonComPleat(Map<String, dynamic> parsedJson) {
    reqId = parsedJson['reqId'];
    location = parsedJson['location'];
    visitTime = parsedJson['visitTime'];
    creationTime = parsedJson['creationTime'];
    statusId = parsedJson['statusId'];
    byadmin = parsedJson['byadmin'];
    userInfo = UserInfo.fromJson(parsedJson['userInfo']);

    List<dynamic> tempList = parsedJson['services'];
    services =
        tempList.map((serviceJson) => Services.fromJson(serviceJson)).toList();

    List<dynamic> tempList2 = parsedJson['finalInvoices'];
    if (tempList2.length > 0) {
      List<dynamic> tempList = parsedJson['finalInvoices'][0]['services'];
      invoiceServices = tempList
          .map((serviceJson) => Services.fromFinalInvoices(serviceJson))
          .toList();


      if (parsedJson['finalInvoices'][0]['visitFees'].length != 0) {
        if (parsedJson['finalInvoices'][0]['visitFees'].length  > 1) {
          visiteFees = parsedJson['finalInvoices'][0]['visitFees'][0]['totalPrice'] +
              parsedJson['finalInvoices'][0]['visitFees'][1]['totalPrice'];
        } else {
          visiteFees =  parsedJson['finalInvoices'][0]['visitFees'][0]['totalPrice'];        }
      }


      if (parsedJson['finalInvoices'][0]['extraFees'].length != 0) {
        extraFees =
            parsedJson['finalInvoices'][0]['extraFees'][0]['totalPrice'];
      }

      totalCost = parsedJson['finalInvoices'][0]['totalCost'];
      paid = parsedJson['finalInvoices'][0]['paid'];
    } else {
      List<dynamic> tempList = parsedJson['initialInvoices'][0]['services'];
      invoiceServices = tempList
          .map((serviceJson) => Services.fromFinalInvoices(serviceJson))
          .toList();

      if (parsedJson['initialInvoices'][0]['visitFees'].length != 0) {
        visiteFees =
            parsedJson['initialInvoices'][0]['visitFees'][0]['totalPrice'];
      }

      if (parsedJson['initialInvoices'][0]['extraFees'].length != 0) {
        extraFees =
            parsedJson['initialInvoices'][0]['extraFees'][0]['totalPrice'];
      }

      totalCost = parsedJson['initialInvoices'][0]['totalCost'];
      paid = parsedJson['initialInvoices'][0]['paid'];
    }
  }

  ActiveRequest.fromAcceptJson(Map<String, dynamic> parsedJson) {
    reqId = parsedJson['requestid'];
    userInfo = UserInfo.fromJson(parsedJson['userinfo']);

    List<dynamic> tempList = parsedJson['userInfo']['services'];
    services =
        tempList.map((serviceJson) => Services.fromJson(serviceJson)).toList();
  }
}

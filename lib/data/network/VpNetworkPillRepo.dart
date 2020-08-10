import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_partner/data/repo/VpPill.dart';
import 'package:vetwork_partner/model/ParseError.dart';
import 'package:vetwork_partner/model/confirm_invoice/BillInvoice.dart';
import 'package:vetwork_partner/model/confirm_invoice/ConfirmInvoicModel.dart';
import 'package:vetwork_partner/model/confirm_invoice/ConfirmInvoiceRespond.dart';
import 'package:vetwork_partner/model/prices/GetPricesRespond.dart';
import 'package:vetwork_partner/model/prices/PriceRequestModel.dart';
import 'package:vetwork_partner/model/services/GetServicesRespond.dart';
import 'package:vetwork_partner/model/services/Service.dart';

import 'NetworkConstants.dart';
import 'VpNetworkManager.dart';

class VpNetworkPillRepo extends VpPill {
  VpNetworkManager networkManager = VpNetworkManager();

  @override
  Future<List<Services>> getAllServices() async {
    String authToken = await getAuthToken();
    ParseError parseError;
    String providerId = await getProviderId();
    GetServicesRespond getServicesRespond;
    Map<String, String> body = {
      'provid': providerId,
    };
    await networkManager
        .post(NetworkConstants.services,
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer ' + authToken
            },
            body: jsonEncode(body),
            encoding: null)
        .then(
      (response) {
        getServicesRespond = GetServicesRespond.fromJson(response);

        return getServicesRespond.services;
      },
    ).catchError(
      (error) {
        print('error type ${error.toString()}');
        parseError = error as ParseError;
        return parseError;
      },
    );

    return getServicesRespond.services;
  }

  @override
  Future<GetPricesRespond> getPrices(
      PriceRequestModel priceRequestModel) async {
    GetPricesRespond getPricesRespond;

    String authToken = await getAuthToken();
    ParseError parseError;
    priceRequestModel.providerId = await getProviderId();

    print('auth : ' + authToken);
    String body = json.encode(priceRequestModel);
    print('body : ' + body.toString());

    await networkManager
        .post(NetworkConstants.prices,
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer ' + authToken
            },
            body: body,
            encoding: null)
        .then(
      (response) {
        print('respond ' + response.toString());

        getPricesRespond = GetPricesRespond.fromJson(response);

        return getPricesRespond;
      },
    ).catchError(
      (error) {
        print('error type ${error.toString()}');
        parseError = error as ParseError;
        return parseError;
      },
    );

    return getPricesRespond;
  }

  @override
  Future<ConfirmInvoiceRespond> confirmInvoice(
      ConfirmInvoiceModel confirmInvoiceModel) async {
    String authToken = await getAuthToken();
    ParseError parseError;
    ConfirmInvoiceRespond confirmInvoiceRespond;
    confirmInvoiceModel.provid = await getProviderId();
    print('auth : ' + authToken);

    String body = json.encode(confirmInvoiceModel);
    print('body : ' + body.toString());

    print('count : ' + confirmInvoiceModel.svcItems[0].count.toString());
    await networkManager
        .post(NetworkConstants.confirminvoice,
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer ' + authToken
            },
            body: body)
        .then(
      (response) {
        print('respond::::::::: ' + response.toString());
        confirmInvoiceRespond = ConfirmInvoiceRespond.fromJson(response);

        print("sucess : "+ confirmInvoiceRespond.success.toString());
        return confirmInvoiceRespond;
      },
    ).catchError(
      (error) {
        print('error type ${error.toString()}');
        parseError = error as ParseError;
        return parseError;
      },
    );
    return confirmInvoiceRespond;
  }


  @override
  Future<ConfirmInvoiceRespond> billInvoice(BillInvoice billInvoice) async{
    String authToken = await getAuthToken();
    ParseError parseError;
    ConfirmInvoiceRespond confirmInvoiceRespond;
    billInvoice.provid = await getProviderId();
    print('auth : ' + authToken);

    String body = json.encode(billInvoice);
    print('body : ' + body.toString());

    print('count : ' + billInvoice.svcItems[0].count.toString());
    await networkManager
        .post(NetworkConstants.billInvoices,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ' + authToken
        },
        body: body)
        .then(
          (response) {
        print('respond::::::::: ' + response.toString());
        confirmInvoiceRespond = ConfirmInvoiceRespond.fromJson(response);

        print("sucess : "+ confirmInvoiceRespond.success.toString());
        return confirmInvoiceRespond;
      },
    ).catchError(
          (error) {
        print('error type ${error.toString()}');
        parseError = error as ParseError;
        return parseError;
      },
    );
    return confirmInvoiceRespond;

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

}

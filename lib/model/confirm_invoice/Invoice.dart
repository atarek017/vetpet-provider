import 'package:vetwork_partner/model/services/Service.dart';

import 'Fees.dart';

class Invoice {
  int _reqId;
  double _totalCost;
  double _paid;
  List<Services> _services;
//  List<Fees> _visitFees;
//  List<Fees> _extraFees;

  double _visitFees;
  double _extraFees;

  Invoice(this._reqId, this._totalCost, this._paid, this._services,
      this._visitFees, this._extraFees);

  int get reqId => _reqId;

  set reqId(int reqId) => _reqId = reqId;

  double get totalCost => _totalCost;

  set totalCost(double totalCost) => _totalCost = totalCost;

  double get paid => _paid;

  set paid(double paid) => _paid = paid;

  List<Services> get services => _services;

  set services(List<Services> services) => _services = services;

  double get visitFees => _visitFees;

  set visitFees(double visitFees) => _visitFees = visitFees;

  double get extraFees => _extraFees;

  set extraFees(double value) => _extraFees = value;

  Invoice.fromJson(Map<String, dynamic> parsedJson) {
    _reqId = parsedJson['reqId'];
    _totalCost = parsedJson['totalCost'];

    if(parsedJson['paid']!=null){
      _paid = parsedJson['paid'];
    }

    if (parsedJson['services'] != null) {
      _services = new List<Services>();
      parsedJson['services'].forEach((v) {
        _services.add(new Services.fromJsonInvoice(v));
      });
    }

//    if (parsedJson['visitFees'] != null) {
//      _visitFees = new List<Fees>();
//      parsedJson['visitFees'].forEach((v) {
//        _visitFees.add(new Fees.fromJson(v));
//      });
//    }
//
//    if (parsedJson['extraFees'] != null) {
//      _extraFees = new List<Fees>();
//      parsedJson['extraFees'].forEach((v) {
//        _extraFees.add(new Fees.fromJson(v));
//      });
//    }

    if (parsedJson['visitFees'].length != 0) {
      if (parsedJson['visitFees'].length > 1) {
        _visitFees = parsedJson['visitFees'][0]['totalPrice'] +
            parsedJson['visitFees'][1]['totalPrice'];
      } else {
        _visitFees = parsedJson['visitFees'][0]['totalPrice'];
      }
    }

    if (parsedJson['extraFees'].length != 0) {
      extraFees = parsedJson['extraFees'][0]['totalPrice'];
    }
  }

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['reqId'] = this._reqId;
//    data['totalCost'] = this._totalCost;
//    data['paid'] = this._paid;
//
//    if (this._services != null) {
//      data['services'] = this._services.map((v) => v.toJsonInvoice()).toList();
//    }
//
//    if (this._visitFees != null) {
//      data['visitFees'] = this._visitFees.map((v) => v.toJson()).toList();
//    }
//
//    if (this._extraFees != null) {
//      data['extraFees'] = this._extraFees.map((v) => v.toJson()).toList();
//    }
//
//    return data;
//  }
}

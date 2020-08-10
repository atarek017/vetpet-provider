import 'package:vetwork_partner/model/services/Service.dart';

class ConfirmInvoiceModel {
  String _provid;
  String _requestid;
  String _cash;
  String _comment;
  String _paymentMethodId;
  List<Services> _svcItems;

  ConfirmInvoiceModel(this._provid, this._requestid, this._cash, this._comment,
      this._paymentMethodId, this._svcItems);

  String get provid => _provid;
  set provid(String provid) => _provid = provid;

  String get requestid => _requestid;
  set requestid(String requestid) => _requestid = requestid;

  String get cash => _cash;
  set cash(String cash) => _cash = cash;

  String get comment => _comment;
  set comment(String comment) => _comment = comment;

  String get paymentMethodId => _paymentMethodId;
  set paymentMethodId(String paymentMethodId) =>
      _paymentMethodId = paymentMethodId;

  List<Services> get svcItems => _svcItems;
  set svcItems(List<Services> svcItems) => _svcItems = svcItems;


  ConfirmInvoiceModel.fromJson(Map<String, dynamic> parsedJson) {
    _provid = parsedJson['provid'];
    _requestid = parsedJson['requestid'];
    _cash = parsedJson['cash'];
    _comment = parsedJson['comment'];
    _paymentMethodId = parsedJson['paymentMethodId'];

    if (parsedJson['svcItems'] != null) {
      _svcItems = new List<Services>();
      parsedJson['svcItems'].forEach((v) {
        _svcItems.add(new Services.fromJsonConfirmInvoice(v));
      });
    }
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provid'] = this._provid;
    data['requestid'] = this._requestid;
    data['cash'] = this._cash;
    data['comment'] = this._comment;
    data['paymentMethodId'] = this._paymentMethodId;
    if (this._svcItems != null) {
      data['svcItems'] =
          this._svcItems.map((v) => v.toJsonConfirmInvoice()).toList();
    }
    return data;
  }

}

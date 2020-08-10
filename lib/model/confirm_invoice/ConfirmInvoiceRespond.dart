import 'Invoice.dart';

class ConfirmInvoiceRespond {
  bool _success;
  String _code;
  Invoice _invoice;

  ConfirmInvoiceRespond(this._success, this._code, this._invoice);

  bool get success => _success;

  set success(bool success) => _success = success;

  String get code => _code;

  set code(String code) => _code = code;

  Invoice get invoce => _invoice;

  set invoice(Invoice invoice) => _invoice = invoice;

  ConfirmInvoiceRespond.fromJson(Map<String, dynamic> parsedJson) {
    _success = parsedJson['success'];
    _code = parsedJson['code'];
    if (parsedJson['paras'] != null)
      _invoice = Invoice.fromJson(parsedJson['paras']['invoice']);
  }

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//
//    data['success'] = _success;
//    data['code'] = _code;
//    if (_invoice != null) data['paras']['invoice'] = _invoice.toJson();
//  }
}

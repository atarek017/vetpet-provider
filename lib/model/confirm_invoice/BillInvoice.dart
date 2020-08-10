import 'package:vetwork_partner/model/services/Service.dart';

class BillInvoice {
  String _provid;
  String _requestid;

  List<Services> _svcItems;

  BillInvoice(this._provid, this._requestid, this._svcItems);

  String get provid => _provid;
  set provid(String provid) => _provid = provid;

  String get requestid => _requestid;
  set requestid(String requestid) => _requestid = requestid;

  List<Services> get svcItems => _svcItems;
  set svcItems(List<Services> svcItems) => _svcItems = svcItems;


  BillInvoice.fromJson(Map<String, dynamic> parsedJson) {
    _provid = parsedJson['provid'];
    _requestid = parsedJson['requestid'];
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
    if (this._svcItems != null) {
      data['svcItems'] =
          this._svcItems.map((v) => v.toJsonConfirmInvoice()).toList();
    }
    return data;
  }

}

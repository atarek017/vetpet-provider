import '../services/Service.dart';

class GetServicesRespond {
  bool _success;
  int _code;
  List<Services> _services;

  GetServicesRespond(this._success, this._code, this._services);

  bool get success => _success;

  set success(bool success) => _success = success;

  int get code => _code;

  set code(int code) => _code = code;

  List<Services> get services => _services;

  set services(List<Services> services) => _services = services;

  GetServicesRespond.fromJson(Map<String, dynamic> parsedJson) {
    _success = parsedJson['success'];
    _code = parsedJson['code'];
    if (parsedJson['paras']['services'] != null) {
      _services = new List<Services>();
      parsedJson['paras']['services'].forEach((v) {
        _services.add(new Services.fromJsonServiceList(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['sucess'] = this._success;
    if (this._services != null) {
      data['paras']['services'] =
          this._services.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class ConfirmRespond {
  bool _succeeded;
  String _providerId;
  String _code;

  ConfirmRespond({bool success, String code, String providerId}) {
    this._succeeded = success;
    this._code = code;
    this._providerId = providerId;
  }


  bool get success => _succeeded;
  set success(bool success) => _succeeded = success;
  String get code => _code;
  set code(String code) => _code = code;
  String get providerId => _providerId;
  set providerId(String providerId) => _providerId = providerId;

  ConfirmRespond.fromJson(Map<String, dynamic> json) {
    _succeeded = json['succeeded'];
    _providerId = json['providerId'];
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['succeeded'] = this._succeeded;
    data['code'] = this._code;
    data['providerId'] = this._providerId;

    return data;
  }



}

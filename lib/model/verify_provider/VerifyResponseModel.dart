class VerifyResponseModel {
  bool _success;
  String _code;

  VerifyResponseModel({bool success, String code}) {
    this._success = success;
    this._code = code;
  }

  bool get success => _success;

  set success(bool success) => _success = success;

  String get code => _code;

  set code(String code) => _code = code;

  VerifyResponseModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['succeeded'] = this._success;
    data['code'] = this._code;

    return data;
  }
}

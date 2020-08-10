class UserLoginRespond {
  bool _success;
  String _authToken;
  String _provId;
  String _code;

  UserLoginRespond(
      {bool success, String code, String authToken, String providerid}) {
    this._success = success;
    this._code = code;
    this._authToken = authToken;
    this._provId;
  }

  bool get success => _success;

  set success(bool success) => _success = success;

  String get code => _code;

  set code(String code) => _code = code;

  String get authToken => _authToken;

  set authToken(String authToken) => _authToken = authToken;

  String get provId => _provId;

  set provId(String provId) => _provId = provId;

  UserLoginRespond.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _code = json['code'];
    if (json['paras'] != null) {
      _authToken = json['paras']['authToken'];
      _provId = json['paras']['provId'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['code'] = this._code;
    data['paras']['authToken'] = this._authToken;
    data['paras']['provId'] = this._provId;
    return data;
  }
}

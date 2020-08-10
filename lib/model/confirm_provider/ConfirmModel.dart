class ConfirmModel {
  String _email;
  String _appid;
  String _password;
  String _deviceid;
  String _countrycode;
  String _phonenumber;
  String _token;

  ConfirmModel(this._email, this._appid, this._password,
      this._countrycode, this._phonenumber, this._token);

  String get email => _email;

  set email(String email) => _email = email;

  String get appid => _appid;

  set appid(String appid) => _appid = appid;

  String get password => _password;

  set password(String password) => _password = password;

  String get countrycode => _countrycode;

  set countrycode(String countrycode) => _countrycode = countrycode;

  String get phonenumber => _phonenumber;

  set phonenumber(String phonenumber) => _phonenumber = phonenumber;

  String get token => _token;

  set token(String token) => _token = token;

  String get deviceid => _deviceid;

  set deviceid(String deviceid) => _deviceid = deviceid;

  ConfirmModel.fromJson(Map<String, dynamic> parsedJson) {
    _email = parsedJson['email'];
    _appid = parsedJson['appid'];
    _password = parsedJson['password'];
    _deviceid = parsedJson['deviceid'];
    _countrycode = parsedJson['countrycode'];
    _phonenumber = parsedJson['phonenumber'];
    _token = parsedJson['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this._email;
    data['appid'] = this._appid;
    data['password'] = this._password;

    data['deviceid'] = this._deviceid;
    data['countrycode'] = this._countrycode;
    data['phonenumber'] = this._phonenumber;
    data['token'] = this._token;

    return data;
  }
}

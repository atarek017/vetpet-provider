class UserLoginModel {
  String _email;
  String _appid;
  String _password;

  UserLoginModel(this._email, this._appid, this._password);

  String get email => _email;

  set email(String email) => _email = email;

  String get appid => _appid;

  set appid(String appid) => _appid = appid;

  String get password => _password;

  set password(String password) => _password = password;

  UserLoginModel.fromJson(Map<String, dynamic> parsedJson) {
    _email = parsedJson['email'];
    _appid = parsedJson['appid'];
    _password = parsedJson['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this._email;
    data['appid'] = this._appid;
    data['password'] = this._password;
    return data;
  }
}

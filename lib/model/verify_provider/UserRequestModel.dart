class UserRequestModel{
  String email;
  String appid = 'KFB9368N-1XE5-4Z4E-R62A-9W4E26927J9G';
  String password;
  String deviceid;
  String countrycode;
  String phonenumber;

  UserRequestModel(this.email, this.password, this.deviceid,
      this.countrycode, this.phonenumber);

  UserRequestModel.fromJson(Map<String, dynamic> parsedJson) {
    email = parsedJson['email'];
    password = parsedJson['password'];
    deviceid = parsedJson['deviceid'];
    countrycode = parsedJson['countrycode'];
    phonenumber = parsedJson['phonenumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['deviceid'] = this.deviceid;
    data['appId'] = this.appid;
    data['countrycode'] = this.countrycode;
    data['phonenumber'] = this.phonenumber;
    return data;
  }


}

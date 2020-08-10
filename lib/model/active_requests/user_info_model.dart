class UserInfo {
  UserAddress addresses;
  String username;
  String countrycode;
  String phone;

  UserInfo({this.addresses, this.countrycode, this.phone, this.username});

  UserInfo.fromJson(Map<String, dynamic> parsedJson)
      : username = parsedJson['name'],
        countrycode = parsedJson['countrycode'],
        phone = parsedJson['phone'],
        addresses = UserAddress.fromJson(parsedJson['addresses']);
        
}

class UserAddress {


  String city;
  String countryIso;
  int id;
  String line1;
  String line2;
  String location;
  String postalcode;
  String state;


  UserAddress(
      {this.city,
      this.countryIso,
      this.id,
      this.line1,
      this.line2,
      this.location,
      this.postalcode,
      this.state});

  UserAddress.fromJson(Map<String, dynamic> parsedJson)
      : city = parsedJson['city'],
        countryIso = parsedJson['countryIso'],
        id = parsedJson['id'],
        line1 = parsedJson['line1'],
        line2 = parsedJson['line2'],
        location = parsedJson['location'],
        postalcode = parsedJson['postalcode'],
        state = parsedJson['state'];
}

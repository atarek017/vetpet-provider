// GENERATED CODE - DO NOT MODIFY BY HAND

part of UserModel;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
      email: json['email'] as String,
      password: json['password'] as String,
      appid: json['appid'] as String,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      services: json['svcTypIds'] as List<int>,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>));
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'appid': instance.appid,
      'fname': instance.fname,
      'lname': instance.lname,
      'svcTypIds': instance.services,
      'address': instance.address
    };

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
      line1: json['line1'] as String,
      line2: json['line2'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      postalcode: json['postalcode'] as String,
      countryiso: json['countryiso'] as String,
      location: json['location'] as String);
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'line1': instance.line1,
      'line2': instance.line2,
      'state': instance.state,
      'city': instance.city,
      'postalcode': instance.postalcode,
      'countryiso': instance.countryiso,
      'location': instance.location
    };

abstract class _$UserSerializerMixin {
  String get email;

  String get password;

  String get appid;

  String get fname;

  String get lname;

  List<int> get services;

  Address get address;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'password': password,
        'appid': appid,
        'fname': fname,
        'lname': lname,
        'svcTypIds': services,
        'address': address
      };
}

abstract class _$AddressSerializerMixin {
  String get line1;

  String get line2;

  String get state;

  String get city;

  String get postalcode;

  String get countryiso;

  String get location;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'line1': line1,
        'line2': line2,
        'state': state,
        'city': city,
        'postalcode': postalcode,
        'countryiso': countryiso,
        'location': location
      };
}

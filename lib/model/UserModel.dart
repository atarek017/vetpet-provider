library UserModel;

import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel extends Object with _$UserSerializerMixin{
  String email;
  String password;
  String appid;
  String fname;
  String lname;
  List<int> services;
  Address address;


  UserModel({this.email,
    this.password,
    this.appid,
    this.fname,
    this.lname,
    this.services,
    this.address});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);


}

@JsonSerializable()
class Address extends Object with _$AddressSerializerMixin{
  String line1;
  String line2;
  String state;
  String city;
  String postalcode;
  String countryiso;
  String location;

  Address(
      {this.line1,
        this.line2,
        this.state,
        this.city,
        this.postalcode,
        this.countryiso,
        this.location});

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

}
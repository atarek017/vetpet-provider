class RequestModel {
  bool _success;
  String _code;
  Paras _paras;

  RequestModel({bool success, String code, Paras paras}) {
    this._success = success;
    this._code = code;
    this._paras = paras;
  }

  bool get success => _success;
  set success(bool success) => _success = success;
  String get code => _code;
  set code(String code) => _code = code;
  Paras get paras => _paras;
  set paras(Paras paras) => _paras = paras;

  RequestModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _code = json['code'];
    _paras = json['paras'] != null ? new Paras.fromJson(json['paras']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['code'] = this._code;
    if (this._paras != null) {
      data['paras'] = this._paras.toJson();
    }
    return data;
  }
}

class Paras {
  List<Requests> _requests;

  Paras({List<Requests> requests}) {
    this._requests = requests;
  }

  List<Requests> get requests => _requests;
  set requests(List<Requests> requests) => _requests = requests;

  Paras.fromJson(Map<String, dynamic> json) {
    if (json['requests'] != null) {
      _requests = new List<Requests>();
      json['requests'].forEach((v) {
        _requests.add(new Requests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._requests != null) {
      data['requests'] = this._requests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Requests {
  int _reqId;
  String _location;
  String _visitTime;
  String _creationTime;
  String _city;
  String _countryIso;
  int _addressId;
  String _line1;
  String _line2;
  String _postalcode;
  String _state;
  String _svcCat;


  Requests(this._reqId, this._location, this._visitTime, this._creationTime,
      this._city, this._countryIso, this._addressId, this._line1, this._line2,
      this._postalcode, this._state, this._svcCat);

  Requests.fromJson(Map<String, dynamic> json) {
    _reqId = json['reqId'];
    _location = json['location'];
    _visitTime = json['visitTime'];
    _creationTime = json['creationTime'];
    _city = json['address']['city'];
    _countryIso= json['address']['countryIso'];
    _addressId= json['address']['id'];
    _line1= json['address']['line1'];
    _line2= json['address']['line2'];
    _postalcode= json['address']['postalcode'];
    _state= json['address']['state'];
    _svcCat = json['svcCats'][0];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reqId'] = this._reqId;
    data['location'] = this.location;
    return data;
  }


  int get reqId => _reqId;

  set reqId(int value) {
    _reqId = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }


  String get visitTime => _visitTime;

  set visitTime(String value) {
    _visitTime = value;
  }

  String get creationTime => _creationTime;

  set creationTime(String value) {
    _creationTime = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get countryIso => _countryIso;

  set countryIso(String value) {
    _countryIso = value;
  }

  int get addressId => _addressId;

  set addressId(int value) {
    _addressId = value;
  }

  String get line1 => _line1;

  set line1(String value) {
    _line1 = value;
  }

  String get line2 => _line2;

  set line2(String value) {
    _line2 = value;
  }

  String get postalcode => _postalcode;

  set postalcode(String value) {
    _postalcode = value;
  }

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  String get svcCat => _svcCat;

  set svcCat(String value) {
    _svcCat = value;
  }
}
/*
"reqId": 30,
                "location": "30.922187939286232,29.955758374202375",
                "visitTime": "2019-06-14T23:34:00",
                "creationTime": "2019-06-12T23:34:08.473",
                "address": {
                    "city": "Nour El Eslam 322–350",
                    "countryIso": "EG",
                    "id": 286,
                    "line1": "Nour El Eslam 322–350, 6th Of October, 6th Of October, Egypt",
                    "line2": "456",
                    "location": "30.922187939286232,29.955758374202375",
                    "postalcode": null,
                    "state": "6th Of October"
                },
                "svcCats": [
                    "Grooming"
                ]
 */
class PendingRequest {
  String _provid;
  String _location;
  String _countryIso;

  PendingRequest(String provid, String location, String countryIso) {
    this._provid = provid;
    this._location = location;
    this._countryIso = countryIso;
  }

  String get provid => _provid;
  set provid(String provid) => _provid = provid;
  String get location => _location;
  set location(String location) => _location = location;
  String get countryIso => _countryIso;
  set countryIso(String countryIso) => _countryIso = countryIso;

  PendingRequest.fromJson(Map<String, dynamic> json) {
    _provid = json['provid'];
    _location = json['location'];
    _countryIso = json['country_iso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provid'] = this._provid;
    data['location'] = this._location;
    data['country_iso'] = this._countryIso;
    return data;
  }
}
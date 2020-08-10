class PriceRequestModel {
  String _providerId;
  List<int> _svcIds;
  String _visitTime;
  String _country_iso;

  PriceRequestModel(
      this._providerId, this._svcIds, this._visitTime, this._country_iso);

  String get providerId => _providerId;

  set providerId(String providerId) => _providerId = providerId;

  List<int> get svcIds => _svcIds;

  set svcIds(List<int> svcIds) => _svcIds = svcIds;

  String get visitTime => _visitTime;

  set visitTime(String visitTime) => _visitTime = visitTime;

  String get country_iso => _country_iso;

  set country_iso(String country_iso) => _country_iso = country_iso;

  PriceRequestModel.fromJson(Map<String, dynamic> parsedJson) {
    _providerId = parsedJson['provid'];
    _svcIds = parsedJson['svcIds'];
    _visitTime = parsedJson['visitTime'];
    _country_iso = parsedJson['country_iso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provid'] = this._providerId;
    data['svcIds'] = this._svcIds;
    data['visitTime'] = this._visitTime;
    data['country_iso'] = this._country_iso;

    return data;
  }
}

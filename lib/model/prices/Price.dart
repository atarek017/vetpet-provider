class Price {
  int _svcId;
  double _price;
  String _currencyId;

  Price(this._svcId, this._price, this._currencyId);

  int get svcId => _svcId;

  set svcId(int svcId) => _svcId = svcId;

  double get price => _price;

  set price(double price) => _price = price;

  String get currencyId => _currencyId;

  set currencyId(String currencyId) => _currencyId = currencyId;

  Price.fromJson(Map<String, dynamic> parsedJson) {
    _svcId = parsedJson['svcId'];
    _price = parsedJson['price'];
    _currencyId = parsedJson['currencyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['svcId'] = this._svcId;
    data['price'] = this._price;
    data['currencyId'] = this._currencyId;
    return data;
  }
}

class Fees {
  double _fees;
  int _count;
  double _totalPrice;

  Fees(this._fees, this._count, this._totalPrice);

  double get fees => _fees;

  set fees(double fees) => _fees = fees;

  int get count => _count;

  set count(int count) => _count = count;

  double get totalPrice => _totalPrice;

  set totalPrice(double count) => _totalPrice = count;

  Fees.fromJson(Map<String, dynamic> parsedJson) {
    _fees = parsedJson['fees'];
    _count = parsedJson['count'];
    _totalPrice = parsedJson['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fees'] = this._fees;
    data['count'] = this._count;
    data['totalPrice'] = this._totalPrice;
    return data;
  }
}

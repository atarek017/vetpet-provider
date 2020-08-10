class RegExt {
  double _fees;
  String _currency;
  RegExt(this._fees, this._currency);

  double get fees => _fees;
  set fees(double fees) => _fees = fees;

  String get currency => _currency;
  set currency(String curr) => _currency = curr;

  RegExt.fromJson(Map<String, dynamic> parsedJson) {
    _fees = parsedJson['fees'];
    _currency = parsedJson['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fees'] = this._fees;
    data['currency'] = this._currency;
    return data;
  }
}

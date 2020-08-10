import 'Price.dart';
import 'RegExt.dart';

class GetPricesRespond {
  bool _success;
  int _code;
  List<Price> _prices;
  RegExt _regular;
  RegExt _extra;

  GetPricesRespond(
      this._success, this._code, this._prices, this._regular, this._extra);

  bool get success => _success;

  set success(bool success) => _success = success;

  int get code => _code;

  set code(int code) => _code = code;

  List<Price> get prices => _prices;

  set prices(List<Price> prices) => _prices = prices;

  RegExt get regular => _regular;

  set regular(RegExt reg) => _regular = reg;

  RegExt get extra => _extra;

  set extra(RegExt ext) => extra = ext;

  GetPricesRespond.fromJson(Map<String, dynamic> parsedJson) {
    _success = parsedJson['success'];
    _code = parsedJson['code'];

    if (parsedJson['paras']['prices'] != null) {
      _prices = new List<Price>();
      parsedJson['paras']['prices'].forEach((v) {
        _prices.add(new Price.fromJson(v));
      });
    }

    if (parsedJson['paras']['regular'] != null) {
      _regular = new RegExt.fromJson(parsedJson['paras']['regular']);
    }

    if (parsedJson['paras']['extra'] != null) {
      _regular = new RegExt.fromJson(parsedJson['paras']['extra']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['sucess'] = this._success;

    if (this._prices != null) {
      data['paras']['prices'] = this._prices.map((v) => v.toJson()).toList();
    }
    data['paras']['regular'] = this._regular.toJson();
    data['paras']['extra'] = this._extra.toJson();

    return data;
  }
}

class Services {
  int _id;
  int _typId;
  String _name;
  String _svcTypName;
  int _count;
  double _price;
  double _totalPrice;
  bool check;

  Services(
      this._id, this._typId, this._name, this._count, this._price, this.check);

  int get id => _id;

  set id(int id) => _id = id;

  int get typId => _typId;

  set typId(int typId) => _typId = typId;

  String get name => _name;

  set name(String name) => _name = name;

  int get count => _count;

  set count(int count) => _count = count;

  double get price => _price;

  set price(double price) => _price = price;

  double get totalPrice => _totalPrice;

  set totalPrice(double totalPrice) => _totalPrice = totalPrice;

  String get svcTypName => _svcTypName;

  set svcTypName(String svcTypName) => _svcTypName = svcTypName;

  Services.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _typId = parsedJson['typId'];
    _name = parsedJson['name'];
    if (parsedJson['svcTypName'] != null) {
      _svcTypName = parsedJson['svcTypName'];
    }
  }

  Services.fromFinalInvoices(Map<String, dynamic> parsedJson) {
    _id = parsedJson['svcId'];
    _name = parsedJson['svcName'];
    _count = parsedJson['count'];
    _price = parsedJson['price'];
    _totalPrice = parsedJson['totalPrice'];
  }

  Services.fromInvoicesServices(Map<String, dynamic> parsedJson) {
    _id = parsedJson['svcId'];
    _name = parsedJson['svcName'];
    _count = parsedJson['count'];
    _price = parsedJson['price'];
    _totalPrice = parsedJson['totalPrice'];
  }

  Services.fromJsonServiceList(Map<String, dynamic> parsedJson) {
    _id = parsedJson['value']['id'];
    _typId = parsedJson['value']['typId'];
    _name = parsedJson['value']['svcName'];
    if (parsedJson['value']['svcTypName'] != null) {
      _svcTypName = parsedJson['value']['svcTypName'];
    }
  }

  Services.fromJsonAcceptRequest(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _typId = parsedJson['svctTypId'];
    _name = parsedJson['svcName'];
    if (parsedJson['svcTypName'] != null) {
      _svcTypName = parsedJson['svcTypName'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['typId'] = this._typId;
    data['name'] = this._name;

    return data;
  }

  Services.fromJsonConfirmInvoice(Map<String, dynamic> json) {
    _id = json['svcId'];
    _count = json['count'];
  }

  Map<String, dynamic> toJsonConfirmInvoice() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['svcId'] = this._id;
    data['count'] = this._count;
    return data;
  }

  Services.fromJsonInvoice(Map<String, dynamic> json) {
    _id = json['svcId'];
    _count = json['count'];
    _price = json['price'];
    _totalPrice = json['totalPrice'];

    if (json['svcName'] != null) {
      _name = json['svcName'];
    }
  }

  Map<String, dynamic> toJsonInvoice() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['svcId'] = this._id;
    data['count'] = this._typId;
    data['price'] = this._price;
    data['totalPrice'] = this._totalPrice;
    return data;
  }
}

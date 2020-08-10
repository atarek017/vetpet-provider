class AcceptModel{
  String _provid;
  String _requestid;


  AcceptModel(this._provid, this._requestid);

  AcceptModel.fromJon(Map<String, dynamic> json) {

    this._provid = json['provid'];
    this._requestid = json['requestid'];
  }

  String get requestid => _requestid;

  set requestid(String value) {
    _requestid = value;
  }

  String get provid => _provid;

  set provid(String value) {
    _provid = value;
  }


}
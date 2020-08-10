class CancelRequestStatusModel {
  String _provid;
  String _requestid;
  String _comment;

  CancelRequestStatusModel(
      this._provid, this._requestid, this._comment);

  String get provid => _provid;

  set provid(String value) => _provid = value;

  String get requestid => _requestid;

  set requestid(String value) => _requestid = value;



  String get comment => _comment;

  set comment(String value) => _comment = value;

  CancelRequestStatusModel.fromJson(Map<String, dynamic> json) {
    _provid = json['provid'];
    _requestid = json['requestid'];
    _comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['provid'] = this._provid;
    data['requestid'] = this._requestid;
    data['comment'] = this._comment;
    return data;
  }
}

class ChangeRequestStatusModel {
  String _provid;
  String _requestid;
  String _statusId;
  String _comment;

  ChangeRequestStatusModel(
      this._provid, this._requestid, this._statusId, this._comment);

  String get provid => _provid;

  set provid(String value) => _provid = value;

  String get requestid => _requestid;

  set requestid(String value) => _requestid = value;

  String get statusId => _statusId;

  set statusId(String value) => _statusId = value;

  String get comment => _comment;

  set comment(String value) => _comment = value;

  ChangeRequestStatusModel.fromJson(Map<String, dynamic> json) {
    _provid = json['provid'];
    _requestid = json['requestid'];
    _statusId = json['statusId'];
    _comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['provid'] = this._provid;
    data['requestid'] = this._requestid;
    data['statusId'] = this._statusId;
    data['comment'] = this._comment;
    return data;
  }
}

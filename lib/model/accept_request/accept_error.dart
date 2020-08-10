class AcceptError{
  bool success;
  String code;

  AcceptError(this.success, this.code);

  AcceptError.fromJson(Map<String, dynamic> json){
    this.success = json['success'];
    this.code = json['code'];
  }


}